package com.lishe.camera.service.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.domain.UserHealthProfileRecord;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.administration.repository.UserHealthProfileRecordRepository;
import com.lishe.camera.api.response.CameraAnalysisResponse;
import com.lishe.camera.api.response.IdentifiedFood;
import com.lishe.camera.domain.CameraAnalysis;
import com.lishe.camera.exception.CameraException;
import com.lishe.camera.exception.InvalidImageException;
import com.lishe.camera.repository.CameraAnalysisRepository;
import com.lishe.camera.service.FoodCameraService;
import com.lishe.camera.service.GeminiVisionService;
import com.lishe.food.domain.Food;
import com.lishe.food.repository.FoodRepository;
import com.lishe.nutrition.api.request.MealItemRequest;
import com.lishe.nutrition.api.response.NutrientSummary;
import com.lishe.nutrition.service.NutritionCalculationService;
import com.lishe.rag.dto.FoodSearchResult;
import com.lishe.rag.service.SemanticFoodSearchService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.ArrayList;
import java.util.HexFormat;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class FoodCameraServiceImpl implements FoodCameraService {

    private static final long MAX_IMAGE_BYTES = 10L * 1024 * 1024;
    private static final String COHORT_PREGNANT    = "PREGNANT";
    private static final String COHORT_LACTATING   = "LACTATING";
    private static final String COHORT_ADOLESCENT  = "ADOLESCENT";
    private static final String COHORT_ADULT       = "ADULT";
    private static final String COHORT_DIABETES    = "NCD_DIABETES";
    private static final String COHORT_HYPERTENSION = "NCD_HYPERTENSION";
    private static final String COHORT_CHILD_UNDER5 = "CHILD_UNDER5";

    private final UserAccountRepository userAccountRepository;
    private final UserHealthProfileRecordRepository profileRepository;
    private final FoodRepository foodRepository;
    private final SemanticFoodSearchService semanticFoodSearchService;
    private final NutritionCalculationService nutritionCalculationService;
    private final GeminiVisionService geminiVisionService;
    private final CameraAnalysisRepository cameraAnalysisRepository;
    private final ObjectMapper objectMapper;

    @Override
    @Transactional
    public CameraAnalysisResponse analyzeImage(String email, byte[] imageBytes, String mimeType) {
        validateImage(imageBytes, mimeType);

        UserAccount account = userAccountRepository
                .findByEmail(email.trim().toLowerCase(Locale.ROOT))
                .orElseThrow(() -> new CameraException("Authenticated user not found"));

        List<IdentifiedFood> identifiedFoods = geminiVisionService.identifyFoods(imageBytes);
        List<MealItemRequest> mealItems   = new ArrayList<>();
        List<String> matchedFoods         = new ArrayList<>();
        List<String> unmatchedFoods       = new ArrayList<>();

        for (IdentifiedFood identifiedFood : identifiedFoods) {
            Optional<Food> matchedFood = resolveFood(identifiedFood);
            if (matchedFood.isPresent()) {
                Food food = matchedFood.get();
                matchedFoods.add(food.getFoodNameEn());
                mealItems.add(new MealItemRequest(food.getFoodId(), resolvedGrams(identifiedFood)));
            } else {
                unmatchedFoods.add(safeFoodName(identifiedFood));
            }
        }

        NutrientSummary nutrientSummary = mealItems.isEmpty()
                ? emptySummary()
                : nutritionCalculationService.calculateMealNutrients(mealItems);

        UserHealthProfileRecord profile = profileRepository.findByUser(account).orElse(null);
        String cohort        = determineCohort(profile);
        String aiExplanation = mealItems.isEmpty()
                ? "Hakuna vyakula vilivyolingana na hifadhidata ya TFNC. Tafadhali jaribu tena na picha iliyo wazi zaidi."
                : safeGenerateExplanation(nutrientSummary, cohort);

        CameraAnalysis saved = cameraAnalysisRepository.save(CameraAnalysis.builder()
                .account(account)
                .imageHash(md5Hex(imageBytes))
                .identifiedFoods(writeJson(identifiedFoods))
                .matchedFoods(writeJson(matchedFoods))
                .nutrientSummary(writeJson(nutrientSummary))
                .build());

        return new CameraAnalysisResponse(
                saved.getId(),
                identifiedFoods,
                matchedFoods,
                unmatchedFoods,
                nutrientSummary,
                aiExplanation,
                saved.getCreatedAt() == null ? LocalDateTime.now().toString() : saved.getCreatedAt().toString()
        );
    }

    // ─── helpers ─────────────────────────────────────────────────────────────

    private void validateImage(byte[] imageBytes, String mimeType) {
        if (imageBytes == null || imageBytes.length == 0) {
            throw new InvalidImageException("Image file is required");
        }
        if (imageBytes.length > MAX_IMAGE_BYTES) {
            throw new InvalidImageException("Image must not exceed 10MB");
        }
        String norm = normalizeMimeType(mimeType);
        if (!"image/jpeg".equals(norm) && !"image/png".equals(norm) && !"image/webp".equals(norm)) {
            throw new InvalidImageException("Unsupported image type. Use image/jpeg, image/png, or image/webp");
        }
    }

    private Optional<Food> resolveFood(IdentifiedFood food) {
        String name = safeFoodName(food);
        if (!StringUtils.hasText(name)) return Optional.empty();

        List<Food> exact = foodRepository.findByFoodNameEnContainingIgnoreCase(name);
        Optional<Food> match = exact.stream()
                .filter(f -> f.getFoodNameEn().equalsIgnoreCase(name))
                .findFirst();
        if (match.isPresent()) return match;
        if (!exact.isEmpty()) return Optional.of(exact.get(0));

        try {
            List<FoodSearchResult> semantic = semanticFoodSearchService.search(name, 1);
            return semantic.stream().map(FoodSearchResult::getFood).filter(Objects::nonNull).findFirst();
        } catch (Exception ex) {
            log.warn("Semantic search failed for '{}': {}", name, ex.getMessage());
            return Optional.empty();
        }
    }

    private double resolvedGrams(IdentifiedFood food) {
        Double g = food.estimatedGrams();
        return (g == null || g <= 0) ? 150.0 : g;
    }

    private String safeFoodName(IdentifiedFood food) {
        if (food == null || !StringUtils.hasText(food.nameEn())) return "";
        return food.nameEn().trim();
    }

    private String safeGenerateExplanation(NutrientSummary summary, String cohort) {
        try {
            return geminiVisionService.generateMealExplanation(summary, cohort);
        } catch (Exception ex) {
            log.warn("Gemini explanation failed: {}", ex.getMessage());
            return "Uchambuzi wa lishe umekamilika.";
        }
    }

    private NutrientSummary emptySummary() {
        return new NutrientSummary(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    }

    private String determineCohort(UserHealthProfileRecord profile) {
        if (profile == null) return COHORT_ADULT;

        String pregnancy = safeUpper(profile.getPregnancyStatus());
        if (StringUtils.hasText(pregnancy) && !"NONE".equals(pregnancy)) return COHORT_PREGNANT;

        String group = safeUpper(profile.getNutritionGroup());
        if (COHORT_LACTATING.equals(group)) return COHORT_LACTATING;

        if (profile.getDateOfBirth() != null) {
            int age = Period.between(profile.getDateOfBirth(), java.time.LocalDate.now()).getYears();
            if (age < 5)  return COHORT_CHILD_UNDER5;
            if (age < 18) return COHORT_ADOLESCENT;
        }

        String condition = safeUpper(profile.getHealthCondition());
        if (condition.contains("DIABETES"))    return COHORT_DIABETES;
        if (condition.contains("HYPERTENSION")) return COHORT_HYPERTENSION;

        return COHORT_ADULT;
    }

    private String safeUpper(String v) {
        return v == null ? "" : v.trim().toUpperCase(Locale.ROOT);
    }

    private String normalizeMimeType(String mimeType) {
        if (mimeType == null || mimeType.isBlank()) return "";
        return mimeType.split(";")[0].trim().toLowerCase(Locale.ROOT);
    }

    private String writeJson(Object value) {
        try {
            return objectMapper.writeValueAsString(value);
        } catch (JsonProcessingException ex) {
            throw new CameraException("Unable to serialize camera payload", ex);
        }
    }

    private String md5Hex(byte[] bytes) {
        try {
            return HexFormat.of().formatHex(MessageDigest.getInstance("MD5").digest(bytes));
        } catch (NoSuchAlgorithmException ex) {
            throw new CameraException("Unable to compute image hash", ex);
        }
    }
}
