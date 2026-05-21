package com.lishe.nutrition.api.controller;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.nutrition.api.request.WeightTrackRequest;
import com.lishe.nutrition.api.response.BmiResponse;
import com.lishe.nutrition.api.response.WeightEntryResponse;
import com.lishe.nutrition.api.response.WeightTrendResponse;
import com.lishe.nutrition.service.WeightTrackingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/v1/weights")
@RequiredArgsConstructor
@Tag(name = "Weight Tracking", description = "Log weight entries and compute BMI trends")
@SecurityRequirement(name = "bearerAuth")
public class WeightController {

    private final WeightTrackingService weightTrackingService;

    @Operation(summary = "Log a weight entry")
    @PostMapping
    public ResponseEntity<GenericRestResponse<WeightEntryResponse>> log(
            Principal principal,
            @Valid @RequestBody WeightTrackRequest request) {
        WeightEntryResponse result = weightTrackingService.log(principal.getName(), request);
        return ResponseEntity.status(HttpStatus.CREATED).body(wrap("Weight logged", result));
    }

    @Operation(summary = "Weight history (default last 30 days)")
    @GetMapping
    public ResponseEntity<GenericRestResponse<List<WeightEntryResponse>>> history(
            Principal principal,
            @RequestParam(defaultValue = "30") int days) {
        List<WeightEntryResponse> result = weightTrackingService.history(principal.getName(), days);
        return ResponseEntity.ok(wrap("Weight history retrieved", result));
    }

    @Operation(summary = "Latest weight entry")
    @GetMapping("/latest")
    public ResponseEntity<GenericRestResponse<WeightEntryResponse>> latest(Principal principal) {
        WeightEntryResponse result = weightTrackingService.latest(principal.getName());
        return ResponseEntity.ok(wrap("Latest weight retrieved", result));
    }

    @Operation(summary = "Current BMI with ideal-weight range")
    @GetMapping("/bmi")
    public ResponseEntity<GenericRestResponse<BmiResponse>> bmi(Principal principal) {
        BmiResponse result = weightTrackingService.currentBmi(principal.getName());
        return ResponseEntity.ok(wrap("BMI calculated", result));
    }

    @Operation(summary = "Weight trend analysis (default last 30 days)")
    @GetMapping("/trends")
    public ResponseEntity<GenericRestResponse<WeightTrendResponse>> trends(
            Principal principal,
            @RequestParam(defaultValue = "30") int days) {
        WeightTrendResponse result = weightTrackingService.trends(principal.getName(), days);
        return ResponseEntity.ok(wrap("Trends retrieved", result));
    }

    @Operation(summary = "Delete a weight entry")
    @DeleteMapping("/{id}")
    public ResponseEntity<GenericRestResponse<Void>> delete(
            Principal principal,
            @PathVariable UUID id) {
        weightTrackingService.delete(principal.getName(), id);
        return ResponseEntity.ok(wrap("Weight entry deleted", null));
    }

    private <T> GenericRestResponse<T> wrap(String message, T data) {
        return new GenericRestResponse<>(
                LocalDateTime.now().toString(), "200", message, data);
    }
}
