package com.lishe.nutrition.api.response;

import lombok.Builder;
import lombok.Getter;

// Detailed BMI snapshot for the Flutter BMI gauge/card.
@Getter
@Builder
public class BmiResponse {

    private double bmi;
    private String category;        // English
    private String categorySw;      // Swahili
    private String advice;          // English advice
    private String adviceSw;        // Swahili advice
    private double weightKg;
    private double heightCm;
    private String recordedAt;      // ISO-8601

    // Ideal-weight range using Devine formula (±10 %)
    private double idealWeightKg;
    private double idealWeightMin;
    private double idealWeightMax;

    // Healthy BMI target mid-point (22.5)
    private double targetBmi;
    private double weightToTargetKg;  // how many kg to gain/lose
}
