package com.lishe.analytics.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BmiRecord {
    private LocalDateTime date;
    private double bmiValue;
    private double weightKg;
    private double heightCm;
}
