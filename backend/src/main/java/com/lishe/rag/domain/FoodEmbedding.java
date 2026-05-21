package com.lishe.rag.domain;

import com.lishe.food.domain.Food;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "food_embeddings")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FoodEmbedding {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "food_id", referencedColumnName = "food_id")
    private Food food;

    @Column(name = "embedding", columnDefinition = "TEXT")
    @Convert(converter = FloatArrayVectorConverter.class)
    private float[] embedding;

    @Column(name = "embedded_text", columnDefinition = "TEXT")
    private String embeddedText;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
