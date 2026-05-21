package com.lishe.nutrition.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDate;

@Getter
@AllArgsConstructor
public class DailyNutrientSummary {

    @JsonProperty("summary_date")
    private final LocalDate summaryDate;

    @JsonProperty("kcal_consumed")
    private final Double kcalConsumed;

    @JsonProperty("protein_consumed")
    private final Double proteinConsumed;

    @JsonProperty("carbs_consumed")
    private final Double carbsConsumed;

    @JsonProperty("fat_consumed")
    private final Double fatConsumed;

    @JsonProperty("iron_consumed")
    private final Double ironConsumed;

    @JsonProperty("calcium_consumed")
    private final Double calciumConsumed;

    @JsonProperty("kcal_target")
    private final Double kcalTarget;

    @JsonProperty("adherence_score")
    private final Double adherenceScore;

    @JsonProperty("created_at")
    private final String createdAt;
}