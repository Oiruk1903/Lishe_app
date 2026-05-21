package com.lishe.nutrition.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class NutritionFoodItemResponse {
    @JsonProperty("food_id")
    private final String foodId;

    @JsonProperty("food_name_en")
    private final String foodNameEn;

    @JsonProperty("food_name_sw")
    private final String foodNameSw;

    @JsonProperty("food_group")
    private final String foodGroup;

    @JsonProperty("calories_per_100g")
    private final Double caloriesPer100g;

    @JsonProperty("protein_g")
    private final Double proteinG;

    @JsonProperty("carbs_g")
    private final Double carbsG;

    @JsonProperty("fat_g")
    private final Double fatG;

    @JsonProperty("fibre_g")
    private final Double fibreG;

    @JsonProperty("iron_mg")
    private final Double ironMg;

    @JsonProperty("calcium_mg")
    private final Double calciumMg;

    @JsonProperty("vitamin_a_mcg")
    private final Double vitaminAMcg;

    @JsonProperty("preparation_notes")
    private final String preparationNotes;

    private final String season;

    @JsonProperty("availability_level")
    private final String availabilityLevel;

    @JsonProperty("is_staple")
    private final Boolean isStaple;

    @JsonProperty("local_name")
    private final String localName;
}
