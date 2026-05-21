package com.lishe.nutrition.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.UUID;

@Getter
@AllArgsConstructor
public class MealLogItemResponse {

    @JsonProperty("meal_log_item_id")
    private final UUID mealLogItemId;

    @JsonProperty("food_id")
    private final UUID foodId;

    @JsonProperty("food_name_en")
    private final String foodNameEn;

    @JsonProperty("food_name_sw")
    private final String foodNameSw;

    @JsonProperty("quantity_grams")
    private final Double quantityGrams;

    @JsonProperty("kcal_snapshot")
    private final Double kcalSnapshot;

    @JsonProperty("protein_snapshot")
    private final Double proteinSnapshot;

    @JsonProperty("carbs_snapshot")
    private final Double carbsSnapshot;

    @JsonProperty("fat_snapshot")
    private final Double fatSnapshot;

    @JsonProperty("created_at")
    private final String createdAt;
}