package com.lishe.nutrition.service;

import com.lishe.administration.domain.AppUser;
import com.lishe.administration.repository.AppUserRepository;
import com.lishe.nutrition.api.response.BmiResult;
import com.lishe.nutrition.api.response.WeightLogResponse;
import com.lishe.nutrition.domain.WeightLog;
import com.lishe.nutrition.exception.InsufficientDataException;
import com.lishe.nutrition.repository.WeightLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class WeightServiceImpl implements WeightService {

    private final WeightLogRepository weightLogRepository;
    private final AppUserRepository appUserRepository;
    private final NutritionCalculationService nutritionCalculationService;

    @Override
    @Transactional
    public WeightLogResponse logWeight(Long userId, double weightKg, double heightCm) {
        AppUser user = resolveUser(userId);
        BmiResult bmiResult = nutritionCalculationService.calculateBMI(weightKg, heightCm);

        WeightLog weightLog = new WeightLog();
        weightLog.setUser(user);
        weightLog.setWeightKg((float) weightKg);
        weightLog.setHeightCm((float) heightCm);
        weightLog.setBmiValue((float) bmiResult.getValue());
        weightLog.setBmiCategory(bmiResult.getCategoryEn());
        weightLog.setLoggedAt(LocalDateTime.now());

        WeightLog saved = weightLogRepository.save(weightLog);
        return new WeightLogResponse(
                saved.getId(),
                userId,
                weightKg,
                heightCm,
                bmiResult,
                saved.getLoggedAt() == null ? null : saved.getLoggedAt().toString(),
                saved.getCreatedAt() == null ? null : saved.getCreatedAt().toString()
        );
    }

    @Override
    @Transactional(readOnly = true)
    public List<WeightLog> getWeightHistory(Long userId) {
        resolveUser(userId);
        return weightLogRepository.findByUser_IdOrderByLoggedAtDesc(userId);
    }

    private AppUser resolveUser(Long userId) {
        if (userId == null) {
            throw new InsufficientDataException("User identifier is required");
        }

        return appUserRepository.findById(userId)
                .orElseThrow(() -> new InsufficientDataException("Authenticated user not found"));
    }
}