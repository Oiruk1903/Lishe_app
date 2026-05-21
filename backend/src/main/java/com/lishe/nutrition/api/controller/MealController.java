package com.lishe.nutrition.api.controller;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.nutrition.api.request.MealEntryRequest;
import com.lishe.nutrition.api.response.DailySummaryResponse;
import com.lishe.nutrition.api.response.MealEntryResponse;
import com.lishe.nutrition.service.MealEntryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/v1/meals")
@RequiredArgsConstructor
@Tag(name = "Meals", description = "Log and manage individual meal entries")
@SecurityRequirement(name = "bearerAuth")
public class MealController {

    private final MealEntryService mealEntryService;

    @Operation(summary = "Log a meal entry")
    @PostMapping
    public ResponseEntity<GenericRestResponse<MealEntryResponse>> create(
            Principal principal,
            @Valid @RequestBody MealEntryRequest request) {
        MealEntryResponse result = mealEntryService.create(principal.getName(), request);
        return ResponseEntity.status(HttpStatus.CREATED).body(wrap("Meal logged", result));
    }

    @Operation(summary = "List meals for a date (defaults to today)")
    @GetMapping
    public ResponseEntity<GenericRestResponse<List<MealEntryResponse>>> list(
            Principal principal,
            @RequestParam(required = false) String date) {
        LocalDate day = date != null ? LocalDate.parse(date) : LocalDate.now();
        List<MealEntryResponse> result = mealEntryService.listForDate(principal.getName(), day);
        return ResponseEntity.ok(wrap("Meals retrieved", result));
    }

    @Operation(summary = "Update a meal entry")
    @PutMapping("/{id}")
    public ResponseEntity<GenericRestResponse<MealEntryResponse>> update(
            Principal principal,
            @PathVariable UUID id,
            @Valid @RequestBody MealEntryRequest request) {
        MealEntryResponse result = mealEntryService.update(principal.getName(), id, request);
        return ResponseEntity.ok(wrap("Meal updated", result));
    }

    @Operation(summary = "Delete a meal entry")
    @DeleteMapping("/{id}")
    public ResponseEntity<GenericRestResponse<Void>> delete(
            Principal principal,
            @PathVariable UUID id) {
        mealEntryService.delete(principal.getName(), id);
        return ResponseEntity.ok(wrap("Meal deleted", null));
    }

    @Operation(summary = "Daily nutrition summary")
    @GetMapping("/summary")
    public ResponseEntity<GenericRestResponse<DailySummaryResponse>> summary(
            Principal principal,
            @RequestParam(required = false) String date) {
        LocalDate day = date != null ? LocalDate.parse(date) : LocalDate.now();
        DailySummaryResponse result = mealEntryService.summarise(principal.getName(), day);
        return ResponseEntity.ok(wrap("Summary retrieved", result));
    }

    private <T> GenericRestResponse<T> wrap(String message, T data) {
        return new GenericRestResponse<>(
                LocalDateTime.now().toString(), "200", message, data);
    }
}
