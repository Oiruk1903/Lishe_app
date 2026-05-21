package com.lishe.recommendation.service;

import com.lishe.nutrition.api.response.NutrientSummary;
import com.lishe.nutrition.api.response.NutrientTarget;
import com.lishe.recommendation.dto.NutritionGap;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

@Component
public class NutritionGapAnalyser {

    public List<NutritionGap> analyse(NutrientSummary actual, Map<String, NutrientTarget> targets, String cohort) {
        List<NutritionGap> gaps = new ArrayList<>();

        for (Map.Entry<String, NutrientTarget> entry : targets.entrySet()) {
            String code = entry.getKey();
            NutrientTarget target = entry.getValue();
            if (target == null || target.getMin() == null) continue;

            double currentValue = getNutrientValue(actual, code);
            double deficit = target.getMin() - currentValue;
            
            if (deficit > 0) {
                double gapPercent = (deficit / target.getMin()) * 100;
                NutritionGap.Priority priority = determinePriority(code, gapPercent, deficit, cohort);
                
                gaps.add(NutritionGap.builder()
                        .nutrientCode(code)
                        .currentValue(currentValue)
                        .targetMin(target.getMin())
                        .gapPercent(gapPercent)
                        .priority(priority)
                        .build());
            }
        }

        gaps.sort(Comparator.comparing(NutritionGap::getPriority));
        return gaps;
    }

    private double getNutrientValue(NutrientSummary summary, String code) {
        return switch (code.toUpperCase()) {
            case "KCAL", "ENERGY" -> summary.getTotalKcal();
            case "PROTEIN" -> summary.getTotalProtein();
            case "CARBS" -> summary.getTotalCarbs();
            case "FAT" -> summary.getTotalFat();
            case "IRON" -> summary.getTotalIron();
            case "CALCIUM" -> summary.getTotalCalcium();
            case "VIT_A" -> summary.getTotalVitaminA();
            case "FIBRE" -> summary.getTotalFibre();
            default -> 0.0;
        };
    }

    private NutritionGap.Priority determinePriority(String code, double gapPercent, double deficit, String cohort) {
        String c = cohort != null ? cohort.toUpperCase() : "";
        
        if (code.equalsIgnoreCase("IRON") && gapPercent > 20 && (c.contains("PREGNANT") || c.contains("CHILD_UNDER5"))) {
            return NutritionGap.Priority.CRITICAL;
        }
        if (code.equalsIgnoreCase("PROTEIN") && gapPercent > 25) {
            return NutritionGap.Priority.HIGH;
        }
        if (code.equalsIgnoreCase("CALCIUM") && gapPercent > 20 && c.contains("ADOLESCENT")) {
            return NutritionGap.Priority.HIGH;
        }
        if ((code.equalsIgnoreCase("KCAL") || code.equalsIgnoreCase("ENERGY"))) {
            if (deficit > 400) return NutritionGap.Priority.HIGH;
            if (deficit > 200) return NutritionGap.Priority.MEDIUM;
        }
        if (code.equalsIgnoreCase("VIT_A") && gapPercent > 30) {
            return NutritionGap.Priority.HIGH;
        }
        
        if (gapPercent > 30) return NutritionGap.Priority.MEDIUM;
        if (gapPercent > 15) return NutritionGap.Priority.LOW;
        
        return NutritionGap.Priority.LOW;
    }
}
