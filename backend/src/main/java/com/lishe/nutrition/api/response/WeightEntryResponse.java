package com.lishe.nutrition.api.response;

import com.lishe.nutrition.domain.WeightLog;
import lombok.Builder;
import lombok.Getter;

import java.time.format.DateTimeFormatter;

// camelCase — matches Flutter's WeightEntryModel.fromJson exactly.
@Getter
@Builder
public class WeightEntryResponse {

    private String id;
    private String userId;
    private double weight;      // weightKg — named 'weight' to match Flutter entity
    private double heightCm;
    private Double bmi;
    private String bmiCategory;
    private String bmiCategorySw;
    private String recordedAt;  // ISO-8601 — 'recordedAt' matches Flutter entity
    private boolean synced;
    private String note;

    public static WeightEntryResponse from(WeightLog log, String userId) {
        return WeightEntryResponse.builder()
                .id(log.getId().toString())
                .userId(userId)
                .weight(log.getWeightKg() != null ? log.getWeightKg() : 0.0)
                .heightCm(log.getHeightCm() != null ? log.getHeightCm() : 0.0)
                .bmi(log.getBmiValue() != null ? (double) log.getBmiValue() : null)
                .bmiCategory(log.getBmiCategory())
                .bmiCategorySw(swCategory(log.getBmiCategory()))
                .recordedAt(log.getLoggedAt() != null
                        ? log.getLoggedAt().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)
                        : null)
                .synced(true)
                .note(log.getNote())
                .build();
    }

    private static String swCategory(String en) {
        if (en == null) return null;
        return switch (en.trim().toLowerCase()) {
            case "underweight"  -> "Uzito Mdogo";
            case "normal"       -> "Kawaida";
            case "overweight"   -> "Uzito Kupita Kiasi";
            case "obese"        -> "Unene Kupindukia";
            default             -> en;
        };
    }
}
