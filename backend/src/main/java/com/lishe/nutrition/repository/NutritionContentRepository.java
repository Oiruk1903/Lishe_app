package com.lishe.nutrition.repository;

import com.lishe.nutrition.domain.NutritionContent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface NutritionContentRepository extends JpaRepository<NutritionContent, UUID> {

    @Query("""
            select content
            from NutritionContent content
            where (:categoryId is null or content.nutritionCategory.categoryId = :categoryId)
              and (:region is null or lower(content.region) = lower(:region))
            """)
    List<NutritionContent> searchByCategoryAndRegion(
            @Param("categoryId") UUID categoryId,
            @Param("region") String region
    );
}
