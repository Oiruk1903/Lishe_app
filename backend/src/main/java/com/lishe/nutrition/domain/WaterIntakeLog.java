package com.lishe.nutrition.domain;

import com.lishe.administration.domain.AppUser;
import com.lishe.administration.domain.UserAccount;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "water_intake_logs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class WaterIntakeLog {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "intake_id")
    private UUID intakeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private AppUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id")
    private UserAccount account;

    @Column(name = "amount_ml", nullable = false)
    private Integer amountMl;

    @Column(name = "logged_at", nullable = false)
    private LocalDateTime loggedAt;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}