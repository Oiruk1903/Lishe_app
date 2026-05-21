package com.lishe.nutrition.repository;

import com.lishe.nutrition.domain.ServingSize;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ServingSizeRepository extends JpaRepository<ServingSize, UUID> {
    List<ServingSize> findByFoodFoodId(UUID foodId);

    @Query("select s from ServingSize s where s.food.foodId = :foodId")
    List<ServingSize> findByFoodId(UUID foodId);
}
