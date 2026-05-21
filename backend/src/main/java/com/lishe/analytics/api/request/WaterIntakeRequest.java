package com.lishe.analytics.api.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WaterIntakeRequest {
    @NotNull
    @Positive
    private Integer glasses;
}
