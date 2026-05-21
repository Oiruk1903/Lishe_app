package com.lishe.administration.service;

import com.lishe.administration.api.request.SpecProfileUpdateRequest;
import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.administration.api.response.ProfileEnvelopeResponse;
import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.domain.UserHealthProfileRecord;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.administration.repository.UserHealthProfileRecordRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SpecProfileService {

    private final UserAccountRepository userAccountRepository;
    private final UserHealthProfileRecordRepository profileRepository;

    @Transactional(readOnly = true)
    public GenericRestResponse<ProfileEnvelopeResponse> getProfile(String email) {
        UserAccount user = userAccountRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("Authenticated user not found"));

        UserHealthProfileRecord profile = profileRepository.findByUser(user)
                .orElseThrow(() -> new IllegalArgumentException("Health profile not found"));

        return response("200", "Profile fetched successfully", toResponse(user, profile));
    }

    @Transactional
    public GenericRestResponse<ProfileEnvelopeResponse> updateProfile(String email, SpecProfileUpdateRequest request) {
        UserAccount user = userAccountRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new IllegalArgumentException("Authenticated user not found"));

        UserHealthProfileRecord profile = profileRepository.findByUser(user)
                .orElseGet(() -> {
                    UserHealthProfileRecord created = new UserHealthProfileRecord();
                    created.setUser(user);
                    return created;
                });

        if (request.getFullName() != null && !request.getFullName().isBlank()) {
            user.setFullName(request.getFullName());
        }
        if (request.getLocation() != null) {
            user.setLocation(request.getLocation());
        }
        if (request.getPhoneNumber() != null && !request.getPhoneNumber().isBlank()) {
            user.setPhoneNumber(request.getPhoneNumber());
        }
        if (request.getRegionId() != null && !request.getRegionId().isBlank()) {
            user.setRegionId(UUID.fromString(request.getRegionId()));
        }

        if (request.getDateOfBirth() != null) {
            profile.setDateOfBirth(request.getDateOfBirth());
        }
        if (request.getGender() != null) {
            profile.setGender(request.getGender());
        }
        if (request.getHealthCondition() != null) {
            profile.setHealthCondition(request.getHealthCondition());
        }
        if (request.getPregnancyStatus() != null) {
            profile.setPregnancyStatus(request.getPregnancyStatus());
        }

        profile.setNutritionGroup(SpecAuthService.computeNutritionGroup(
                profile.getDateOfBirth(),
                profile.getPregnancyStatus(),
                profile.getHealthCondition()
        ));
        profile.setDataEncrypted(Boolean.TRUE);

        UserAccount savedUser = userAccountRepository.save(user);
        UserHealthProfileRecord savedProfile = profileRepository.save(profile);

        return response("200", "Profile updated successfully", toResponse(savedUser, savedProfile));
    }

    private ProfileEnvelopeResponse toResponse(UserAccount user, UserHealthProfileRecord profile) {
        return new ProfileEnvelopeResponse(
                user.getUserId().toString(),
                user.getFullName(),
                user.getEmail(),
                user.getPhoneNumber(),
                user.getRole(),
                user.getLocation(),
                user.getRegionId() == null ? null : user.getRegionId().toString(),
                profile.getDateOfBirth(),
                profile.getGender(),
                profile.getHealthCondition(),
                profile.getPregnancyStatus(),
                profile.getNutritionGroup(),
                profile.getDataEncrypted()
        );
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
