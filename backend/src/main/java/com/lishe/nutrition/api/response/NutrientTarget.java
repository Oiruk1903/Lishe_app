package com.lishe.nutrition.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class NutrientTarget {

    private final Double min;

    private final Double max;

    private final String unit;

    @JsonProperty("nutrient_code")
    private final String nutrientCode;
}