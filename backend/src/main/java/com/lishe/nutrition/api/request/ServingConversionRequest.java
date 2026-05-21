package com.lishe.nutrition.api.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ServingConversionRequest {

    @NotNull
    private UUID foodId;

    @NotBlank
    private String servingLabel;
}