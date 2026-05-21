package com.lishe.administration.service;

import com.lishe.food.domain.Food;
import com.lishe.food.repository.FoodItemRepository;
import com.lishe.administration.data.RecommendationData;
import com.lishe.administration.domain.AppUser;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service("legacyRecommendationService")
public class RecommendationService {
    private final FoodItemRepository foodItemRepository;

    public RecommendationService(FoodItemRepository foodItemRepository) {
        this.foodItemRepository = foodItemRepository;
    }

    public RecommendationData generateSimpleRecommendation(AppUser user) {
        List<Food> allFoods = foodItemRepository.findAll();
        double dailyCalories = computeDailyCalories(user);
        final Integer goalStatus = user.getGoalStatus();
        if (goalStatus == 100) {
            dailyCalories -= 300;
        } else if (goalStatus == 200) {
            //eat healthier to implement
        } else if (goalStatus == 300) {
            dailyCalories -= 200; // manage health, reduce calories to be implemented
        } else {
            dailyCalories -= 300;
        }

        double perMeal = dailyCalories / 3;
        List<Food> filtered = allFoods.stream()
                .filter(food -> food.getCaloriesPer100g() != null)
                .filter(food -> !user.getAllergies().contains(food.getFoodNameEn()))
                .filter(food -> isFoodAllowedForDisease(food, user.getDiseaseCategory()))
                .collect(Collectors.toList());
        List<String> morning = pickMeal(filtered, perMeal, "morning");
        List<String> afternoon = pickMeal(filtered, perMeal, "afternoon");
        List<String> evening = pickMeal(filtered, perMeal, "evening");
        return new RecommendationData(morning, afternoon, evening);
    }

    private double computeDailyCalories(AppUser user) {
        double bmr;
        if ("male".equalsIgnoreCase(user.getGender())) {
            bmr = 10 * user.getWeight() + 6.25 * user.getHeight() - 5 * user.getAge() + 5;
        } else {
            bmr = 10 * user.getWeight() + 6.25 * user.getHeight() - 5 * user.getAge() - 161;
        }

        double activityMultiplier = switch (user.getActivityStatus()) {
            case 100 -> 1.2;   // Sedentary
            case 200 -> 1.375; // Light
            case 300 -> 1.55;  // Moderate
            case 400 -> 1.725; // Active
            case 500 -> 1.9;   // Very Active
            default -> 1.2;
        };
        return bmr * activityMultiplier;
    }

    private boolean isFoodAllowedForDisease(Food food, String diseaseCategory) {
        if (diseaseCategory == null) return true;
        if (diseaseCategory.equalsIgnoreCase("diabetes")) {
            return food.getCarbsG() != null && food.getCarbsG() < 30;
        } else if (diseaseCategory.equalsIgnoreCase("hypertension")) {
            return food.getFatG() != null && food.getFatG() < 10;
        } else if (diseaseCategory.equalsIgnoreCase("kidney")) {
            return food.getProteinG() != null && food.getProteinG() < 15;
        }
        return true;
    }

    private List<String> pickMeal(List<Food> foods, double calorieTarget, String mealTime) {
        List<Food> sorted = foods.stream()
                .sorted(Comparator.comparingDouble(Food::getCaloriesPer100g))
                .toList();

        List<String> selected = new ArrayList<>();
        double total = 0;

        for (Food food : sorted) {
            if (total + food.getCaloriesPer100g() <= calorieTarget + 50) {
                selected.add(food.getFoodNameEn());
                total += food.getCaloriesPer100g();
            }
            if (selected.size() >= 3 || total >= calorieTarget) break;
        }

        return selected;
    }

    public RecommendationData generateAIRecommendation(AppUser user) {
        // Placeholder for AI-based recommendation logic
        // This can be implemented using an AI model or service
        return null;
    }
}
