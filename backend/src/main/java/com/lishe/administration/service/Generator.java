package com.lishe.administration.service;

import org.springframework.stereotype.Component;

import java.security.SecureRandom;

@Component
public class Generator {

    public String generateCustomId() {
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < 5; i++) {
            sb.append(String.format("%04x", random.nextInt(0x10000)));
            if (i < 4) sb.append("-");
        }
        for (int i = 0; i < 3; i++) {
            sb.append(String.format("%04x", random.nextInt(0x10000)));
            if (i < 2) sb.append("-");
        }
        sb.append(String.format("%04x", random.nextInt(0x10000)));
        sb.append("-");
        sb.append(String.format("%04x", random.nextInt(0x10000)));
        sb.append("-");
        for (int i = 0; i < 6; i++) {
            sb.append(String.format("%04x", random.nextInt(0x10000)));
            if (i < 5) sb.append("-");
        }

        return sb.toString();
    }

    public String generateOtp() {
        SecureRandom random = new SecureRandom();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

}
