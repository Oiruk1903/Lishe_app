package com.lishe.nutrition.api;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.analytics.dto.WaterSummaryResponse;
import com.lishe.nutrition.domain.WaterIntakeLog;
import com.lishe.nutrition.repository.WaterIntakeLogRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Locale;

@RestController
@RequestMapping("/v1/meals")
@RequiredArgsConstructor
@Tag(name = "Water Intake", description = "Track and monitor daily water consumption")
@SecurityRequirement(name = "bearerAuth")
public class WaterIntakeController {

    private final WaterIntakeLogRepository waterRepository;
    private final UserAccountRepository userAccountRepository;

    @Operation(summary = "Log water intake in ml")
    @PostMapping("/water")
    public ResponseEntity<GenericRestResponse<Void>> logWater(
            Authentication authentication,
            @RequestBody WaterLogRequest request) {
        UserAccount account = resolve(authentication.getName());

        WaterIntakeLog log = new WaterIntakeLog();
        log.setAccount(account);
        log.setAmountMl(request.getAmountMl());
        log.setLoggedAt(LocalDateTime.now());
        waterRepository.save(log);

        return ResponseEntity.ok(wrap("Water intake logged", null));
    }

    @Operation(summary = "Get water intake summary for a date (defaults to today)")
    @GetMapping("/water/summary")
    public ResponseEntity<GenericRestResponse<WaterSummaryResponse>> getWaterSummary(
            Authentication authentication,
            @RequestParam(required = false) String date) {
        UserAccount account = resolve(authentication.getName());
        LocalDate targetDate = (date != null) ? LocalDate.parse(date) : LocalDate.now();

        LocalDateTime start = targetDate.atStartOfDay();
        LocalDateTime end   = targetDate.plusDays(1).atStartOfDay();

        Integer totalMl = waterRepository.sumAmountByAccountAndDateRange(account, start, end);
        if (totalMl == null) totalMl = 0;

        int targetMl = 2000;

        WaterSummaryResponse response = WaterSummaryResponse.builder()
                .date(targetDate)
                .totalMl(totalMl)
                .targetMl(targetMl)
                .percentageAchieved((double) totalMl / targetMl * 100)
                .build();

        return ResponseEntity.ok(wrap("Water summary fetched", response));
    }

    private UserAccount resolve(String principal) {
        String email = principal == null ? "" : principal.trim().toLowerCase(Locale.ROOT);
        return userAccountRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
    }

    private <T> GenericRestResponse<T> wrap(String message, T data) {
        return new GenericRestResponse<>(LocalDateTime.now().toString(), "200", message, data);
    }

    @Data
    @Schema(description = "Water intake log request")
    public static class WaterLogRequest {
        @Schema(description = "Amount of water consumed in millilitres", example = "250", minimum = "1")
        private int amountMl;
    }
}
