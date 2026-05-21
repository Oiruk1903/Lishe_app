package com.lishe.recommendation.service;

import com.lishe.recommendation.dto.RecommendationResponse;
import java.util.UUID;

public interface RecommendationService {
    RecommendationResponse getRecommendations(UUID userId);
    void saveFeedback(UUID recommendationId, String feedback);
}
