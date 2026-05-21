package com.lishe.localization.service.impl;

import com.lishe.localization.service.LocalizationService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.MessageSource;
import org.springframework.context.NoSuchMessageException;
import org.springframework.stereotype.Service;

import java.util.Locale;

@Service
@RequiredArgsConstructor
public class LocalizationServiceImpl implements LocalizationService {

    private static final Locale SWAHILI = Locale.forLanguageTag("sw");

    private final MessageSource messageSource;

    @Override
    public String get(String key, Locale locale) {
        if (key == null || key.isBlank()) {
            return key;
        }

        Locale requested = locale == null ? SWAHILI : locale;
        String localized = resolve(key, requested);
        if (localized != null) {
            return localized;
        }

        if (!SWAHILI.equals(requested)) {
            localized = resolve(key, SWAHILI);
            if (localized != null) {
                return localized;
            }
        }

        return key;
    }

    @Override
    public String getBmiCategory(double bmi, Locale locale) {
        String key = bmi < 18.5 ? "bmi.underweight"
                : bmi < 25.0 ? "bmi.normal"
                : bmi < 30.0 ? "bmi.overweight"
                : "bmi.obese";
        return get(key, locale);
    }

    @Override
    public String getBmiAdvice(double bmi, Locale locale) {
        String key = bmi < 18.5 ? "bmi.advice.underweight"
                : bmi < 25.0 ? "bmi.advice.normal"
                : bmi < 30.0 ? "bmi.advice.overweight"
                : "bmi.advice.obese";
        return get(key, locale);
    }

    @Override
    public String getMealTypeLabel(String mealType, Locale locale) {
        return get(resolveMealTypeKey(mealType), locale);
    }

    @Override
    public String getNutritionGapLabel(String nutrientCode, Locale locale) {
        return get(resolveGapKey(nutrientCode), locale);
    }

    private String resolve(String key, Locale locale) {
        try {
            return messageSource.getMessage(key, null, locale);
        } catch (NoSuchMessageException ex) {
            return null;
        }
    }

    private String resolveMealTypeKey(String mealType) {
        if (mealType == null) {
            return mealType;
        }

        return switch (mealType.trim().toUpperCase(Locale.ROOT)) {
            case "BREAKFAST" -> "meal.breakfast";
            case "LUNCH" -> "meal.lunch";
            case "DINNER" -> "meal.dinner";
            case "SNACK" -> "meal.snack";
            default -> mealType;
        };
    }

    private String resolveGapKey(String nutrientCode) {
        if (nutrientCode == null) {
            return nutrientCode;
        }

        return switch (nutrientCode.trim().toUpperCase(Locale.ROOT)) {
            case "IRON" -> "nutrition.gap.iron";
            case "PROTEIN" -> "nutrition.gap.protein";
            case "CALCIUM" -> "nutrition.gap.calcium";
            case "KCAL", "ENERGY" -> "nutrition.gap.kcal";
            case "VIT_A", "VITAMIN_A" -> "nutrition.gap.vitamin_a";
            default -> nutrientCode;
        };
    }
}