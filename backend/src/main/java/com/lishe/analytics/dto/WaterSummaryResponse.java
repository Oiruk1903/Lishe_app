package com.lishe.analytics.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WaterSummaryResponse {
    private LocalDate date;
    private int totalMl;
    private int targetMl;
    private double percentageAchieved;
}
