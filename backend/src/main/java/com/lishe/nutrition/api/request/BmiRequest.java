package com.lishe.nutrition.api.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BmiRequest {

    @NotNull
    @Positive
    private Double weightKg;

    @NotNull
    @Positive
    private Double heightCm;
}