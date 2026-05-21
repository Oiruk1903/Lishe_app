package com.lishe.nutrition.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class NutritionContentItemResponse {
    @JsonProperty("content_id")
    private final String contentId;

    @JsonProperty("category_id")
    private final String categoryId;

    @JsonProperty("category_name")
    private final String categoryName;

    private final String title;
    private final String body;
    private final String region;

    @JsonProperty("created_by")
    private final String createdBy;

    @JsonProperty("created_at")
    private final String createdAt;

    @JsonProperty("updated_at")
    private final String updatedAt;
}
