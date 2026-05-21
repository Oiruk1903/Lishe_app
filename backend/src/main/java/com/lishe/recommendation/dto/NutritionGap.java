package com.lishe.recommendation.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NutritionGap {
    private String nutrientCode;
    private double currentValue;
    private double targetMin;
    private double gapPercent;
    private Priority priority;

    public enum Priority {
        CRITICAL, HIGH, MEDIUM, LOW
    }
}
