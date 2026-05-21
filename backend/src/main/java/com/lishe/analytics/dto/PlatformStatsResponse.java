package com.lishe.analytics.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlatformStatsResponse {
    private long totalUsers;
    private long activeToday;
    private double avgBmi;
    private Map<String, Long> topFoodsLogged;
    private Map<String, Long> cohortBreakdown;
}
