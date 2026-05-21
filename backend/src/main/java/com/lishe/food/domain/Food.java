package com.lishe.food.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

/**
 * Represents a food item in the system.
 * This entity stores comprehensive nutritional and regional availability data for foods.
 */
@Entity
@Table(name = "foods")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Food {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "food_id")
    private UUID foodId;

    @Column(name = "food_name_en", nullable = false, unique = true)
    private String foodNameEn;

    @Column(name = "food_name_sw")
    private String foodNameSw;

    @Column(name = "food_group")
    private String foodGroup;

    @Column(name = "calories_per_100g")
    private Double caloriesPer100g;

    @Column(name = "protein_g")
    private Double proteinG;

    @Column(name = "carbs_g")
    private Double carbsG;

    @Column(name = "fat_g")
    private Double fatG;

    @Column(name = "fibre_g")
    private Double fibreG;

    @Column(name = "iron_mg")
    private Double ironMg;

    @Column(name = "calcium_mg")
    private Double calciumMg;

    @Column(name = "vitamin_a_mcg")
    private Double vitaminAMcg;

    @Column(name = "preparation_notes", columnDefinition = "TEXT")
    private String preparationNotes;

    @OneToMany(mappedBy = "food", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<FoodRegionAvailability> foodRegionAvailabilities;

    @OneToMany(mappedBy = "food", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<MealPlanFood> mealPlanFoods;
}
