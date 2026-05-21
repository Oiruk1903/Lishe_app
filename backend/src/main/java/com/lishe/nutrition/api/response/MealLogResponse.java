package com.lishe.nutrition.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;
import java.util.UUID;

@Getter
@AllArgsConstructor
public class MealLogResponse {

    @JsonProperty("meal_log_id")
    private final UUID mealLogId;

    @JsonProperty("user_id")
    private final Long userId;

    @JsonProperty("meal_type")
    private final String mealType;

    private final String notes;

    @JsonProperty("logged_at")
    private final String loggedAt;

    @JsonProperty("created_at")
    private final String createdAt;

    @JsonProperty("nutrient_summary")
    private final NutrientSummary nutrientSummary;

    private final List<MealLogItemResponse> items;
}