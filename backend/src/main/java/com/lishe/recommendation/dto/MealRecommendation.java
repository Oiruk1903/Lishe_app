package com.lishe.recommendation.dto;

import com.lishe.food.domain.Food;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MealRecommendation {
    private Food food;
    private String reasonCode;
    private String reasonTextEn;
    private String reasonTextSw;
    private NutritionGap.Priority priority;
    private Float suggestedGrams;
}
