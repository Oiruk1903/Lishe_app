package com.lishe.recommendation.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

@Getter
@AllArgsConstructor
public class MealPlanResponse {

    @JsonProperty("plan_id")
    private final String planId;

    @JsonProperty("plan_title")
    private final String planTitle;

    @JsonProperty("meal_details")
    private final String mealDetails;

    @JsonProperty("dietary_suggestions")
    private final String dietarySuggestions;

    @JsonProperty("generated_at")
    private final String generatedAt;

    private final List<MealPlanFoodItemResponse> foods;
}
