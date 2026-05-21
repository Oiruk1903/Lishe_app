package com.lishe.nutrition.service;

import com.lishe.nutrition.api.response.WeightLogResponse;
import com.lishe.nutrition.domain.WeightLog;

import java.util.List;

public interface WeightService {

    WeightLogResponse logWeight(Long userId, double weightKg, double heightCm);

    List<WeightLog> getWeightHistory(Long userId);
}