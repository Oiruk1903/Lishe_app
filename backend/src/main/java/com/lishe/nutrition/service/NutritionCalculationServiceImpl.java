package com.lishe.nutrition.service;

import com.lishe.food.domain.Food;
import com.lishe.food.repository.FoodItemRepository;
import com.lishe.nutrition.api.request.MealItemRequest;
import com.lishe.nutrition.api.response.BmiResult;
import com.lishe.nutrition.api.response.NutrientSummary;
import com.lishe.nutrition.api.response.NutrientTarget;
import com.lishe.nutrition.domain.NutritionGuideline;
import com.lishe.nutrition.domain.ServingSize;
import com.lishe.nutrition.domain.UserHealthProfile;
import com.lishe.nutrition.exception.FoodNotFoundException;
import com.lishe.nutrition.exception.InsufficientDataException;
import com.lishe.nutrition.exception.InvalidServingException;
import com.lishe.localization.service.LocalizationService;
import com.lishe.nutrition.repository.NutritionGuidelineRepository;
import com.lishe.nutrition.repository.ServingSizeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.Period;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class NutritionCalculationServiceImpl implements NutritionCalculationService {

    private static final String COHORT_PREGNANT = "PREGNANT";
    private static final String COHORT_LACTATING = "LACTATING";
    private static final String COHORT_ADOLESCENT = "ADOLESCENT";
    private static final String COHORT_ADULT = "ADULT";
    private static final String COHORT_DIABETES = "NCD_DIABETES";
    private static final String COHORT_HYPERTENSION = "NCD_HYPERTENSION";
    private static final String COHORT_CHILD_UNDER5 = "CHILD_UNDER5";

    private final FoodItemRepository foodItemRepository;
    private final ServingSizeRepository servingSizeRepository;
    private final NutritionGuidelineRepository nutritionGuidelineRepository;
    private final LocalizationService localizationService;

    private static final Locale SWAHILI = Locale.forLanguageTag("sw");
    private static final Locale ENGLISH = Locale.ENGLISH;

    @Override
    public BmiResult calculateBMI(double weightKg, double heightCm) {
        requirePositive(weightKg, "weightKg");
        requirePositive(heightCm, "heightCm");

        double heightMeters = heightCm / 100.0;
        double bmi = weightKg / (heightMeters * heightMeters);
        String categoryEn = localizationService.getBmiCategory(bmi, ENGLISH);
        String categorySw = localizationService.getBmiCategory(bmi, SWAHILI);
        String adviceEn = localizationService.getBmiAdvice(bmi, ENGLISH);
        String adviceSw = localizationService.getBmiAdvice(bmi, SWAHILI);

        return new BmiResult(bmi, categoryEn, categorySw, adviceEn, adviceSw);
    }

    @Override
    public double calculateBMR(double weightKg, double heightCm, int ageYears, String gender) {
        requirePositive(weightKg, "weightKg");
        requirePositive(heightCm, "heightCm");
        if (ageYears <= 0) {
            throw new InsufficientDataException("Age is required for BMR calculation");
        }

        String normalizedGender = safeUpper(gender);
        if (normalizedGender.isBlank()) {
            throw new InsufficientDataException("Gender is required for BMR calculation");
        }

        return switch (normalizedGender) {
            case "MALE", "M" -> (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * ageYears) + 5.0;
            case "FEMALE", "F" -> (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * ageYears) - 161.0;
            default -> throw new InsufficientDataException("Unsupported gender for BMR calculation");
        };
    }

    @Override
    public double calculateTDEE(double bmr, String activityLevel) {
        if (bmr <= 0) {
            throw new InsufficientDataException("BMR must be greater than zero");
        }

        String normalized = safeUpper(activityLevel);
        double multiplier = switch (normalized) {
            case "SEDENTARY" -> 1.2;
            case "LIGHT" -> 1.375;
            case "MODERATE" -> 1.55;
            case "ACTIVE" -> 1.725;
            case "VERY_ACTIVE" -> 1.9;
            default -> throw new InsufficientDataException("Unsupported activity level for TDEE calculation");
        };

        return bmr * multiplier;
    }

    @Override
    @Transactional(readOnly = true)
    public NutrientSummary calculateMealNutrients(List<MealItemRequest> items) {
        double totalKcal = 0.0;
        double totalProtein = 0.0;
        double totalCarbs = 0.0;
        double totalFat = 0.0;
        double totalFibre = 0.0;
        double totalIron = 0.0;
        double totalCalcium = 0.0;
        double totalVitaminA = 0.0;

        if (items == null || items.isEmpty()) {
            return new NutrientSummary(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        }

        for (MealItemRequest item : items) {
            Food food = resolveFood(item.getFoodId());
            double quantityFactor = item.getQuantityGrams() / 100.0;

            totalKcal += scaled(food.getCaloriesPer100g(), quantityFactor);
            totalProtein += scaled(food.getProteinG(), quantityFactor);
            totalCarbs += scaled(food.getCarbsG(), quantityFactor);
            totalFat += scaled(food.getFatG(), quantityFactor);
            totalFibre += scaled(food.getFibreG(), quantityFactor);
            totalIron += scaled(food.getIronMg(), quantityFactor);
            totalCalcium += scaled(food.getCalciumMg(), quantityFactor);
            totalVitaminA += scaled(food.getVitaminAMcg(), quantityFactor);
        }

        return new NutrientSummary(totalKcal, totalProtein, totalCarbs, totalFat, totalFibre, totalIron, totalCalcium, totalVitaminA);
    }

    @Override
    @Transactional(readOnly = true)
    public double convertServingToGrams(UUID foodId, String servingLabel) {
        if (foodId == null) {
            throw new InvalidServingException("Food identifier is required");
        }

        String normalizedLabel = safeTrim(servingLabel);
        if (normalizedLabel.isBlank()) {
            throw new InvalidServingException("Serving label is required");
        }

        List<ServingSize> servingSizes = servingSizeRepository.findByFoodId(foodId);
        return servingSizes.stream()
                .filter(size -> matchesLabel(size, normalizedLabel))
                .map(ServingSize::getGramsEquivalent)
                .filter(value -> value != null)
            .mapToDouble(Float::doubleValue)
                .findFirst()
                .orElse(100.0);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, NutrientTarget> getDailyTargets(UserHealthProfile profile) {
        if (profile == null) {
            throw new InsufficientDataException("Health profile is required to determine nutrient targets");
        }

        String cohort = determineCohort(profile);
        List<NutritionGuideline> guidelines = nutritionGuidelineRepository.findByCohort(cohort);
        if (guidelines.isEmpty()) {
            throw new InsufficientDataException("No nutrition guidelines found for cohort: " + cohort);
        }

        Map<String, NutrientTarget> targets = new LinkedHashMap<>();
        for (NutritionGuideline guideline : guidelines) {
            String nutrientCode = safeUpper(guideline.getNutrientCode());
            targets.put(nutrientCode, new NutrientTarget(
                    guideline.getMinDaily() == null ? null : guideline.getMinDaily().doubleValue(),
                    guideline.getMaxDaily() == null ? null : guideline.getMaxDaily().doubleValue(),
                    guideline.getUnit(),
                    nutrientCode
            ));
        }

        return targets;
    }

    private Food resolveFood(UUID foodId) {
        if (foodId == null) {
            throw new FoodNotFoundException("Food identifier is required");
        }

        return foodItemRepository.findByFoodId(foodId)
                .orElseThrow(() -> new FoodNotFoundException("Food not found for foodId: " + foodId));
    }

    private double scaled(Double valuePer100g, double quantityFactor) {
        return (valuePer100g == null ? 0.0 : valuePer100g) * quantityFactor;
    }

    private boolean matchesLabel(ServingSize servingSize, String label) {
        return safeTrim(servingSize.getLabelEn()).equalsIgnoreCase(label)
                || safeTrim(servingSize.getLabelSw()).equalsIgnoreCase(label);
    }

    private String determineCohort(UserHealthProfile profile) {
        String explicitCohort = safeUpper(profile.getCohort());
        if (isKnownCohort(explicitCohort)) {
            return explicitCohort;
        }

        String pregnancyStatus = safeUpper(profile.getPregnancyStatus());
        if (!pregnancyStatus.isBlank() && !"NONE".equals(pregnancyStatus)) {
            return COHORT_PREGNANT;
        }

        String nutritionGroup = safeUpper(profile.getNutritionGroup());
        if (COHORT_LACTATING.equals(nutritionGroup)) {
            return COHORT_LACTATING;
        }

        Integer age = profile.getDateOfBirth() == null ? null : Period.between(profile.getDateOfBirth(), LocalDate.now()).getYears();
        if (age == null) {
            throw new InsufficientDataException("Date of birth is required to determine daily targets");
        }

        if (age < 18) {
            return COHORT_ADOLESCENT;
        }

        String healthCondition = safeUpper(profile.getHealthCondition());
        if (healthCondition.contains("DIABETES")) {
            return COHORT_DIABETES;
        }

        if (healthCondition.contains("HYPERTENSION")) {
            return COHORT_HYPERTENSION;
        }

        return COHORT_ADULT;
    }

    private boolean isKnownCohort(String cohort) {
        return COHORT_PREGNANT.equals(cohort)
                || COHORT_LACTATING.equals(cohort)
                || COHORT_ADOLESCENT.equals(cohort)
                || COHORT_ADULT.equals(cohort)
                || COHORT_DIABETES.equals(cohort)
                || COHORT_HYPERTENSION.equals(cohort)
                || COHORT_CHILD_UNDER5.equals(cohort);
    }

    private void requirePositive(double value, String fieldName) {
        if (value <= 0) {
            throw new InsufficientDataException(fieldName + " must be greater than zero");
        }
    }

    private String safeUpper(String value) {
        return safeTrim(value).toUpperCase(Locale.ROOT);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private BmiCategory bmiCategory(double bmi) {
        if (bmi < 18.5) {
            return BmiCategory.UNDERWEIGHT;
        }
        if (bmi < 25.0) {
            return BmiCategory.NORMAL;
        }
        if (bmi < 30.0) {
            return BmiCategory.OVERWEIGHT;
        }
        return BmiCategory.OBESE;
    }

    private enum BmiCategory {
        UNDERWEIGHT,
        NORMAL,
        OVERWEIGHT,
        OBESE
    }
}