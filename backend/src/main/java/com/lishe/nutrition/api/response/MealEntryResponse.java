package com.lishe.nutrition.api.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class MealEntryResponse {

    private String id;          // MealLog.id (UUID string)
    private String userId;      // UserAccount.userId
    private String foodId;      // Food.foodId
    private String foodNameSw;
    private String foodNameEn;
    private String mealPeriod;
    private double quantity;
    private String unit;
    private double kcal;
    private double protein;
    private double carbs;
    private double fat;
    private String loggedAt;    // ISO-8601
    private boolean synced;
}
