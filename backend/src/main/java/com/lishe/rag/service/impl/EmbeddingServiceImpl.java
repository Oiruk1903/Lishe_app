package com.lishe.rag.service.impl;

import com.lishe.food.domain.Food;
import com.lishe.food.repository.FoodItemRepository;
import com.lishe.rag.domain.FoodEmbedding;
import com.lishe.rag.repository.FoodEmbeddingRepository;
import com.lishe.rag.service.EmbeddingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmbeddingServiceImpl implements EmbeddingService {

    private final EmbeddingModel embeddingModel;
    private final FoodItemRepository foodRepository;
    private final FoodEmbeddingRepository foodEmbeddingRepository;

    @Override
    public float[] embed(String text) {
        try {
            return embeddingModel.embed(text);
        } catch (Exception e) {
            log.error("Failed to generate embedding for text: {}", text, e);
            throw new RuntimeException("Embedding generation failed", e);
        }
    }

    @Override
    public String buildFoodText(Food food) {
        return String.format("%s (%s). Group: %s. Energy: %.1f kcal per 100g. Protein: %.1fg, Fat: %.1fg, Carbs: %.1fg. Iron: %.1fmg, Calcium: %.1fmg. %s",
                food.getFoodNameEn(),
                food.getFoodNameSw() != null ? food.getFoodNameSw() : "N/A",
                food.getFoodGroup(),
                food.getCaloriesPer100g() != null ? food.getCaloriesPer100g() : 0.0,
                food.getProteinG() != null ? food.getProteinG() : 0.0,
                food.getFatG() != null ? food.getFatG() : 0.0,
                food.getCarbsG() != null ? food.getCarbsG() : 0.0,
                food.getIronMg() != null ? food.getIronMg() : 0.0,
                food.getCalciumMg() != null ? food.getCalciumMg() : 0.0,
                food.getPreparationNotes() != null ? food.getPreparationNotes() : ""
        );
    }

    @Override
    @Transactional
    public void embedFood(UUID foodId) {
        if (foodEmbeddingRepository.findByFood_FoodId(foodId).isPresent()) {
            return;
        }

        Food food = foodRepository.findByFoodId(foodId)
                .orElseThrow(() -> new IllegalArgumentException("Food not found: " + foodId));

        String text = buildFoodText(food);
        float[] vector = embed(text);

        FoodEmbedding foodEmbedding = FoodEmbedding.builder()
                .food(food)
                .embedding(vector)
                .embeddedText(text)
                .build();

        foodEmbeddingRepository.save(foodEmbedding);
    }

    @Override
    @Async
    public void embedAllFoods() {
        List<Food> allFoods = foodRepository.findAll();
        AtomicInteger count = new AtomicInteger(0);
        AtomicInteger totalEmbedded = new AtomicInteger(0);

        log.info("Starting batch food embedding for {} foods...", allFoods.size());

        for (Food food : allFoods) {
            try {
                if (foodEmbeddingRepository.findByFood_FoodId(food.getFoodId()).isEmpty()) {
                    embedFood(food.getFoodId());
                    totalEmbedded.incrementAndGet();
                }
                
                int current = count.incrementAndGet();
                if (current % 50 == 0) {
                    log.info("Embedding progress: {}/{} foods processed...", current, allFoods.size());
                }
            } catch (Exception e) {
                log.error("Failed to embed food: {} ({})", food.getFoodNameEn(), food.getFoodId(), e);
            }
        }

        log.info("Batch embedding completed. New embeddings: {}, Total processed: {}", totalEmbedded.get(), count.get());
    }
}
