package com.lishe.analytics.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProgressSummary {
    private double currentBmi;
    private String bmiCategory;
    private String weightTrend; // e.g. "-1.2kg"
    private List<String> topGaps;
    private int streakDays;
}
