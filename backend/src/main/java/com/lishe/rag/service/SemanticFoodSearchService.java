package com.lishe.rag.service;

import com.lishe.rag.dto.FoodSearchResult;
import java.util.List;

public interface SemanticFoodSearchService {
    List<FoodSearchResult> search(String query, int topK);
    List<FoodSearchResult> searchForNutrientGoal(String goal, int topK);
}
