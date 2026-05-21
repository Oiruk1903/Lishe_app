package com.lishe.nutrition.service;

import com.lishe.nutrition.api.request.MealItemRequest;
import com.lishe.nutrition.api.response.BmiResult;
import com.lishe.nutrition.api.response.NutrientSummary;
import com.lishe.nutrition.api.response.NutrientTarget;
import com.lishe.nutrition.domain.UserHealthProfile;

import java.util.List;
import java.util.Map;
import java.util.UUID;

public interface NutritionCalculationService {

    BmiResult calculateBMI(double weightKg, double heightCm);

    double calculateBMR(double weightKg, double heightCm, int ageYears, String gender);

    double calculateTDEE(double bmr, String activityLevel);

    NutrientSummary calculateMealNutrients(List<MealItemRequest> items);

    double convertServingToGrams(UUID foodId, String servingLabel);

    Map<String, NutrientTarget> getDailyTargets(UserHealthProfile profile);
}