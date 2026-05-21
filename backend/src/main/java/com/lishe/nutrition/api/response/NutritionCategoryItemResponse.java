package com.lishe.nutrition.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class NutritionCategoryItemResponse {
    @JsonProperty("category_id")
    private final String categoryId;

    @JsonProperty("category_name")
    private final String categoryName;

    private final String description;
}
