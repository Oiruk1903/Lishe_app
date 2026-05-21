package com.lishe.camera.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.lishe.nutrition.api.response.NutrientSummary;

import java.util.List;
import java.util.UUID;

public record CameraAnalysisResponse(
        @JsonProperty("analysis_id") UUID analysisId,
        @JsonProperty("identified_foods") List<IdentifiedFood> identifiedFoods,
        @JsonProperty("matched_foods") List<String> matchedFoods,
        @JsonProperty("unmatched_foods") List<String> unmatchedFoods,
        @JsonProperty("nutrient_summary") NutrientSummary nutrientSummary,
        @JsonProperty("ai_explanation") String aiExplanation,
        @JsonProperty("timestamp") String timestamp
) {
}
