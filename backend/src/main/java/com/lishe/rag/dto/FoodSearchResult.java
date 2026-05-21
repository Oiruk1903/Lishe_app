package com.lishe.rag.dto;

import com.lishe.food.domain.Food;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FoodSearchResult {
    private Food food;
    private Double relevanceScore;
}
