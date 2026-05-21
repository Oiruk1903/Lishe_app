package com.lishe.nutrition.service;

import com.lishe.administration.domain.AppUser;
import com.lishe.administration.repository.AppUserRepository;
import com.lishe.food.domain.Food;
import com.lishe.food.repository.FoodItemRepository;
import com.lishe.nutrition.api.request.MealItemRequest;
import com.lishe.nutrition.api.response.DailyNutrientSummary;
import com.lishe.nutrition.api.response.MealLogItemResponse;
import com.lishe.nutrition.api.response.MealLogResponse;
import com.lishe.nutrition.api.response.NutrientSummary;
import com.lishe.nutrition.api.response.NutrientTarget;
import com.lishe.nutrition.domain.DailySummary;
import com.lishe.nutrition.domain.MealLog;
import com.lishe.nutrition.domain.MealLogItem;
import com.lishe.nutrition.domain.UserHealthProfile;
import com.lishe.nutrition.exception.FoodNotFoundException;
import com.lishe.nutrition.exception.InsufficientDataException;
import com.lishe.nutrition.repository.DailySummaryRepository;
import com.lishe.nutrition.repository.MealLogItemRepository;
import com.lishe.nutrition.repository.MealLogRepository;
import com.lishe.nutrition.repository.UserHealthProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class MealLogServiceImpl implements MealLogService {

    private final MealLogRepository mealLogRepository;
    private final MealLogItemRepository mealLogItemRepository;
    private final DailySummaryRepository dailySummaryRepository;
    private final AppUserRepository appUserRepository;
    private final UserHealthProfileRepository userHealthProfileRepository;
    private final FoodItemRepository foodItemRepository;
    private final NutritionCalculationService nutritionCalculationService;

    @Override
    @Transactional
    public MealLogResponse logMeal(Long userId, List<MealItemRequest> items, String mealType, String notes) {
        AppUser user = resolveUser(userId);
        List<PreparedMealItem> preparedItems = prepareItems(items);
        NutrientSummary nutrientSummary = nutritionCalculationService.calculateMealNutrients(items);

        MealLog mealLog = new MealLog();
        mealLog.setUser(user);
        mealLog.setMealType(normalizeMealType(mealType));
        mealLog.setNotes(notes);
        mealLog.setLoggedAt(LocalDateTime.now());

        MealLog savedLog = mealLogRepository.save(mealLog);
        List<MealLogItemResponse> itemResponses = new ArrayList<>();

        for (PreparedMealItem preparedItem : preparedItems) {
            MealLogItem mealLogItem = new MealLogItem();
            mealLogItem.setMealLog(savedLog);
            mealLogItem.setFood(preparedItem.food());
            mealLogItem.setQuantityGrams((float) preparedItem.quantityGrams());
            mealLogItem.setKcalSnapshot((float) preparedItem.kcalSnapshot());
            mealLogItem.setProteinSnapshot((float) preparedItem.proteinSnapshot());
            mealLogItem.setCarbsSnapshot((float) preparedItem.carbsSnapshot());
            mealLogItem.setFatSnapshot((float) preparedItem.fatSnapshot());

            MealLogItem savedItem = mealLogItemRepository.save(mealLogItem);
            itemResponses.add(new MealLogItemResponse(
                    savedItem.getId(),
                    preparedItem.food().getFoodId(),
                    preparedItem.food().getFoodNameEn(),
                    preparedItem.food().getFoodNameSw(),
                    preparedItem.quantityGrams(),
                    preparedItem.kcalSnapshot(),
                    preparedItem.proteinSnapshot(),
                    preparedItem.carbsSnapshot(),
                    preparedItem.fatSnapshot(),
                    savedItem.getCreatedAt() == null ? null : savedItem.getCreatedAt().toString()
            ));
        }

        updateDailySummary(userId, savedLog.getLoggedAt().toLocalDate());

        return new MealLogResponse(
                savedLog.getId(),
                userId,
                savedLog.getMealType(),
                savedLog.getNotes(),
                savedLog.getLoggedAt() == null ? null : savedLog.getLoggedAt().toString(),
                savedLog.getCreatedAt() == null ? null : savedLog.getCreatedAt().toString(),
                nutrientSummary,
                itemResponses
        );
    }

    @Override
    @Transactional(readOnly = true)
    public NutrientSummary getDailySummary(Long userId, LocalDate date) {
        resolveUser(userId);
        LocalDate targetDate = requireDate(date);
        List<MealLog> mealLogs = mealLogRepository.findByUser_IdAndLoggedAtBetweenOrderByLoggedAtAsc(
                userId,
                targetDate.atStartOfDay(),
                targetDate.atTime(LocalTime.MAX)
        );

        List<MealItemRequest> items = new ArrayList<>();
        for (MealLog mealLog : mealLogs) {
            List<MealLogItem> mealLogItems = mealLogItemRepository.findByMealLog_Id(mealLog.getId());
            for (MealLogItem mealLogItem : mealLogItems) {
                items.add(new MealItemRequest(
                        mealLogItem.getFood().getFoodId(),
                        mealLogItem.getQuantityGrams() == null ? 0.0 : mealLogItem.getQuantityGrams().doubleValue()
                ));
            }
        }

        return nutritionCalculationService.calculateMealNutrients(items);
    }

    @Override
    @Transactional
    public void updateDailySummary(Long userId, LocalDate date) {
        AppUser user = resolveUser(userId);
        LocalDate targetDate = requireDate(date);
        NutrientSummary nutrientSummary = getDailySummary(userId, targetDate);
        Map<String, NutrientTarget> targets = userHealthProfileRepository.findByUser(user)
                .map(nutritionCalculationService::getDailyTargets)
                .orElseThrow(() -> new InsufficientDataException("Health profile not found for daily summary update"));

        Double kcalTarget = extractKcalTarget(targets);
        Double adherenceScore = kcalTarget == null || kcalTarget <= 0 ? null : (nutrientSummary.getTotalKcal() / kcalTarget) * 100.0;

        DailySummary dailySummary = dailySummaryRepository.findByUser_IdAndSummaryDate(userId, targetDate)
                .orElseGet(DailySummary::new);
        dailySummary.setUser(user);
        dailySummary.setSummaryDate(targetDate);
        dailySummary.setKcalConsumed((float) nutrientSummary.getTotalKcal());
        dailySummary.setProteinConsumed((float) nutrientSummary.getTotalProtein());
        dailySummary.setCarbsConsumed((float) nutrientSummary.getTotalCarbs());
        dailySummary.setFatConsumed((float) nutrientSummary.getTotalFat());
        dailySummary.setIronConsumed((float) nutrientSummary.getTotalIron());
        dailySummary.setCalciumConsumed((float) nutrientSummary.getTotalCalcium());
        dailySummary.setKcalTarget(kcalTarget == null ? null : kcalTarget.floatValue());
        dailySummary.setAdherenceScore(adherenceScore == null ? null : adherenceScore.floatValue());

        dailySummaryRepository.save(dailySummary);
    }

    @Override
    @Transactional(readOnly = true)
    public List<DailyNutrientSummary> getWeeklyProgress(Long userId) {
        resolveUser(userId);
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(6);

        return dailySummaryRepository.findByUser_IdAndSummaryDateBetweenOrderBySummaryDateAsc(userId, startDate, endDate)
                .stream()
                .map(summary -> new DailyNutrientSummary(
                        summary.getSummaryDate(),
                summary.getKcalConsumed() == null ? 0.0 : summary.getKcalConsumed().doubleValue(),
                summary.getProteinConsumed() == null ? 0.0 : summary.getProteinConsumed().doubleValue(),
                summary.getCarbsConsumed() == null ? 0.0 : summary.getCarbsConsumed().doubleValue(),
                summary.getFatConsumed() == null ? 0.0 : summary.getFatConsumed().doubleValue(),
                summary.getIronConsumed() == null ? 0.0 : summary.getIronConsumed().doubleValue(),
                summary.getCalciumConsumed() == null ? 0.0 : summary.getCalciumConsumed().doubleValue(),
                summary.getKcalTarget() == null ? 0.0 : summary.getKcalTarget().doubleValue(),
                summary.getAdherenceScore() == null ? 0.0 : summary.getAdherenceScore().doubleValue(),
                        summary.getCreatedAt() == null ? null : summary.getCreatedAt().toString()
                ))
                .toList();
    }

    private List<PreparedMealItem> prepareItems(List<MealItemRequest> items) {
        if (items == null || items.isEmpty()) {
            throw new InsufficientDataException("At least one meal item is required");
        }

        List<PreparedMealItem> preparedItems = new ArrayList<>();
        for (MealItemRequest item : items) {
            Food food = foodItemRepository.findByFoodId(item.getFoodId())
                    .orElseThrow(() -> new FoodNotFoundException("Food not found for foodId: " + item.getFoodId()));

            double quantityGrams = item.getQuantityGrams();
            double factor = quantityGrams / 100.0;
            preparedItems.add(new PreparedMealItem(
                    food,
                    quantityGrams,
                    scaled(food.getCaloriesPer100g(), factor),
                    scaled(food.getProteinG(), factor),
                    scaled(food.getCarbsG(), factor),
                    scaled(food.getFatG(), factor)
            ));
        }

        return preparedItems;
    }

    private AppUser resolveUser(Long userId) {
        if (userId == null) {
            throw new InsufficientDataException("User identifier is required");
        }

        return appUserRepository.findById(userId)
                .orElseThrow(() -> new InsufficientDataException("Authenticated user not found"));
    }

    private String normalizeMealType(String mealType) {
        if (mealType == null || mealType.trim().isBlank()) {
            throw new InsufficientDataException("Meal type is required");
        }
        return mealType.trim().toUpperCase();
    }

    private LocalDate requireDate(LocalDate date) {
        if (date == null) {
            throw new InsufficientDataException("Date is required");
        }
        return date;
    }

    private Double extractKcalTarget(Map<String, NutrientTarget> targets) {
        NutrientTarget nutrientTarget = targets.get("KCAL");
        if (nutrientTarget == null) {
            return null;
        }
        if (nutrientTarget.getMin() != null) {
            return nutrientTarget.getMin();
        }
        return nutrientTarget.getMax();
    }

    private double scaled(Double valuePer100g, double quantityFactor) {
        return (valuePer100g == null ? 0.0 : valuePer100g) * quantityFactor;
    }

    private record PreparedMealItem(Food food, double quantityGrams, double kcalSnapshot, double proteinSnapshot, double carbsSnapshot, double fatSnapshot) {
    }
}