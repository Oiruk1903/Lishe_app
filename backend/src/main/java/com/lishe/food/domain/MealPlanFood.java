package com.lishe.food.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * Represents a food item within a meal plan.
 * Maps specific foods to meal plans with serving sizes and meal type information.
 */
@Entity
@Table(name = "meal_plan_foods")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MealPlanFood {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "meal_plan_food_id")
    private UUID mealPlanFoodId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "plan_id", referencedColumnName = "plan_id", nullable = false)
    private MealPlan mealPlan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "food_id", referencedColumnName = "food_id", nullable = false)
    private Food food;

    @Column(name = "meal_type", nullable = false)
    @Enumerated(EnumType.STRING)
    private MealType mealType;

    @Column(name = "serving_size_g")
    private Double servingSizeG;

    @Column(name = "notes", length = 1000)
    private String notes;
}
