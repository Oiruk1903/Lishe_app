package com.lishe.food.repository;

import com.lishe.food.domain.Food;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for managing Food entities.
 * This interface extends JpaRepository to provide CRUD operations for Food.
 */
@Repository
public interface FoodItemRepository extends JpaRepository<Food, UUID> {
    List<Food> findByFoodNameEnContainingIgnoreCase(String name);
    List<Food> findByFoodGroup(String group);
    List<Food> findByFoodGroupIgnoreCase(String group);
    Optional<Food> findByFoodId(UUID id);

    @org.springframework.data.jpa.repository.Query(
        "SELECT f FROM Food f WHERE " +
        "(:q IS NULL OR LOWER(f.foodNameEn) LIKE LOWER(CONCAT('%', :q, '%')) " +
        "              OR LOWER(f.foodNameSw) LIKE LOWER(CONCAT('%', :q, '%'))) " +
        "AND (:category IS NULL OR LOWER(f.foodGroup) = LOWER(:category)) " +
        "ORDER BY f.foodNameEn"
    )
    List<Food> searchFoods(
        @org.springframework.data.repository.query.Param("q") String q,
        @org.springframework.data.repository.query.Param("category") String category
    );
}
