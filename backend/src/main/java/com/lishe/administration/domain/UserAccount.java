package com.lishe.administration.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "users")
@Getter
@Setter
public class UserAccount {

    @Id
    @Column(name = "user_id", nullable = false, updatable = false)
    private UUID userId;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "phone_number")
    private String phoneNumber;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Column(name = "reset_token")
    private String resetToken;

    @Column(name = "role", nullable = false)
    private String role;

    @Column(name = "location")
    private String location;

    @Column(name = "region_id")
    private UUID regionId;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    @PrePersist
    void prePersist() {
        if (this.userId == null) {
            this.userId = UUID.randomUUID();
        }
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
        if (this.role == null || this.role.isBlank()) {
            this.role = "USER";
        }
    }
}
