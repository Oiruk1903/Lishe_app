package com.lishe.nutrition.service;

import com.lishe.nutrition.api.request.MealItemRequest;
import com.lishe.nutrition.api.response.DailyNutrientSummary;
import com.lishe.nutrition.api.response.MealLogResponse;
import com.lishe.nutrition.api.response.NutrientSummary;

import java.time.LocalDate;
import java.util.List;

public interface MealLogService {

    MealLogResponse logMeal(Long userId, List<MealItemRequest> items, String mealType, String notes);

    NutrientSummary getDailySummary(Long userId, LocalDate date);

    void updateDailySummary(Long userId, LocalDate date);

    List<DailyNutrientSummary> getWeeklyProgress(Long userId);
}