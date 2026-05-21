package com.lishe.nutrition.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

/**
 * Represents a nutrition category.
 * Categories organize nutrition content and health profile information.
 */
@Entity
@Table(name = "nutrition_categories")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class NutritionCategory {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "category_id")
    private UUID categoryId;

    @Column(name = "category_name", nullable = false)
    private String categoryName;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @OneToMany(mappedBy = "nutritionCategory", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<UserHealthProfile> userHealthProfiles;

    @OneToMany(mappedBy = "nutritionCategory", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<NutritionContent> nutritionContents;
}
