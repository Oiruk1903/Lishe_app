package com.lishe.rag.service.impl;

import com.lishe.food.repository.FoodItemRepository;
import com.lishe.rag.dto.FoodSearchResult;
import com.lishe.rag.repository.FoodEmbeddingRepository;
import com.lishe.rag.service.EmbeddingService;
import com.lishe.rag.service.SemanticFoodSearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SemanticFoodSearchServiceImpl implements SemanticFoodSearchService {

    private final EmbeddingService embeddingService;
    private final FoodEmbeddingRepository foodEmbeddingRepository;
    private final FoodItemRepository foodRepository;

    @Override
    public List<FoodSearchResult> search(String query, int topK) {
        float[] vector = embeddingService.embed(query);
        String vecString = formatVector(vector);

        List<Object[]> results = foodEmbeddingRepository.findTopKWithScore(vecString, topK);

        return results.stream().map(row -> {
            UUID foodId = UUID.fromString((String) row[0]);
            Double score = ((Number) row[1]).doubleValue();
            
            return new FoodSearchResult(
                foodRepository.findByFoodId(foodId).orElse(null),
                score
            );
        }).collect(Collectors.toList());
    }

    @Override
    public List<FoodSearchResult> searchForNutrientGoal(String goal, int topK) {
        // Semantic search works directly with goals because the food text 
        // contains nutrient values and descriptive group names.
        return search(goal, topK);
    }

    private String formatVector(float[] vector) {
        return Arrays.toString(vector);
    }
}
