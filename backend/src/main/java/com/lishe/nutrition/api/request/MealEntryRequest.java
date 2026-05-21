package com.lishe.nutrition.api.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class MealEntryRequest {

    @NotNull
    private UUID foodId;

    @NotBlank
    private String mealPeriod;   // breakfast | lunch | dinner | snack

    @NotNull
    @Positive
    private Double quantity;      // number of servings

    @NotBlank
    private String unit;          // g | portion | cup …

    private LocalDateTime loggedAt;  // optional; defaults to now
}
