package com.lishe.chat.domain;

import com.lishe.administration.domain.UserAccount;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Represents a chat conversation log.
 * Records user messages and AI responses for auditing and analysis.
 */
@Entity
@Table(name = "chat_logs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatLog {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "log_id")
    private UUID logId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "user_id", nullable = false)
    private UserAccount user;

    @Column(name = "user_message", columnDefinition = "TEXT")
    private String userMessage;

    @Column(name = "ai_response", columnDefinition = "TEXT")
    private String aiResponse;

    @Column(name = "referral_flagged")
    private Boolean referralFlagged = false;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
