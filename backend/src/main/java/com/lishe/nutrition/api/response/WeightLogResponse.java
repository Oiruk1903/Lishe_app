package com.lishe.nutrition.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.UUID;

@Getter
@AllArgsConstructor
public class WeightLogResponse {

    @JsonProperty("weight_log_id")
    private final UUID weightLogId;

    @JsonProperty("user_id")
    private final Long userId;

    @JsonProperty("weight_kg")
    private final Double weightKg;

    @JsonProperty("height_cm")
    private final Double heightCm;

    @JsonProperty("bmi_result")
    private final BmiResult bmiResult;

    @JsonProperty("logged_at")
    private final String loggedAt;

    @JsonProperty("created_at")
    private final String createdAt;
}