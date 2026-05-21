package com.lishe.administration.service;

public interface NotificationService {
    void sendPasswordResetLink(String destination, String resetToken);
}
