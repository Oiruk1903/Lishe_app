package com.lishe.analytics.service.impl;

import com.lishe.administration.domain.AppUser;
import com.lishe.administration.repository.AppUserRepository;
import com.lishe.analytics.dto.*;
import com.lishe.analytics.service.UserAnalyticsService;
import com.lishe.nutrition.domain.DailySummary;
import com.lishe.nutrition.domain.MealLog;
import com.lishe.nutrition.domain.WeightLog;
import com.lishe.nutrition.repository.DailySummaryRepository;
import com.lishe.nutrition.repository.MealLogRepository;
import com.lishe.nutrition.repository.WeightLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserAnalyticsServiceImpl implements UserAnalyticsService {

    private final WeightLogRepository weightLogRepository;
    private final DailySummaryRepository dailySummaryRepository;
    private final MealLogRepository mealLogRepository;
    private final AppUserRepository appUserRepository;

    @Override
    public List<BmiRecord> getBmiHistory(UUID userId, int days) {
        AppUser user = resolveUser(userId);
        List<WeightLog> logs = weightLogRepository.findByUser_IdOrderByLoggedAtDesc(user.getId());
        
        return logs.stream()
                .limit(days)
                .map(log -> BmiRecord.builder()
                        .date(log.getLoggedAt())
                        .bmiValue(log.getBmiValue() != null ? log.getBmiValue() : 0.0)
                        .weightKg(log.getWeightKg() != null ? log.getWeightKg() : 0.0)
                        .heightCm(log.getHeightCm() != null ? log.getHeightCm() : 0.0)
                        .build())
                .collect(Collectors.toList());
    }

    @Override
    public List<DailyValue> getNutrientTrend(UUID userId, String nutrientCode, int days) {
        AppUser user = resolveUser(userId);
        LocalDate startDate = LocalDate.now().minusDays(days);
        List<DailySummary> summaries = dailySummaryRepository.findByUser_IdAndSummaryDateAfterOrderBySummaryDateAsc(user.getId(), startDate);

        return summaries.stream().map(s -> DailyValue.builder()
                .date(s.getSummaryDate())
                .value(getNutrientValue(s, nutrientCode))
                .target(getNutrientTarget(s, nutrientCode))
                .build()
        ).collect(Collectors.toList());
    }

    @Override
    public CalorieBalanceReport getCalorieBalance(UUID userId, int days) {
        AppUser user = resolveUser(userId);
        LocalDate startDate = LocalDate.now().minusDays(days);
        List<DailySummary> summaries = dailySummaryRepository.findByUser_IdAndSummaryDateAfterOrderBySummaryDateAsc(user.getId(), startDate);

        List<CalorieBalanceReport.DailyBalance> dailyBalances = summaries.stream().map(s -> {
            double consumed = s.getKcalConsumed() != null ? s.getKcalConsumed() : 0.0;
            double target = s.getKcalTarget() != null ? s.getKcalTarget() : 0.0;
            return CalorieBalanceReport.DailyBalance.builder()
                    .date(s.getSummaryDate())
                    .consumed(consumed)
                    .target(target)
                    .balance(consumed - target)
                    .build();
        }).collect(Collectors.toList());

        double totalDeficit = 0;
        int deficitDays = 0;
        double totalSurplus = 0;
        int surplusDays = 0;

        for (CalorieBalanceReport.DailyBalance b : dailyBalances) {
            if (b.getBalance() < 0) {
                totalDeficit += Math.abs(b.getBalance());
                deficitDays++;
            } else if (b.getBalance() > 0) {
                totalSurplus += b.getBalance();
                surplusDays++;
            }
        }

        return CalorieBalanceReport.builder()
                .dailyBalances(dailyBalances)
                .avgDeficit(deficitDays > 0 ? totalDeficit / deficitDays : 0.0)
                .avgSurplus(surplusDays > 0 ? totalSurplus / surplusDays : 0.0)
                .daysTracked(summaries.size())
                .build();
    }

    @Override
    public double getAdherenceScore(UUID userId, int days) {
        AppUser user = resolveUser(userId);
        LocalDate startDate = LocalDate.now().minusDays(days);
        List<DailySummary> summaries = dailySummaryRepository.findByUser_IdAndSummaryDateAfterOrderBySummaryDateAsc(user.getId(), startDate);

        if (summaries.isEmpty()) return 0.0;

        return summaries.stream()
                .mapToDouble(s -> s.getAdherenceScore() != null ? s.getAdherenceScore() : 0.0)
                .average()
                .orElse(0.0);
    }

    @Override
    public ProgressSummary getProgressSummary(UUID userId) {
        AppUser user = resolveUser(userId);
        
        // BMI
        List<WeightLog> weightLogs = weightLogRepository.findByUser_IdOrderByLoggedAtDesc(user.getId());
        double currentBmi = 0.0;
        String category = "N/A";
        String weightTrend = "0.0kg";

        if (!weightLogs.isEmpty()) {
            WeightLog latest = weightLogs.get(0);
            currentBmi = latest.getBmiValue() != null ? latest.getBmiValue() : 0.0;
            category = latest.getBmiCategory() != null ? latest.getBmiCategory() : "N/A";
            
            // Weight trend (latest vs ~7 days ago)
            WeightLog old = weightLogs.stream()
                    .filter(l -> l.getLoggedAt().isBefore(LocalDateTime.now().minusDays(6)))
                    .findFirst()
                    .orElse(latest);
            
            double diff = latest.getWeightKg() - old.getWeightKg();
            weightTrend = String.format("%.1fkg", diff);
            if (diff > 0) weightTrend = "+" + weightTrend;
        }

        // Top Gaps
        List<DailySummary> lastSummaries = dailySummaryRepository.findByUser_IdAndSummaryDateAfterOrderBySummaryDateAsc(user.getId(), LocalDate.now().minusDays(3));
        List<String> topGaps = new ArrayList<>();
        if (!lastSummaries.isEmpty()) {
            DailySummary s = lastSummaries.get(lastSummaries.size() - 1);
            // Simple gap detection logic
            if (isDeficit(s.getProteinConsumed(), 50)) topGaps.add("Protein");
            if (isDeficit(s.getIronConsumed(), 15)) topGaps.add("Iron");
            if (isDeficit(s.getCalciumConsumed(), 800)) topGaps.add("Calcium");
        }

        // Streak
        int streak = calculateStreak(user.getId());

        return ProgressSummary.builder()
                .currentBmi(currentBmi)
                .bmiCategory(category)
                .weightTrend(weightTrend)
                .topGaps(topGaps.stream().limit(3).collect(Collectors.toList()))
                .streakDays(streak)
                .build();
    }

    private int calculateStreak(Long userId) {
        int streak = 0;
        LocalDate date = LocalDate.now();
        while (true) {
            LocalDateTime start = date.atStartOfDay();
            LocalDateTime end = date.plusDays(1).atStartOfDay();
            List<MealLog> logs = mealLogRepository.findByUser_IdAndLoggedAtBetween(userId, start, end);
            if (logs.isEmpty()) break;
            streak++;
            date = date.minusDays(1);
        }
        return streak;
    }

    private boolean isDeficit(Float consumed, double target) {
        return consumed == null || consumed < target;
    }

    private double getNutrientValue(DailySummary s, String code) {
        return switch (code.toUpperCase()) {
            case "KCAL" -> s.getKcalConsumed() != null ? s.getKcalConsumed() : 0.0;
            case "PROTEIN" -> s.getProteinConsumed() != null ? s.getProteinConsumed() : 0.0;
            case "CARBS" -> s.getCarbsConsumed() != null ? s.getCarbsConsumed() : 0.0;
            case "FAT" -> s.getFatConsumed() != null ? s.getFatConsumed() : 0.0;
            case "IRON" -> s.getIronConsumed() != null ? s.getIronConsumed() : 0.0;
            case "CALCIUM" -> s.getCalciumConsumed() != null ? s.getCalciumConsumed() : 0.0;
            default -> 0.0;
        };
    }

    private double getNutrientTarget(DailySummary s, String code) {
        // Fallback to kcal target for others if not explicitly tracked in summary columns
        return code.equalsIgnoreCase("KCAL") ? (s.getKcalTarget() != null ? s.getKcalTarget() : 0.0) : 0.0;
    }

    private AppUser resolveUser(UUID userId) {
        return appUserRepository.findByLisheId(userId.toString())
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));
    }
}
