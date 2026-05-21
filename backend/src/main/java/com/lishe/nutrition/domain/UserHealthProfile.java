package com.lishe.nutrition.domain;

import com.lishe.administration.domain.AppUser;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Represents a user's health profile.
 * Stores health-related information and dietary preferences for each user.
 */
@Entity
@Table(name = "user_health_profiles")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserHealthProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "profile_id")
    private UUID profileId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "id", nullable = false)
    private AppUser user;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "gender")
    private String gender;

    @Column(name = "health_condition")
    private String healthCondition;

    @Column(name = "pregnancy_status")
    private String pregnancyStatus;

    @Column(name = "nutrition_group")
    private String nutritionGroup;

    @Column(name = "cohort")
    private String cohort;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", referencedColumnName = "category_id")
    private NutritionCategory nutritionCategory;

    @Column(name = "data_encrypted")
    private Boolean dataEncrypted = false;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
