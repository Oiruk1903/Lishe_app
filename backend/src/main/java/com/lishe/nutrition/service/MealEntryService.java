package com.lishe.nutrition.service;

import com.lishe.nutrition.api.request.MealEntryRequest;
import com.lishe.nutrition.api.response.DailySummaryResponse;
import com.lishe.nutrition.api.response.MealEntryResponse;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public interface MealEntryService {

    MealEntryResponse create(String email, MealEntryRequest request);

    List<MealEntryResponse> listForDate(String email, LocalDate date);

    MealEntryResponse update(String email, UUID mealLogId, MealEntryRequest request);

    void delete(String email, UUID mealLogId);

    DailySummaryResponse summarise(String email, LocalDate date);
}
