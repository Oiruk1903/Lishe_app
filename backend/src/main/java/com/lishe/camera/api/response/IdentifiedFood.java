package com.lishe.camera.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;

public record IdentifiedFood(
        @JsonProperty("name_en") String nameEn,
        @JsonProperty("name_sw") String nameSw,
        @JsonProperty("confidence") Double confidence,
        @JsonProperty("estimated_grams") Double estimatedGrams
) {
}
