package com.lishe.camera.service;

import com.lishe.camera.api.response.IdentifiedFood;
import com.lishe.nutrition.api.response.NutrientSummary;

import java.util.List;

public interface GeminiVisionService {

    List<IdentifiedFood> identifyFoods(byte[] imageBytes);

    String generateMealExplanation(NutrientSummary summary, String cohort);
}
