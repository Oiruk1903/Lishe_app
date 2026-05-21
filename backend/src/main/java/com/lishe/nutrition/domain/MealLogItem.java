package com.lishe.nutrition.domain;

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
@Table(name = "meal_log_items")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MealLogItem {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "meal_log_id")
    private MealLog mealLog;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "food_id", referencedColumnName = "food_id")
    private Food food;

    @Column(name = "quantity_grams", nullable = false)
    private Float quantityGrams;

    @Column(name = "kcal_snapshot")
    private Float kcalSnapshot;

    @Column(name = "protein_snapshot")
    private Float proteinSnapshot;

    @Column(name = "carbs_snapshot")
    private Float carbsSnapshot;

    @Column(name = "fat_snapshot")
    private Float fatSnapshot;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
