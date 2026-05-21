package com.lishe.analytics.api;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.administration.domain.AppUser;
import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.repository.AppUserRepository;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.analytics.dto.*;
import com.lishe.analytics.service.UserAnalyticsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@RestController
@RequestMapping("/v1/progress")
@RequiredArgsConstructor
@Tag(name = "Analytics", description = "User nutrition and progress analytics")
public class AnalyticsController {

    private final UserAnalyticsService analyticsService;
    private final UserAccountRepository userAccountRepository;
    private final AppUserRepository appUserRepository;

    @Operation(summary = "Get BMI history")
    @GetMapping("/bmi")
    public ResponseEntity<GenericRestResponse<List<BmiRecord>>> getBmiHistory(
            Authentication authentication,
            @RequestParam(defaultValue = "30") int days
    ) {
        AppUser user = resolveAppUser(authentication.getName());
        List<BmiRecord> data = analyticsService.getBmiHistory(UUID.fromString(user.getLisheId()), days);
        return ResponseEntity.ok(wrapResponse("BMI history fetched", data));
    }

    @Operation(summary = "Get nutrient trends")
    @GetMapping("/nutrients")
    public ResponseEntity<GenericRestResponse<List<DailyValue>>> getNutrientTrend(
            Authentication authentication,
            @RequestParam String nutrient,
            @RequestParam(defaultValue = "30") int days
    ) {
        AppUser user = resolveAppUser(authentication.getName());
        List<DailyValue> data = analyticsService.getNutrientTrend(UUID.fromString(user.getLisheId()), nutrient, days);
        return ResponseEntity.ok(wrapResponse(nutrient + " trend fetched", data));
    }

    @Operation(summary = "Get calorie balance")
    @GetMapping("/calories")
    public ResponseEntity<GenericRestResponse<CalorieBalanceReport>> getCalorieBalance(
            Authentication authentication,
            @RequestParam(defaultValue = "7") int days
    ) {
        AppUser user = resolveAppUser(authentication.getName());
        CalorieBalanceReport data = analyticsService.getCalorieBalance(UUID.fromString(user.getLisheId()), days);
        return ResponseEntity.ok(wrapResponse("Calorie balance fetched", data));
    }

    @Operation(summary = "Get adherence score")
    @GetMapping("/adherence")
    public ResponseEntity<GenericRestResponse<Double>> getAdherence(
            Authentication authentication,
            @RequestParam(defaultValue = "30") int days
    ) {
        AppUser user = resolveAppUser(authentication.getName());
        double score = analyticsService.getAdherenceScore(UUID.fromString(user.getLisheId()), days);
        return ResponseEntity.ok(wrapResponse("Adherence score fetched", score));
    }

    @Operation(summary = "Get progress summary")
    @GetMapping("/progress")
    public ResponseEntity<GenericRestResponse<ProgressSummary>> getProgress(Authentication authentication) {
        AppUser user = resolveAppUser(authentication.getName());
        ProgressSummary data = analyticsService.getProgressSummary(UUID.fromString(user.getLisheId()));
        return ResponseEntity.ok(wrapResponse("Progress summary fetched", data));
    }

    private AppUser resolveAppUser(String principal) {
        String normalized = principal == null ? "" : principal.trim();
        UserAccount account = userAccountRepository.findByEmail(normalized.toLowerCase(Locale.ROOT))
                .orElseGet(() -> userAccountRepository.findByPhoneNumber(normalized)
                        .orElseThrow(() -> new IllegalArgumentException("User not found")));

        return appUserRepository.findByMobile(account.getPhoneNumber())
                .orElseThrow(() -> new IllegalArgumentException("App profile not found"));
    }

    private <T> GenericRestResponse<T> wrapResponse(String message, T data) {
        return new GenericRestResponse<>(
                LocalDateTime.now().toString(),
                "200",
                message,
                data
        );
    }
}
