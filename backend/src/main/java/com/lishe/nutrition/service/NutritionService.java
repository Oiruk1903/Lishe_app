package com.lishe.nutrition.service;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.domain.UserHealthProfileRecord;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.administration.repository.UserHealthProfileRecordRepository;
import com.lishe.food.domain.Food;
import com.lishe.food.domain.FoodRegionAvailability;
import com.lishe.food.repository.FoodRegionAvailabilityRepository;
import com.lishe.nutrition.api.response.NutritionCategoryItemResponse;
import com.lishe.nutrition.api.response.NutritionContentItemResponse;
import com.lishe.nutrition.api.response.NutritionFoodItemResponse;
import com.lishe.nutrition.domain.NutritionCategory;
import com.lishe.nutrition.domain.NutritionContent;
import com.lishe.nutrition.repository.NutritionCategoryRepository;
import com.lishe.nutrition.repository.NutritionContentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NutritionService {

    private final NutritionCategoryRepository nutritionCategoryRepository;
    private final NutritionContentRepository nutritionContentRepository;
    private final FoodRegionAvailabilityRepository foodRegionAvailabilityRepository;
    private final UserAccountRepository userAccountRepository;
    private final UserHealthProfileRecordRepository profileRepository;

    @Transactional(readOnly = true)
    public GenericRestResponse<List<NutritionCategoryItemResponse>> getCategories() {
        List<NutritionCategoryItemResponse> categories = nutritionCategoryRepository.findAll().stream()
                .map(this::toCategoryResponse)
                .toList();

        return response("200", "Nutrition categories fetched", categories);
    }

    @Transactional(readOnly = true)
    public GenericRestResponse<List<NutritionContentItemResponse>> getContent(
            String authenticatedEmail,
            UUID categoryId,
            String region
    ) {
        UserAccount user = userAccountRepository.findByEmail(authenticatedEmail.toLowerCase(Locale.ROOT))
                .orElseThrow(() -> new IllegalArgumentException("Authenticated user not found"));

        UserHealthProfileRecord profile = profileRepository.findByUser(user)
                .orElseThrow(() -> new IllegalArgumentException("Health profile not found"));

        List<NutritionContent> base = nutritionContentRepository.searchByCategoryAndRegion(categoryId, normalize(region));

        String nutritionGroup = normalize(profile.getNutritionGroup());
        List<NutritionContent> filtered = base.stream()
                .filter(content -> isRelevantToNutritionGroup(content, nutritionGroup))
                .toList();

        List<NutritionContentItemResponse> payload = filtered.stream()
                .map(this::toContentResponse)
                .toList();

        return response("200", "Nutrition content fetched", payload);
    }

    @Transactional(readOnly = true)
    public GenericRestResponse<List<NutritionFoodItemResponse>> getFoodsByRegion(UUID regionId) {
        List<NutritionFoodItemResponse> foods = foodRegionAvailabilityRepository.findByRegionRegionId(regionId).stream()
                .map(this::toFoodResponse)
                .collect(Collectors.toList());

        return response("200", "Regional foods fetched", foods);
    }

    private NutritionCategoryItemResponse toCategoryResponse(NutritionCategory category) {
        return new NutritionCategoryItemResponse(
                category.getCategoryId().toString(),
                category.getCategoryName(),
                category.getDescription()
        );
    }

    private NutritionContentItemResponse toContentResponse(NutritionContent content) {
        return new NutritionContentItemResponse(
                content.getContentId().toString(),
                content.getNutritionCategory().getCategoryId().toString(),
                content.getNutritionCategory().getCategoryName(),
                content.getTitle(),
                content.getBody(),
                content.getRegion(),
                content.getCreatedBy(),
                content.getCreatedAt() == null ? null : content.getCreatedAt().toString(),
                content.getUpdatedAt() == null ? null : content.getUpdatedAt().toString()
        );
    }

    private NutritionFoodItemResponse toFoodResponse(FoodRegionAvailability availability) {
        Food food = availability.getFood();
        return new NutritionFoodItemResponse(
                food.getFoodId().toString(),
                food.getFoodNameEn(),
                food.getFoodNameSw(),
                food.getFoodGroup(),
                food.getCaloriesPer100g(),
                food.getProteinG(),
                food.getCarbsG(),
                food.getFatG(),
                food.getFibreG(),
                food.getIronMg(),
                food.getCalciumMg(),
                food.getVitaminAMcg(),
                food.getPreparationNotes(),
                availability.getSeason(),
                availability.getAvailabilityLevel(),
                availability.getIsStaple(),
                availability.getLocalName()
        );
    }

    private boolean isRelevantToNutritionGroup(NutritionContent content, String nutritionGroup) {
        if (nutritionGroup == null || nutritionGroup.isBlank()) {
            return true;
        }

        String haystack = String.join(" ",
                normalize(content.getTitle()),
                normalize(content.getBody()),
                normalize(content.getRegion())
        );

        String normalizedGroup = nutritionGroup.toLowerCase(Locale.ROOT).replace('_', ' ');
        if (haystack.contains(normalizedGroup)) {
            return true;
        }

        return Arrays.stream(normalizedGroup.split("\\s+"))
                .filter(token -> token.length() > 3)
                .anyMatch(haystack::contains);
    }

    private String normalize(String value) {
                return value == null ? "" : value.trim();
    }

    private <T> GenericRestResponse<T> response(String statusCode, String message, T data) {
        return new GenericRestResponse<>(
                LocalDateTime.now().toString(),
                statusCode,
                message,
                data
        );
    }
}
