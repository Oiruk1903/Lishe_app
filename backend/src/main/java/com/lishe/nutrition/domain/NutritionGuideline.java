package com.lishe.nutrition.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "nutrition_guidelines")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NutritionGuideline {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @Column(name = "nutrient_code", nullable = false)
    private String nutrientCode;

    @Column(name = "cohort", nullable = false)
    private String cohort;

    @Column(name = "min_daily")
    private Float minDaily;

    @Column(name = "max_daily")
    private Float maxDaily;

    @Column(name = "unit")
    private String unit;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
