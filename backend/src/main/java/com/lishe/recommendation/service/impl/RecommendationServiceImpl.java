package com.lishe.recommendation.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lishe.administration.domain.AppUser;
import com.lishe.administration.repository.AppUserRepository;
import com.lishe.nutrition.api.response.NutrientSummary;
import com.lishe.nutrition.api.response.NutrientTarget;
import com.lishe.nutrition.domain.UserHealthProfile;
import com.lishe.nutrition.repository.UserHealthProfileRepository;
import com.lishe.nutrition.service.MealLogService;
import com.lishe.nutrition.service.NutritionCalculationService;
import com.lishe.recommendation.domain.UserRecommendation;
import com.lishe.recommendation.dto.MealRecommendation;
import com.lishe.recommendation.dto.NutritionGap;
import com.lishe.recommendation.dto.RecommendationResponse;
import com.lishe.recommendation.repository.UserRecommendationRepository;
import com.lishe.recommendation.service.NutritionGapAnalyser;
import com.lishe.recommendation.service.RecommendationRuleEngine;
import com.lishe.recommendation.service.RecommendationService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
public class RecommendationServiceImpl implements RecommendationService {

    private final AppUserRepository appUserRepository;
    private final UserHealthProfileRepository profileRepository;
    private final MealLogService mealLogService;
    private final NutritionCalculationService nutritionCalculationService;
    private final NutritionGapAnalyser gapAnalyser;
    private final RecommendationRuleEngine ruleEngine;
    private final UserRecommendationRepository recommendationRepository;
    private final ChatClient chatClient;
    private final ObjectMapper objectMapper;

    public RecommendationServiceImpl(AppUserRepository appUserRepository, UserHealthProfileRepository profileRepository,
                                     MealLogService mealLogService, NutritionCalculationService nutritionCalculationService,
                                     NutritionGapAnalyser gapAnalyser, RecommendationRuleEngine ruleEngine,
                                     UserRecommendationRepository recommendationRepository, ChatClient.Builder chatClientBuilder,
                                     ObjectMapper objectMapper) {
        this.appUserRepository = appUserRepository;
        this.profileRepository = profileRepository;
        this.mealLogService = mealLogService;
        this.nutritionCalculationService = nutritionCalculationService;
        this.gapAnalyser = gapAnalyser;
        this.ruleEngine = ruleEngine;
        this.recommendationRepository = recommendationRepository;
        this.chatClient = chatClientBuilder.build();
        this.objectMapper = objectMapper;
    }

    @Override
    @Transactional
    public RecommendationResponse getRecommendations(UUID userId) {
        // Note: Repository uses Long id, but we might be passing lisheId or mapping UUID to Long.
        // For consistency with AppUserRepository, we'll try finding by lisheId if it matches UUID format.
        AppUser user = appUserRepository.findByLisheId(userId.toString())
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));

        UserHealthProfile profile = profileRepository.findByUser(user)
                .orElseThrow(() -> new IllegalArgumentException("Health profile not found for user: " + user.getId()));

        LocalDate today = LocalDate.now();
        NutrientSummary summary = mealLogService.getDailySummary(user.getId(), today);
        
        // If today is empty, check yesterday
        if (summary == null || summary.getTotalKcal() == 0) {
            summary = mealLogService.getDailySummary(user.getId(), today.minusDays(1));
        }
        
        Map<String, NutrientTarget> targets = nutritionCalculationService.getDailyTargets(profile);
        
        // Step 1: Analyse gaps
        List<NutritionGap> gaps = gapAnalyser.analyse(summary, targets, profile.getCohort());
        
        // Step 2: Rules-based recommendations
        List<MealRecommendation> recommendations = ruleEngine.recommend(gaps, profile, 6);
        
        // Step 3: AI Explanation
        String aiExplanation = generateExplanation(recommendations, gaps, profile.getCohort());

        // Step 4: Save to DB
        UserRecommendation entity = UserRecommendation.builder()
                .user(user)
                .recommendationDate(today)
                .recommendations(serializeRecommendations(recommendations))
                .generatedAt(LocalDateTime.now())
                .build();
        
        UserRecommendation saved = recommendationRepository.save(entity);

        return RecommendationResponse.builder()
                .recommendationId(saved.getId())
                .date(today)
                .gaps(gaps)
                .recommendations(recommendations)
                .aiExplanation(aiExplanation)
                .build();
    }

    @Override
    @Transactional
    public void saveFeedback(UUID recommendationId, String feedback) {
        UserRecommendation rec = recommendationRepository.findById(recommendationId)
                .orElseThrow(() -> new IllegalArgumentException("Recommendation not found: " + recommendationId));
        rec.setFeedback(feedback);
        recommendationRepository.save(rec);
    }

    private String generateExplanation(List<MealRecommendation> recommendations, List<NutritionGap> gaps, String cohort) {
        String gapList = gaps.stream()
                .map(g -> String.format("%s (%.1f%% upungufu)", g.getNutrientCode(), g.getGapPercent()))
                .collect(Collectors.joining(", "));
        
        String foodList = recommendations.stream()
                .map(r -> r.getFood().getFoodNameEn())
                .collect(Collectors.joining(", "));

        String prompt = String.format("""
                Mtumiaji ni kundi la %s. Upungufu wa lishe leo: %s.
                Vyakula vilivyopendekezwa: %s.
                Andika ujumbe mfupi wa ushauri wa lishe kwa Kiswahili ukielezea kwanini vyakula hivi ni muhimu kwao leo.
                Usizidi maneno 50.
                """, cohort, gapList, foodList);

        try {
            return chatClient.prompt(prompt).call().content();
        } catch (Exception e) {
            log.error("AI Explanation generation failed", e);
            return "Kula vyakula hivi ili kuboresha afya yako na kupata virutubisho unavyohitaji leo.";
        }
    }

    private String serializeRecommendations(List<MealRecommendation> list) {
        try {
            return objectMapper.writeValueAsString(list);
        } catch (Exception e) {
            log.error("Failed to serialize recommendations", e);
            return "[]";
        }
    }
}
