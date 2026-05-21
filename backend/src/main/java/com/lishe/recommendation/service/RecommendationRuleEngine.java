package com.lishe.recommendation.service;

import com.lishe.food.domain.Food;
import com.lishe.nutrition.domain.ServingSize;
import com.lishe.nutrition.domain.UserHealthProfile;
import com.lishe.nutrition.repository.ServingSizeRepository;
import com.lishe.rag.dto.FoodSearchResult;
import com.lishe.rag.service.SemanticFoodSearchService;
import com.lishe.recommendation.dto.MealRecommendation;
import com.lishe.recommendation.dto.NutritionGap;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class RecommendationRuleEngine {

    private final SemanticFoodSearchService searchService;
    private final ServingSizeRepository servingSizeRepository;

    public List<MealRecommendation> recommend(List<NutritionGap> gaps, UserHealthProfile profile, int maxRecommendations) {
        Map<UUID, MealRecommendation> recommendations = new LinkedHashMap<>();

        for (NutritionGap gap : gaps) {
            if (recommendations.size() >= maxRecommendations) break;

            // Focus on CRITICAL and HIGH priority gaps first
            if (gap.getPriority() == NutritionGap.Priority.CRITICAL || gap.getPriority() == NutritionGap.Priority.HIGH) {
                String goal = String.format("high %s Tanzanian food for %s", gap.getNutrientCode(), profile.getCohort());
                List<FoodSearchResult> results = searchService.searchForNutrientGoal(goal, 3);

                for (FoodSearchResult res : results) {
                    if (recommendations.size() >= maxRecommendations) break;
                    
                    Food food = res.getFood();
                    if (food == null || recommendations.containsKey(food.getFoodId())) continue;

                    recommendations.put(food.getFoodId(), buildRecommendation(food, gap));
                }
            }
        }

        // If we still have space, look at MEDIUM gaps
        if (recommendations.size() < maxRecommendations) {
            for (NutritionGap gap : gaps) {
                if (recommendations.size() >= maxRecommendations) break;
                if (gap.getPriority() == NutritionGap.Priority.MEDIUM) {
                    String goal = String.format("source of %s Tanzanian food", gap.getNutrientCode());
                    List<FoodSearchResult> results = searchService.searchForNutrientGoal(goal, 2);
                    
                    for (FoodSearchResult res : results) {
                        if (recommendations.size() >= maxRecommendations) break;
                        Food food = res.getFood();
                        if (food == null || recommendations.containsKey(food.getFoodId())) continue;
                        recommendations.put(food.getFoodId(), buildRecommendation(food, gap));
                    }
                }
            }
        }

        return new ArrayList<>(recommendations.values());
    }

    private MealRecommendation buildRecommendation(Food food, NutritionGap gap) {
        List<ServingSize> servings = servingSizeRepository.findByFoodFoodId(food.getFoodId());
        float suggestedGrams = 100f;
        if (!servings.isEmpty()) {
            suggestedGrams = servings.get(0).getGramsEquivalent();
        }

        return MealRecommendation.builder()
                .food(food)
                .priority(gap.getPriority())
                .reasonCode(gap.getNutrientCode())
                .reasonTextEn("Good source of " + gap.getNutrientCode() + " to address your deficit.")
                .reasonTextSw("Chanzo kizuri cha " + translateNutrient(gap.getNutrientCode()) + " kurekebisha upungufu wako.")
                .suggestedGrams(suggestedGrams)
                .build();
    }

    private String translateNutrient(String code) {
        return switch (code.toUpperCase()) {
            case "IRON" -> "chuma";
            case "PROTEIN" -> "protini";
            case "CALCIUM" -> "kalsiamu";
            case "VIT_A" -> "vitamini A";
            case "KCAL", "ENERGY" -> "nguvu (kalori)";
            case "CARBS" -> "wanga";
            case "FAT" -> "mafuta";
            default -> code;
        };
    }
}
