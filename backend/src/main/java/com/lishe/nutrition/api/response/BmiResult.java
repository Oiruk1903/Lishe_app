package com.lishe.nutrition.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class BmiResult {

    private final double value;

    @JsonProperty("category_en")
    private final String categoryEn;

    @JsonProperty("category_sw")
    private final String categorySw;

    @JsonProperty("advice_en")
    private final String adviceEn;

    @JsonProperty("advice_sw")
    private final String adviceSw;
}