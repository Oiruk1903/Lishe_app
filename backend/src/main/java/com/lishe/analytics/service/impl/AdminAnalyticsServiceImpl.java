package com.lishe.analytics.service.impl;

import com.lishe.administration.repository.AppUserRepository;
import com.lishe.analytics.dto.PlatformStatsResponse;
import com.lishe.analytics.service.AdminAnalyticsService;
import com.lishe.nutrition.repository.MealLogItemRepository;
import com.lishe.nutrition.repository.MealLogRepository;
import com.lishe.nutrition.repository.WeightLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AdminAnalyticsServiceImpl implements AdminAnalyticsService {

    private final AppUserRepository appUserRepository;
    private final MealLogRepository mealLogRepository;
    private final WeightLogRepository weightLogRepository;
    private final MealLogItemRepository mealLogItemRepository;

    @Override
    public PlatformStatsResponse getPlatformStats() {
        long totalUsers = appUserRepository.count();
        
        LocalDateTime start = LocalDate.now().atStartOfDay();
        LocalDateTime end = LocalDate.now().plusDays(1).atStartOfDay();
        long activeToday = mealLogRepository.countActiveUsersBetween(start, end);
        
        Double avgBmi = weightLogRepository.findAverageBmiValue();
        
        // Top Foods
        List<Object[]> topFoodRaw = mealLogItemRepository.findTopFoods(PageRequest.of(0, 5));
        Map<String, Long> topFoods = new HashMap<>();
        for (Object[] row : topFoodRaw) {
            topFoods.put(String.valueOf(row[0]), (Long) row[1]);
        }
        
        // Cohort Breakdown
        List<Object[]> cohortRaw = appUserRepository.countByCohort();
        Map<String, Long> cohortBreakdown = new HashMap<>();
        for (Object[] row : cohortRaw) {
            String cohort = row[0] != null ? String.valueOf(row[0]) : "Unknown";
            cohortBreakdown.put(cohort, (Long) row[1]);
        }

        return PlatformStatsResponse.builder()
                .totalUsers(totalUsers)
                .activeToday(activeToday)
                .avgBmi(avgBmi != null ? avgBmi : 0.0)
                .topFoodsLogged(topFoods)
                .cohortBreakdown(cohortBreakdown)
                .build();
    }
}
