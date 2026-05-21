package com.lishe.nutrition.repository;

import com.lishe.nutrition.domain.NutritionGuideline;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface NutritionGuidelineRepository extends JpaRepository<NutritionGuideline, UUID> {
    List<NutritionGuideline> findByCohort(String cohort);
    Optional<NutritionGuideline> findByCohortAndNutrientCode(String cohort, String code);
}
