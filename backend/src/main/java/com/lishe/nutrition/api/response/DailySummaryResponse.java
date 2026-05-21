package com.lishe.nutrition.api.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class DailySummaryResponse {

    private String date;        // yyyy-MM-dd
    private double calories;
    private double protein;
    private double carbs;
    private double fat;
    private double fiber;
    private int mealCount;
}
