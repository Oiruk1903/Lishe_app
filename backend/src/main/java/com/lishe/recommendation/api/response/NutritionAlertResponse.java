package com.lishe.recommendation.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class NutritionAlertResponse {

    @JsonProperty("alert_id")
    private final String alertId;

    @JsonProperty("alert_type")
    private final String alertType;

    private final String message;

    @JsonProperty("is_read")
    private final Boolean isRead;

    @JsonProperty("sent_at")
    private final String sentAt;
}
