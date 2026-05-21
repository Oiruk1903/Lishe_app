package com.lishe.nutrition.api.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MealLogRequest {

    @NotEmpty
    @Valid
    private List<MealItemRequest> items;

    @NotBlank
    private String mealType;

    private String notes;
}