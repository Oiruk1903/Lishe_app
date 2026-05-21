package com.lishe.administration.service;

import com.lishe.administration.api.request.*;
import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.administration.api.response.MobileAuthResponse;
import com.lishe.administration.api.response.UserDto;
import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.domain.UserHealthProfileRecord;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.administration.repository.UserHealthProfileRecordRepository;
import com.lishe.jwt.service.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class SpecAuthService {

    private final UserAccountRepository userAccountRepository;
    private final UserHealthProfileRecordRepository profileRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final NotificationService notificationService;

    @Transactional
    public GenericRestResponse<MobileAuthResponse> register(RegisterRequest request) {
        userAccountRepository.findByEmail(request.getEmail().trim().toLowerCase()).ifPresent(u -> {
            throw new IllegalArgumentException("Account already exists with this email");
        });

        UserAccount user = new UserAccount();
        user.setFullName(request.getFullName());
        user.setEmail(request.getEmail().trim().toLowerCase());
        user.setPhoneNumber(request.getPhoneNumber());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setRole("USER");
        UserAccount savedUser = userAccountRepository.save(user);

        LocalDate dob = parseDateOfBirth(request.getDateOfBirth());

        UserHealthProfileRecord profile = new UserHealthProfileRecord();
        profile.setUser(savedUser);
        profile.setDateOfBirth(dob);
        profile.setGender(request.getGender());
        profile.setHealthCondition(request.getCategory());
        profile.setPregnancyStatus("unknown");
        profile.setNutritionGroup(computeNutritionGroup(dob, "unknown", request.getCategory()));
        profile.setDataEncrypted(Boolean.TRUE);
        UserHealthProfileRecord savedProfile = profileRepository.save(profile);

        UserDetails ud = toUserDetails(savedUser);
        String token = generateToken(savedUser);
        String refreshToken = jwtService.generateRefreshToken(ud);
        UserDto userDto = UserDto.from(savedUser, savedProfile);
        MobileAuthResponse data = MobileAuthResponse.builder()
                .user(userDto)
                .token(token)
                .refreshToken(refreshToken)
                .build();

        return response("200", "Registration successful", data);
    }

    @Transactional
    public GenericRestResponse<MobileAuthResponse> login(LoginRequest request) {
        UserAccount user = userAccountRepository.findByEmail(request.getEmail().trim().toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("Invalid credentials"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new IllegalArgumentException("Invalid credentials");
        }

        user.setLastLogin(LocalDateTime.now());
        userAccountRepository.save(user);

        UserHealthProfileRecord profile = profileRepository.findByUser(user).orElse(null);
        UserDetails ud = toUserDetails(user);
        String token = generateToken(user);
        String refreshToken = jwtService.generateRefreshToken(ud);
        UserDto userDto = UserDto.from(user, profile);
        MobileAuthResponse data = MobileAuthResponse.builder()
                .user(userDto)
                .token(token)
                .refreshToken(refreshToken)
                .build();

        return response("200", "Login successful", data);
    }

    @Transactional
    public GenericRestResponse<String> forgotPassword(ForgotPasswordRequest request) {
        String email = request.getEmail().trim().toLowerCase();
        UserAccount user = userAccountRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        String resetCode = String.format("%06d", new Random().nextInt(999999));
        user.setResetToken(passwordEncoder.encode(resetCode));
        userAccountRepository.save(user);

        notificationService.sendPasswordResetLink(email, resetCode);
        return response("200", "Reset code sent to your email", "Code sent");
    }

    @Transactional
    public GenericRestResponse<Boolean> verifyResetCode(VerifyResetCodeRequest request) {
        String email = request.getEmail().trim().toLowerCase();
        UserAccount user = userAccountRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (user.getResetToken() == null) {
            return response("200", "No reset code found", false);
        }

        boolean valid = passwordEncoder.matches(request.getCode(), user.getResetToken());
        return response("200", valid ? "Code is valid" : "Invalid code", valid);
    }

    @Transactional
    public GenericRestResponse<String> resetPassword(ResetPasswordRequest request) {
        String email = request.getEmail().trim().toLowerCase();
        UserAccount user = userAccountRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (user.getResetToken() == null || !passwordEncoder.matches(request.getCode(), user.getResetToken())) {
            throw new IllegalArgumentException("Invalid or expired reset code");
        }

        user.setPasswordHash(passwordEncoder.encode(request.getNewPassword()));
        user.setResetToken(null);
        userAccountRepository.save(user);

        return response("200", "Password reset successful", "Password updated");
    }

    @Transactional
    public GenericRestResponse<String> changePassword(String email, String oldPassword, String newPassword) {
        UserAccount user = userAccountRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (!passwordEncoder.matches(oldPassword, user.getPasswordHash())) {
            throw new IllegalArgumentException("Current password is incorrect");
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userAccountRepository.save(user);
        return response("200", "Password changed successfully", "Password updated");
    }

    public GenericRestResponse<UserDto> getProfile(String email) {
        UserAccount user = userAccountRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        UserHealthProfileRecord profile = profileRepository.findByUser(user).orElse(null);
        return response("200", "Profile retrieved", UserDto.from(user, profile));
    }

    @Transactional
    public GenericRestResponse<UserDto> updateProfile(String email, MobileProfileRequest request) {
        UserAccount user = userAccountRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (request.getFullName() != null) user.setFullName(request.getFullName());
        if (request.getPhoneNumber() != null) user.setPhoneNumber(request.getPhoneNumber());
        userAccountRepository.save(user);

        UserHealthProfileRecord profile = profileRepository.findByUser(user).orElse(null);
        if (profile != null) {
            if (request.getGender() != null) profile.setGender(request.getGender());
            if (request.getCohort() != null) profile.setNutritionGroup(request.getCohort());
            profileRepository.save(profile);
        }

        return response("200", "Profile updated", UserDto.from(user, profile));
    }

    public GenericRestResponse<MobileAuthResponse> refresh(String refreshToken) {
        String email;
        try {
            email = jwtService.extractUsername(refreshToken);
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid refresh token");
        }

        UserAccount user = userAccountRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        UserDetails ud = toUserDetails(user);
        if (!jwtService.isRefreshTokenValid(refreshToken, ud)) {
            throw new IllegalArgumentException("Refresh token expired or invalid");
        }

        UserHealthProfileRecord profile = profileRepository.findByUser(user).orElse(null);
        String newAccessToken = generateToken(user);
        String newRefreshToken = jwtService.generateRefreshToken(ud);
        UserDto userDto = UserDto.from(user, profile);
        MobileAuthResponse data = MobileAuthResponse.builder()
                .user(userDto)
                .token(newAccessToken)
                .refreshToken(newRefreshToken)
                .build();

        return response("200", "Token refreshed", data);
    }

    private String generateToken(UserAccount user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", user.getUserId().toString());
        claims.put("role", user.getRole());
        return jwtService.generateToken(claims, toUserDetails(user));
    }

    private UserDetails toUserDetails(UserAccount user) {
        return User.withUsername(user.getEmail())
                .password(user.getPasswordHash())
                .authorities(user.getRole(), "ROLE_" + user.getRole())
                .build();
    }

    private LocalDate parseDateOfBirth(String dob) {
        if (dob == null || dob.isBlank()) return null;
        try {
            return LocalDate.parse(dob.contains("T") ? dob.substring(0, 10) : dob);
        } catch (Exception e) {
            return null;
        }
    }

    public static String computeNutritionGroup(LocalDate dateOfBirth, String pregnancyStatus, String healthCondition) {
        int age = dateOfBirth == null ? 0 : Math.max(0, Period.between(dateOfBirth, LocalDate.now()).getYears());
        String safePregnancy = pregnancyStatus == null ? "" : pregnancyStatus.toLowerCase();
        String safeCondition = healthCondition == null ? "" : healthCondition.toLowerCase();

        if (safePregnancy.contains("pregnant") || safePregnancy.contains("lactating")) return "MATERNAL_CARE";
        if (age > 0 && age <= 5) return "EARLY_CHILDHOOD";
        if (safeCondition.contains("diabetes") || safeCondition.contains("hypertension") || safeCondition.contains("anemia")) return "CLINICAL_NUTRITION_SUPPORT";
        if (age >= 60) return "SENIOR_NUTRITION";
        return "GENERAL_ADULT_NUTRITION";
    }

    private <T> GenericRestResponse<T> response(String statusCode, String message, T data) {
        return new GenericRestResponse<>(
                LocalDateTime.now().toString(),
                statusCode,
                message,
                data
        );
    }
}
