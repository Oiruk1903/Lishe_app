package com.lishe.nutrition.domain;

import com.lishe.administration.domain.AppUser;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "daily_summaries")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailySummary {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private AppUser user;

    @Column(name = "summary_date", nullable = false)
    private LocalDate summaryDate;

    @Column(name = "kcal_consumed")
    private Float kcalConsumed;

    @Column(name = "protein_consumed")
    private Float proteinConsumed;

    @Column(name = "carbs_consumed")
    private Float carbsConsumed;

    @Column(name = "fat_consumed")
    private Float fatConsumed;

    @Column(name = "iron_consumed")
    private Float ironConsumed;

    @Column(name = "calcium_consumed")
    private Float calciumConsumed;

    @Column(name = "kcal_target")
    private Float kcalTarget;

    @Column(name = "adherence_score")
    private Float adherenceScore;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
