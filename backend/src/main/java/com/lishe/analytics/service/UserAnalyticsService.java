package com.lishe.analytics.service;

import com.lishe.analytics.dto.*;
import java.util.List;
import java.util.UUID;

public interface UserAnalyticsService {
    List<BmiRecord> getBmiHistory(UUID userId, int days);
    List<DailyValue> getNutrientTrend(UUID userId, String nutrientCode, int days);
    CalorieBalanceReport getCalorieBalance(UUID userId, int days);
    double getAdherenceScore(UUID userId, int days);
    ProgressSummary getProgressSummary(UUID userId);
}
