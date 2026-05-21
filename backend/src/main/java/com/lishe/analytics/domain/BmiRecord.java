package com.lishe.analytics.domain;

import com.lishe.administration.domain.AppUser;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "bmi_records")
public class BmiRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "record_id")
    private UUID recordId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @Column(name = "height_cm", nullable = false)
    private Double heightCm;

    @Column(name = "weight_kg", nullable = false)
    private Double weightKg;

    @Column(name = "bmi_value", nullable = false)
    private Double bmiValue;

    @Column(name = "bmi_category")
    private String bmiCategory;

    @CreationTimestamp
    @Column(name = "recorded_at", updatable = false)
    private LocalDateTime recordedAt;
}