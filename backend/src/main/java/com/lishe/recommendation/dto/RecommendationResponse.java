package com.lishe.recommendation.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecommendationResponse {
    private UUID recommendationId;
    private LocalDate date;
    private List<NutritionGap> gaps;
    private List<MealRecommendation> recommendations;
    private String aiExplanation;
}
