package com.lishe.nutrition.domain;

import com.lishe.administration.domain.AppUser;
import com.lishe.administration.domain.UserAccount;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "weight_logs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WeightLog {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private AppUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id")
    private UserAccount account;

    @Column(name = "weight_kg", nullable = false)
    private Float weightKg;

    @Column(name = "height_cm")
    private Float heightCm;

    @Column(name = "bmi_value")
    private Float bmiValue;

    @Column(name = "bmi_category")
    private String bmiCategory;

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

    @Column(name = "logged_at", nullable = false)
    private LocalDateTime loggedAt;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
