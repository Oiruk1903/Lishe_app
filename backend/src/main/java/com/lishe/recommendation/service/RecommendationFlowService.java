package com.lishe.recommendation.service;


import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.domain.UserHealthProfileRecord;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.administration.repository.UserHealthProfileRecordRepository;
import com.lishe.alert.domain.NutritionAlert;
import com.lishe.alert.repository.NutritionAlertRepository;
import com.lishe.chat.domain.ChatLog;
import com.lishe.chat.repository.ChatLogRepository;
import com.lishe.food.domain.Food;
import com.lishe.food.domain.MealPlan;
import com.lishe.food.domain.MealPlanFood;
import com.lishe.food.repository.FoodItemRepository;
import com.lishe.food.repository.MealPlanRepository;
import com.lishe.recommendation.api.response.MealPlanFoodItemResponse;
import com.lishe.recommendation.api.response.MealPlanResponse;
import com.lishe.recommendation.api.response.NutritionAlertResponse;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Set;

@Service
public class RecommendationFlowService {

    private static final Set<String> RISK_KEYWORDS = Set.of("diabetes", "hypertension", "anemia", "kidney", "severe");

    private final UserAccountRepository userAccountRepository;
    private final UserHealthProfileRecordRepository profileRepository;
    private final ChatLogRepository chatLogRepository;
    private final MealPlanRepository mealPlanRepository;
    private final FoodItemRepository foodItemRepository;
    private final NutritionAlertRepository nutritionAlertRepository;
    private final ChatClient chatClient;

    public RecommendationFlowService(UserAccountRepository userAccountRepository,
                                     UserHealthProfileRecordRepository profileRepository,
                                     ChatLogRepository chatLogRepository,
                                     MealPlanRepository mealPlanRepository,
                                     FoodItemRepository foodItemRepository,
                                     NutritionAlertRepository nutritionAlertRepository,
                                     ChatClient.Builder chatClientBuilder) {
        this.userAccountRepository = userAccountRepository;
        this.profileRepository = profileRepository;
        this.chatLogRepository = chatLogRepository;
        this.mealPlanRepository = mealPlanRepository;
        this.foodItemRepository = foodItemRepository;
        this.nutritionAlertRepository = nutritionAlertRepository;
        this.chatClient = chatClientBuilder.build();
    }

    @Transactional
    public GenericRestResponse<MealPlanResponse> generatePlan(String principal) {
        UserAccount user = resolveUser(principal);
        UserHealthProfileRecord profile = profileRepository.findByUser(user)
                .orElseThrow(() -> new IllegalArgumentException("Health profile not found"));

        List<ChatLog> history = chatLogRepository.findByUserOrderByCreatedAtDesc(user);
        String prompt = buildRecommendationPrompt(profile, history);
        String aiSuggestion = chatClient.prompt(prompt).call().content();

        MealPlan mealPlan = new MealPlan();
        mealPlan.setUser(user);
        mealPlan.setPlanTitle("Personalized Plan - " + LocalDate.now());
        mealPlan.setMealDetails(aiSuggestion);
        mealPlan.setDietarySuggestions(extractDietarySuggestion(aiSuggestion));

        List<Food> foods = foodItemRepository.findAll();
        List<MealPlanFood> planFoods = new ArrayList<>();
        planFoods.add(createPlanFood(mealPlan, pickFood(foods, 0), "breakfast", 200f, "High-fiber breakfast"));
        planFoods.add(createPlanFood(mealPlan, pickFood(foods, 1), "lunch", 300f, "Balanced lunch"));
        planFoods.add(createPlanFood(mealPlan, pickFood(foods, 2), "dinner", 250f, "Light dinner"));

        mealPlan.setMealPlanFoods(planFoods);
        MealPlan savedPlan = mealPlanRepository.save(mealPlan);

        if (isNutritionRisk(profile, aiSuggestion)) {
            NutritionAlert alert = new NutritionAlert();
            alert.setUser(user);
            alert.setAlertType("NUTRITION_RISK");
            alert.setMessage("Potential nutrition risk detected. Please review your plan and consult a professional if symptoms persist.");
            alert.setIsRead(Boolean.FALSE);
            nutritionAlertRepository.save(alert);
        }

        return response("200", "Meal plan generated", toMealPlanResponse(savedPlan));
    }

    @Transactional(readOnly = true)
    public GenericRestResponse<List<MealPlanResponse>> getMealPlans(String principal) {
        UserAccount user = resolveUser(principal);
        List<MealPlanResponse> payload = mealPlanRepository.findByUserOrderByGeneratedAtDesc(user).stream()
                .map(this::toMealPlanResponse)
                .toList();

        return response("200", "Meal plans fetched", payload);
    }

    @Transactional(readOnly = true)
    public GenericRestResponse<List<NutritionAlertResponse>> getAlerts(String principal) {
        UserAccount user = resolveUser(principal);
        List<NutritionAlertResponse> payload = nutritionAlertRepository.findByUserOrderBySentAtDesc(user).stream()
                .map(this::toAlertResponse)
                .toList();

        return response("200", "Nutrition alerts fetched", payload);
    }

    private UserAccount resolveUser(String principal) {
        String normalized = principal == null ? "" : principal.trim();
        return userAccountRepository.findByEmail(normalized.toLowerCase(Locale.ROOT))
                .orElseGet(() -> userAccountRepository.findByPhoneNumber(normalized)
                        .orElseThrow(() -> new IllegalArgumentException("Authenticated user not found")));
    }

    private String buildRecommendationPrompt(UserHealthProfileRecord profile, List<ChatLog> history) {
        String recentChat = history.stream()
                .limit(5)
                .map(item -> "Q: " + safe(item.getUserMessage()) + " A: " + safe(item.getAiResponse()))
                .reduce((a, b) -> a + "\n" + b)
                .orElse("No prior chat context.");

        return "Generate a practical Tanzanian nutrition meal plan aligned with TFNC principles. " +
                "User profile: nutrition_group=" + safe(profile.getNutritionGroup()) +
                ", health_condition=" + safe(profile.getHealthCondition()) +
                ", pregnancy_status=" + safe(profile.getPregnancyStatus()) +
                ", age=" + age(profile.getDateOfBirth()) +
                ". Recent chat context:\n" + recentChat;
    }

    private MealPlanFood createPlanFood(MealPlan mealPlan, Food food, String mealType, Float servingSize, String notes) {
        MealPlanFood item = new MealPlanFood();
        item.setMealPlan(mealPlan);
        item.setFood(food);
        item.setMealType(com.lishe.food.domain.MealType.valueOf(mealType.toUpperCase()));
        item.setServingSizeG(servingSize == null ? null : (double) servingSize);
        item.setNotes(notes);
        return item;
    }

    private Food pickFood(List<Food> foods, int fallbackIndex) {
        if (foods == null || foods.isEmpty()) {
            throw new IllegalArgumentException("No food catalog data available to generate a meal plan");
        }
        return foods.get(Math.min(fallbackIndex, foods.size() - 1));
    }

    private String extractDietarySuggestion(String aiSuggestion) {
        if (aiSuggestion == null || aiSuggestion.isBlank()) {
            return "Increase water intake, include vegetables and protein in each meal.";
        }
        return aiSuggestion.length() > 400 ? aiSuggestion.substring(0, 400) : aiSuggestion;
    }

    private boolean isNutritionRisk(UserHealthProfileRecord profile, String aiSuggestion) {
        String combined = (safe(profile.getHealthCondition()) + " " + safe(aiSuggestion)).toLowerCase(Locale.ROOT);
        return RISK_KEYWORDS.stream().anyMatch(combined::contains);
    }

    private int age(LocalDate dateOfBirth) {
        if (dateOfBirth == null) {
            return 0;
        }
        return Math.max(0, Period.between(dateOfBirth, LocalDate.now()).getYears());
    }

    private MealPlanResponse toMealPlanResponse(MealPlan mealPlan) {
        List<MealPlanFoodItemResponse> foods = mealPlan.getMealPlanFoods() == null ? List.of() : mealPlan.getMealPlanFoods().stream()
                .map(item -> new MealPlanFoodItemResponse(
                        item.getMealPlanFoodId() == null ? null : item.getMealPlanFoodId().toString(),
                        item.getFood() == null || item.getFood().getFoodId() == null ? null : item.getFood().getFoodId().toString(),
                        item.getFood() == null ? null : item.getFood().getFoodNameEn(),
                        item.getMealType() == null ? null : item.getMealType().name(),
                        item.getServingSizeG() == null ? null : item.getServingSizeG().floatValue(),
                        item.getNotes()
                ))
                .toList();

        return new MealPlanResponse(
                mealPlan.getPlanId() == null ? null : mealPlan.getPlanId().toString(),
                mealPlan.getPlanTitle(),
                mealPlan.getMealDetails(),
                mealPlan.getDietarySuggestions(),
                mealPlan.getGeneratedAt() == null ? null : mealPlan.getGeneratedAt().toString(),
                foods
        );
    }

    private NutritionAlertResponse toAlertResponse(NutritionAlert alert) {
        return new NutritionAlertResponse(
                alert.getAlertId() == null ? null : alert.getAlertId().toString(),
                alert.getAlertType(),
                alert.getMessage(),
                alert.getIsRead(),
                alert.getSentAt() == null ? null : alert.getSentAt().toString()
        );
    }

    private String safe(String value) {
        return value == null ? "" : value;
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
