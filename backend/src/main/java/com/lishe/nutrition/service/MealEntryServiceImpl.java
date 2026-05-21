package com.lishe.nutrition.service;

import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.food.domain.Food;
import com.lishe.food.repository.FoodItemRepository;
import com.lishe.nutrition.api.request.MealEntryRequest;
import com.lishe.nutrition.api.response.DailySummaryResponse;
import com.lishe.nutrition.api.response.MealEntryResponse;
import com.lishe.nutrition.domain.MealLog;
import com.lishe.nutrition.domain.MealLogItem;
import com.lishe.nutrition.repository.MealLogItemRepository;
import com.lishe.nutrition.repository.MealLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MealEntryServiceImpl implements MealEntryService {

    private final MealLogRepository mealLogRepository;
    private final MealLogItemRepository mealLogItemRepository;
    private final FoodItemRepository foodItemRepository;
    private final UserAccountRepository userAccountRepository;

    @Override
    @Transactional
    public MealEntryResponse create(String email, MealEntryRequest request) {
        UserAccount account = resolve(email);
        Food food = resolveFood(request.getFoodId());

        MealLog log = new MealLog();
        log.setAccount(account);
        log.setMealType(normaliseMealPeriod(request.getMealPeriod()));
        log.setLoggedAt(request.getLoggedAt() != null ? request.getLoggedAt() : LocalDateTime.now());

        MealLog saved = mealLogRepository.save(log);

        double gramsConsumed = toGrams(request.getQuantity(), request.getUnit(), food);
        MealLogItem item = buildItem(saved, food, gramsConsumed, request.getUnit());
        mealLogItemRepository.save(item);

        return toResponse(saved, item, food, account);
    }

    @Override
    @Transactional(readOnly = true)
    public List<MealEntryResponse> listForDate(String email, LocalDate date) {
        UserAccount account = resolve(email);
        LocalDateTime start = date.atStartOfDay();
        LocalDateTime end = date.plusDays(1).atStartOfDay();

        List<MealLog> logs = mealLogRepository
                .findByAccountAndLoggedAtBetweenOrderByLoggedAtDesc(account, start, end);

        List<MealEntryResponse> result = new ArrayList<>();
        for (MealLog log : logs) {
            List<MealLogItem> items = mealLogItemRepository.findByMealLog_Id(log.getId());
            for (MealLogItem item : items) {
                result.add(toResponse(log, item, item.getFood(), account));
            }
        }
        return result;
    }

    @Override
    @Transactional
    public MealEntryResponse update(String email, UUID mealLogId, MealEntryRequest request) {
        UserAccount account = resolve(email);
        MealLog log = mealLogRepository.findByIdAndAccount(mealLogId, account)
                .orElseThrow(() -> new IllegalArgumentException("Meal not found"));

        Food food = resolveFood(request.getFoodId());
        log.setMealType(normaliseMealPeriod(request.getMealPeriod()));
        if (request.getLoggedAt() != null) log.setLoggedAt(request.getLoggedAt());
        mealLogRepository.save(log);

        List<MealLogItem> existing = mealLogItemRepository.findByMealLog_Id(log.getId());
        existing.forEach(mealLogItemRepository::delete);

        double gramsConsumed = toGrams(request.getQuantity(), request.getUnit(), food);
        MealLogItem item = buildItem(log, food, gramsConsumed, request.getUnit());
        mealLogItemRepository.save(item);

        return toResponse(log, item, food, account);
    }

    @Override
    @Transactional
    public void delete(String email, UUID mealLogId) {
        UserAccount account = resolve(email);
        MealLog log = mealLogRepository.findByIdAndAccount(mealLogId, account)
                .orElseThrow(() -> new IllegalArgumentException("Meal not found"));
        mealLogRepository.delete(log);
    }

    @Override
    @Transactional(readOnly = true)
    public DailySummaryResponse summarise(String email, LocalDate date) {
        UserAccount account = resolve(email);
        LocalDateTime start = date.atStartOfDay();
        LocalDateTime end = date.plusDays(1).atStartOfDay();

        List<MealLog> logs = mealLogRepository
                .findByAccountAndLoggedAtBetweenOrderByLoggedAtDesc(account, start, end);

        double calories = 0, protein = 0, carbs = 0, fat = 0, fiber = 0;
        int mealCount = 0;

        for (MealLog log : logs) {
            for (MealLogItem item : mealLogItemRepository.findByMealLog_Id(log.getId())) {
                calories += nvl(item.getKcalSnapshot());
                protein  += nvl(item.getProteinSnapshot());
                carbs    += nvl(item.getCarbsSnapshot());
                fat      += nvl(item.getFatSnapshot());
                mealCount++;
            }
        }

        return DailySummaryResponse.builder()
                .date(date.toString())
                .calories(round(calories))
                .protein(round(protein))
                .carbs(round(carbs))
                .fat(round(fat))
                .fiber(round(fiber))
                .mealCount(mealCount)
                .build();
    }

    // ─── helpers ────────────────────────────────────────────────────────────

    private UserAccount resolve(String email) {
        return userAccountRepository.findByEmail(email.trim().toLowerCase(Locale.ROOT))
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
    }

    private Food resolveFood(UUID foodId) {
        return foodItemRepository.findByFoodId(foodId)
                .orElseThrow(() -> new IllegalArgumentException("Food not found: " + foodId));
    }

    private MealLogItem buildItem(MealLog log, Food food, double grams, String unit) {
        double factor = grams / 100.0;
        MealLogItem item = new MealLogItem();
        item.setMealLog(log);
        item.setFood(food);
        item.setQuantityGrams((float) grams);
        item.setKcalSnapshot(food.getCaloriesPer100g() != null ? (float)(food.getCaloriesPer100g() * factor) : 0f);
        item.setProteinSnapshot(food.getProteinG() != null ? (float)(food.getProteinG() * factor) : 0f);
        item.setCarbsSnapshot(food.getCarbsG() != null ? (float)(food.getCarbsG() * factor) : 0f);
        item.setFatSnapshot(food.getFatG() != null ? (float)(food.getFatG() * factor) : 0f);
        return item;
    }

    private MealEntryResponse toResponse(MealLog log, MealLogItem item, Food food, UserAccount account) {
        double quantityGrams = item.getQuantityGrams() != null ? item.getQuantityGrams() : 0;
        return MealEntryResponse.builder()
                .id(log.getId().toString())
                .userId(account.getUserId().toString())
                .foodId(food.getFoodId().toString())
                .foodNameSw(food.getFoodNameSw() != null ? food.getFoodNameSw() : "")
                .foodNameEn(food.getFoodNameEn())
                .mealPeriod(log.getMealType().toLowerCase(Locale.ROOT))
                .quantity(quantityGrams)
                .unit("g")
                .kcal(nvl(item.getKcalSnapshot()))
                .protein(nvl(item.getProteinSnapshot()))
                .carbs(nvl(item.getCarbsSnapshot()))
                .fat(nvl(item.getFatSnapshot()))
                .loggedAt(log.getLoggedAt().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
                .synced(true)
                .build();
    }

    private static double toGrams(double quantity, String unit, Food food) {
        if ("g".equalsIgnoreCase(unit) || "gram".equalsIgnoreCase(unit)) {
            return quantity;
        }
        // treat everything else as servings of 100g
        return quantity * 100.0;
    }

    private static String normaliseMealPeriod(String period) {
        return switch (period.trim().toLowerCase(Locale.ROOT)) {
            case "breakfast" -> "BREAKFAST";
            case "lunch"     -> "LUNCH";
            case "dinner"    -> "DINNER";
            case "snack"     -> "SNACK";
            default          -> period.toUpperCase(Locale.ROOT);
        };
    }

    private static double nvl(Float v) { return v != null ? v : 0.0; }
    private static double round(double v) { return Math.round(v * 10.0) / 10.0; }
}
