package com.lishe.rag.service.impl;

import com.lishe.food.domain.Food;
import com.lishe.nutrition.domain.UserHealthProfile;
import com.lishe.rag.dto.FoodSearchResult;
import com.lishe.rag.service.ContextBuilderService;
import com.lishe.rag.service.SemanticFoodSearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ContextBuilderServiceImpl implements ContextBuilderService {

    private final SemanticFoodSearchService searchService;

    @Override
    public String buildContext(String userQuery, UserHealthProfile profile) {
        List<FoodSearchResult> topFoods = searchService.search(userQuery, 5);

        StringBuilder context = new StringBuilder();
        context.append("Relevant TFNC foods for your query:\n");

        for (int i = 0; i < topFoods.size(); i++) {
            if (context.length() > 2000) break; // Token budget protection

            Food food = topFoods.get(i).getFood();
            if (food == null) continue;

            context.append(String.format("%d. %s (%s) - %.1f kcal/100g, Protein: %.1fg, Iron: %.1fmg, Calcium: %.1fmg\n",
                    i + 1,
                    food.getFoodNameEn(),
                    food.getFoodNameSw() != null ? food.getFoodNameSw() : "N/A",
                    food.getCaloriesPer100g() != null ? food.getCaloriesPer100g() : 0.0,
                    food.getProteinG() != null ? food.getProteinG() : 0.0,
                    food.getIronMg() != null ? food.getIronMg() : 0.0,
                    food.getCalciumMg() != null ? food.getCalciumMg() : 0.0
            ));
        }

        context.append("\nUser profile: ");
        context.append(String.format("gender=%s, cohort=%s, health_condition=%s",
                profile.getGender() != null ? profile.getGender() : "Unknown",
                profile.getCohort() != null ? profile.getCohort() : "GENERAL",
                profile.getHealthCondition() != null ? profile.getHealthCondition() : "None"
        ));

        return context.toString();
    }
}
