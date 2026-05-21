package com.lishe.administration.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "user_health_profiles",
        indexes = @Index(name = "idx_user_health_profiles_user", columnList = "user_id", unique = true))
@Getter
@Setter
@NoArgsConstructor
public class UserHealthProfileRecord {

    @Id
    @Column(name = "profile_id", nullable = false, updatable = false)
    private UUID profileId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private UserAccount user;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "gender", length = 50)
    private String gender;

    @Column(name = "health_condition", length = 255)
    private String healthCondition;

    @Column(name = "pregnancy_status", length = 50)
    private String pregnancyStatus;

    @Column(name = "nutrition_group", length = 100)
    private String nutritionGroup;

    @Column(name = "data_encrypted")
    private Boolean dataEncrypted;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    void prePersist() {
        if (this.profileId == null) {
            this.profileId = UUID.randomUUID();
        }
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
