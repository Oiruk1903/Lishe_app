package com.lishe.recommendation.api;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.recommendation.api.response.MealPlanResponse;
import com.lishe.recommendation.api.response.NutritionAlertResponse;
import com.lishe.recommendation.service.RecommendationFlowService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/v1/ai/recommendations")
@RequiredArgsConstructor
@Tag(name = "Recommendations", description = "AI-generated meal plans and personalized nutrition recommendations")
@SecurityRequirement(name = "bearerAuth")
public class RecommendationController {

    private final RecommendationFlowService recommendationFlowService;

    @Operation(summary = "Get today's meal plan (latest saved plan)")
    @GetMapping
    public ResponseEntity<GenericRestResponse<MealPlanResponse>> getDailyRecommendations(
            Authentication authentication) {
        GenericRestResponse<List<MealPlanResponse>> plans =
                recommendationFlowService.getMealPlans(authentication.getName());

        MealPlanResponse latest = plans.getData() != null && !plans.getData().isEmpty()
                ? plans.getData().get(0)
                : null;

        return ResponseEntity.ok(wrap("Daily recommendations", latest));
    }

    @Operation(summary = "Generate AI meal plan")
    @PostMapping("/generate")
    public ResponseEntity<GenericRestResponse<MealPlanResponse>> generate(Authentication authentication) {
        return ResponseEntity.ok(recommendationFlowService.generatePlan(authentication.getName()));
    }

    @Operation(summary = "List saved meal plans")
    @GetMapping("/meal-plans")
    public ResponseEntity<GenericRestResponse<List<MealPlanResponse>>> mealPlans(Authentication authentication) {
        return ResponseEntity.ok(recommendationFlowService.getMealPlans(authentication.getName()));
    }

    @Operation(summary = "Get nutrition alerts")
    @GetMapping("/alerts")
    public ResponseEntity<GenericRestResponse<List<NutritionAlertResponse>>> alerts(Authentication authentication) {
        return ResponseEntity.ok(recommendationFlowService.getAlerts(authentication.getName()));
    }

    @Operation(summary = "Recommendation history (last N meal plans)")
    @GetMapping("/history")
    public ResponseEntity<GenericRestResponse<List<MealPlanResponse>>> getHistory(
            Authentication authentication,
            @RequestParam(defaultValue = "7") int days) {
        // Delegate to getMealPlans — the list is already ordered by generatedAt DESC
        return ResponseEntity.ok(recommendationFlowService.getMealPlans(authentication.getName()));
    }

    @Operation(summary = "Submit feedback on a recommendation")
    @PostMapping("/feedback")
    public ResponseEntity<GenericRestResponse<Void>> submitFeedback(
            @RequestBody FeedbackRequest request) {
        // No-op for now — feedback stub retained for API compatibility
        return ResponseEntity.ok(wrap("Feedback submitted", null));
    }

    private <T> GenericRestResponse<T> wrap(String message, T data) {
        return new GenericRestResponse<>(
                LocalDateTime.now().toString(), "200", message, data);
    }

    @Data
    public static class FeedbackRequest {
        private UUID recommendationId;
        private String feedback;
    }
}
