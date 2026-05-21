package com.lishe.administration.service;

import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

@Service
@Log4j2
public class NotificationServiceStub implements NotificationService {
    @Override
    public void sendPasswordResetLink(String destination, String resetToken) {
        log.info("Stub notification sent to {} with reset token {}", destination, resetToken);
    }
}
