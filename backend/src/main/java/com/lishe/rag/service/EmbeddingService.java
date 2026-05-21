package com.lishe.rag.service;

import com.lishe.food.domain.Food;
import java.util.UUID;

public interface EmbeddingService {
    float[] embed(String text);
    String buildFoodText(Food food);
    void embedFood(UUID foodId);
    void embedAllFoods();
}
