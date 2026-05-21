package com.lishe.administration.api.request;

import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class ProfileRequest {
    @NotNull
    @Positive
    private Integer goalStatus;
    @NotNull
    @Positive
    private Integer activityStatus;
    @NotNull
    @Positive
    private Double weight;
    @NotNull
    @Positive
    @DecimalMin(value = "50.0", message = "Height must be at least 50 cm")
    @DecimalMax(value = "300.0", message = "Height must be at most 300 cm")
    private Double height;
    @Past(message = "Birth date must be in the past.")
    private LocalDate birthDate;
}
