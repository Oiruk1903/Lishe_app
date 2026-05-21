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
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "meal_logs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MealLog {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private AppUser user;

    // Flutter / email-based users reference this instead of user
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id")
    private UserAccount account;

    @Column(name = "meal_type", nullable = false)
    private String mealType;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "logged_at", nullable = false)
    private LocalDateTime loggedAt;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "mealLog", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<MealLogItem> items;
}