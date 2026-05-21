package com.lishe.food.domain;

import com.lishe.administration.domain.UserAccount;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Represents a meal plan for a user.
 * Contains daily meal recommendations and dietary suggestions.
 */
@Entity
@Table(name = "meal_plans")
public class MealPlan {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "plan_id")
    private UUID planId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "user_id", nullable = false)
    private UserAccount user;

    @Column(name = "plan_title")
    private String planTitle;

    @Column(name = "meal_details", columnDefinition = "TEXT")
    private String mealDetails;

    @Column(name = "dietary_suggestions", columnDefinition = "TEXT")
    private String dietarySuggestions;

    @Column(name = "generated_at", nullable = false, updatable = false)
    private LocalDateTime generatedAt;

    @OneToMany(mappedBy = "mealPlan", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<MealPlanFood> mealPlanFoods;

    @PrePersist
    protected void onCreate() {
        generatedAt = LocalDateTime.now();
    }

    public UUID getPlanId() {
        return planId;
    }

    public void setPlanId(UUID planId) {
        this.planId = planId;
    }

    public UserAccount getUser() {
        return user;
    }

    public void setUser(UserAccount user) {
        this.user = user;
    }

    public String getPlanTitle() {
        return planTitle;
    }

    public void setPlanTitle(String planTitle) {
        this.planTitle = planTitle;
    }

    public String getMealDetails() {
        return mealDetails;
    }

    public void setMealDetails(String mealDetails) {
        this.mealDetails = mealDetails;
    }

    public String getDietarySuggestions() {
        return dietarySuggestions;
    }

    public void setDietarySuggestions(String dietarySuggestions) {
        this.dietarySuggestions = dietarySuggestions;
    }

    public LocalDateTime getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(LocalDateTime generatedAt) {
        this.generatedAt = generatedAt;
    }

    public List<MealPlanFood> getMealPlanFoods() {
        return mealPlanFoods;
    }

    public void setMealPlanFoods(List<MealPlanFood> mealPlanFoods) {
        this.mealPlanFoods = mealPlanFoods;
    }
}
