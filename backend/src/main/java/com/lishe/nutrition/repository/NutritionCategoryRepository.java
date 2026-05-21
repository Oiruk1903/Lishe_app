package com.lishe.nutrition.repository;

import com.lishe.nutrition.domain.NutritionCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface NutritionCategoryRepository extends JpaRepository<NutritionCategory, UUID> {
}
