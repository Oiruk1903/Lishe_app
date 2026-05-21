package com.lishe.nutrition.repository;

import com.lishe.nutrition.domain.MealLogItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface MealLogItemRepository extends JpaRepository<MealLogItem, UUID> {
    List<MealLogItem> findByMealLog_Id(UUID mealLogId);

    @org.springframework.data.jpa.repository.Query("SELECT m.food.foodId, COUNT(m) FROM MealLogItem m GROUP BY m.food.foodId ORDER BY COUNT(m) DESC")
    List<Object[]> findTopFoods(org.springframework.data.domain.Pageable pageable);
}
