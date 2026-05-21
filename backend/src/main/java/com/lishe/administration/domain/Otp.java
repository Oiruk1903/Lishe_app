package com.lishe.administration.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;


@Entity
@Table(name = "otp", indexes = {@Index(name = "idx_codes", columnList = "codes")})
@Getter
@Setter
public class Otp extends AbstractPersistableCustom<Long> {
    @Column(name = "mobile", nullable = false)
    private String mobile;
    @Column(name = "codes", nullable = false)
    private String codes;
    @Column(name = "device_token", nullable = true)
    private String deviceToken;
    @Column(name = "is_used", nullable = false)
    private Boolean isUsed = false;
    @Column(name = "failed_attempts", nullable = false)
    private int failedAttempts = 0;
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    @Column(name = "expiry_at", nullable = false, updatable = false)
    private LocalDateTime expiryAt;

    protected Otp() {}

    private Otp(final String mobile, final String otp, final int expiryMinutes, final String deviceToken) {
        this.mobile = mobile;
        this.codes = otp;
        this.deviceToken = deviceToken;
        this.isUsed = false;
        this.failedAttempts = 0;
        this.createdAt = LocalDateTime.now();
        this.expiryAt = this.createdAt.plusMinutes(expiryMinutes);
    }

    public static Otp of(final String mobile, final String otp, final int expiryMinutes, final String deviceToken) {
        return new Otp(mobile, otp, expiryMinutes, deviceToken);
    }

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(this.expiryAt);
    }

    public void incrementFailedAttempts() {
        this.failedAttempts++;
    }
}
