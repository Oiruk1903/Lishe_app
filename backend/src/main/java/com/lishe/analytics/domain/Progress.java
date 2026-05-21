package com.lishe.analytics.domain;

import com.lishe.administration.domain.AbstractPersistableCustom;
import jakarta.persistence.*;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "progress")
public class Progress extends AbstractPersistableCustom<Long> {
    @Column(name = "lishe_id", nullable = false)
    private String lisheId;

    @PositiveOrZero
    @Column(name = "metric_type", nullable = false)
    private Double metricValue;// e.g., 70.5, 2.0, 30.0

    @Column(name = "metric_units", nullable = false)
    private String metricUnits;// e.g., kg, liters, minutes e.t.c.

    @Column(name = "target_value")
    private Double targetValue;

    @Column(name = "progress_type", nullable = false)
    @Positive
    private Integer progressType;

    @Enumerated(EnumType.STRING)
    @Column(name = "period_type")
    private PeriodType periodType;

    @Column(name = "is_goal_met")
    private Boolean isGoalMet;

    @Column(name = "notes")
    private String notes;

    @Column(name = "logged_date", nullable = false)
    private LocalDate loggedDate;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    protected Progress() {
        // Default constructor for JPA
    }

    public static Progress ofWaterIntake(String lisheId, Double metricValue, String metricUnits) {
        final String description = ProgressDescription.WATER_INTAKE;
        return new Progress(lisheId, metricValue, metricUnits, ProgressType.WATER_INTAKE.getValue(), description);
    }

    public static Progress ofStepsWalked(String lisheId, Double metricValue, String metricUnits) {
        final String description = ProgressDescription.STEPS_WALKED;
        return new Progress(lisheId, metricValue, metricUnits, ProgressType.STEPS_WALKED.getValue(), description);
    }

    public static Progress ofMealFollowed(String lisheId, Double metricValue, String metricUnits) {
        final String description = ProgressDescription.MEAL_FOLLOWED;
        return new Progress(lisheId, metricValue, metricUnits, ProgressType.MEAL_FOLLOWED.getValue(), description);
    }

    private Progress(String lisheId, Double metricValue, String metricUnits, Integer progressType, String description) {
        this.lisheId = lisheId;
        this.metricValue = metricValue;
        this.metricUnits = metricUnits;
        this.progressType = progressType;
        this.notes = description;
        this.loggedDate = LocalDate.now();
    }

    public boolean isGoalMet(){
        return this.metricValue >= this.targetValue;
    }

}
