package com.lishe.nutrition.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class NutrientSummary {

    @JsonProperty("total_kcal")
    private final double totalKcal;

    @JsonProperty("total_protein")
    private final double totalProtein;

    @JsonProperty("total_carbs")
    private final double totalCarbs;

    @JsonProperty("total_fat")
    private final double totalFat;

    @JsonProperty("total_fibre")
    private final double totalFibre;

    @JsonProperty("total_iron")
    private final double totalIron;

    @JsonProperty("total_calcium")
    private final double totalCalcium;

    @JsonProperty("total_vitamin_a")
    private final double totalVitaminA;
}