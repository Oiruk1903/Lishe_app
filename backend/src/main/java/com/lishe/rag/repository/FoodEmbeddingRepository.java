package com.lishe.rag.repository;

import com.lishe.rag.domain.FoodEmbedding;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface FoodEmbeddingRepository extends JpaRepository<FoodEmbedding, UUID> {
    Optional<FoodEmbedding> findByFood_FoodId(UUID foodId);

    @Query(value = "SELECT food_id FROM food_embeddings ORDER BY embedding <=> CAST(:vec AS vector) LIMIT :k", nativeQuery = true)
    List<UUID> findTopKSimilar(@Param("vec") String vec, @Param("k") int k);

    @Query(value = "SELECT CAST(food_id AS VARCHAR), (1 - (embedding <=> CAST(:vec AS vector))) as score FROM food_embeddings ORDER BY embedding <=> CAST(:vec AS vector) LIMIT :k", nativeQuery = true)
    List<Object[]> findTopKWithScore(@Param("vec") String vec, @Param("k") int k);
}
