package com.lishe.nutrition.api.response;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

// Chart-ready weight trend payload.
@Getter
@Builder
public class WeightTrendResponse {

    private List<TrendPoint> entries;
    private TrendStats stats;

    @Getter
    @Builder
    public static class TrendPoint {
        private String date;       // yyyy-MM-dd
        private double weight;
        private Double bmi;
    }

    @Getter
    @Builder
    public static class TrendStats {
        private double startWeight;
        private double currentWeight;
        private double change;              // current − start (negative = loss)
        private String trend;               // "decreasing" | "increasing" | "stable"
        private double averageWeeklyChange;
        private double lowestWeight;
        private double highestWeight;
        private int totalEntries;
    }
}
