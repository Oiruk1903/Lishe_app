package com.lishe.nutrition.api.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

@Data
public class WeightTrackRequest {

    @NotNull
    @Positive
    private Double weightKg;

    // Optional — backend falls back to the most recent logged height.
    // Must be supplied on the first ever weight entry.
    @Positive
    private Double heightCm;

    private String note;
}
