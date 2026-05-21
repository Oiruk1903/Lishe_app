package com.lishe.alert.domain;

import com.lishe.administration.domain.UserAccount;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Represents a nutrition alert for a user.
 * Alerts notify users about nutritional recommendations, warnings, or status updates.
 */
@Entity
@Table(name = "nutrition_alerts")
public class NutritionAlert {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "alert_id")
    private UUID alertId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "user_id", nullable = false)
    private UserAccount user;

    @Column(name = "alert_type")
    private String alertType;

    @Column(name = "message", columnDefinition = "TEXT")
    private String message;

    @Column(name = "is_read")
    private Boolean isRead = false;

    @Column(name = "sent_at", nullable = false, updatable = false)
    private LocalDateTime sentAt;

    @PrePersist
    protected void onCreate() {
        sentAt = LocalDateTime.now();
    }

    public UUID getAlertId() {
        return alertId;
    }

    public void setAlertId(UUID alertId) {
        this.alertId = alertId;
    }

    public UserAccount getUser() {
        return user;
    }

    public void setUser(UserAccount user) {
        this.user = user;
    }

    public String getAlertType() {
        return alertType;
    }

    public void setAlertType(String alertType) {
        this.alertType = alertType;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Boolean getIsRead() {
        return isRead;
    }

    public void setIsRead(Boolean isRead) {
        this.isRead = isRead;
    }

    public LocalDateTime getSentAt() {
        return sentAt;
    }

    public void setSentAt(LocalDateTime sentAt) {
        this.sentAt = sentAt;
    }
}
