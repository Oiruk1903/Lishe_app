package com.lishe.recommendation.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class MealPlanFoodItemResponse {

    @JsonProperty("meal_plan_food_id")
    private final String mealPlanFoodId;

    @JsonProperty("food_id")
    private final String foodId;

    @JsonProperty("food_name_en")
    private final String foodNameEn;

    @JsonProperty("meal_type")
    private final String mealType;

    @JsonProperty("serving_size_g")
    private final Float servingSizeG;

    private final String notes;
}
