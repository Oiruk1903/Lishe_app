package com.lishe.analytics.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CalorieBalanceReport {
    private List<DailyBalance> dailyBalances;
    private double avgDeficit;
    private double avgSurplus;
    private int daysTracked;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DailyBalance {
        private LocalDate date;
        private double consumed;
        private double target;
        private double balance;
    }
}
