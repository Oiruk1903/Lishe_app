package com.lishe.localization.service;

import java.util.Locale;

public interface LocalizationService {

    String get(String key, Locale locale);

    String getBmiCategory(double bmi, Locale locale);

    String getBmiAdvice(double bmi, Locale locale);

    String getMealTypeLabel(String mealType, Locale locale);

    String getNutritionGapLabel(String nutrientCode, Locale locale);
}