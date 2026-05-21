package com.lishe.nutrition.api.controller;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.food.repository.FoodItemRepository;
import com.lishe.nutrition.api.response.FoodResponse;
import com.lishe.nutrition.api.response.NutritionCategoryItemResponse;
import com.lishe.nutrition.api.response.NutritionContentItemResponse;
import com.lishe.nutrition.service.NutritionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
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
import java.util.UUID;

@RestController
@RequestMapping(path = "/v1/foods")
@RequiredArgsConstructor
@Tag(name = "Foods", description = "TFNC food catalog with bilingual search and nutrition data")
@SecurityRequirement(name = "bearerAuth")
public class NutritionController {

    private final NutritionService nutritionService;
    private final FoodItemRepository foodItemRepository;

    @Operation(summary = "Search foods by name (Swahili or English) and/or category")
    @GetMapping
    public ResponseEntity<GenericRestResponse<List<FoodResponse>>> getFoods(
            @Parameter(description = "Search term (partial match, Swahili or English)")
            @RequestParam(name = "q", required = false) String q,
            @Parameter(description = "Food group / category filter")
            @RequestParam(name = "category", required = false) String category
    ) {
        String query = (q != null && !q.isBlank()) ? q.trim() : null;
        String cat   = (category != null && !category.isBlank()) ? category.trim() : null;

        List<FoodResponse> foods = foodItemRepository
                .searchFoods(query, cat)
                .stream()
                .map(FoodResponse::from)
                .toList();

        return ResponseEntity.ok(wrap("Foods retrieved", foods));
    }

    @Operation(summary = "List food categories")
    @GetMapping("/categories")
    public ResponseEntity<GenericRestResponse<List<NutritionCategoryItemResponse>>> getCategories() {
        return ResponseEntity.ok(nutritionService.getCategories());
    }

    @Operation(summary = "Get personalised nutrition content")
    @GetMapping("/content")
    public ResponseEntity<GenericRestResponse<List<NutritionContentItemResponse>>> getContent(
            Authentication authentication,
            @Parameter(description = "Category ID filter") @RequestParam(name = "category", required = false) UUID categoryId,
            @Parameter(description = "Tanzania region filter") @RequestParam(name = "region", required = false) String region
    ) {
        return ResponseEntity.ok(nutritionService.getContent(authentication.getName(), categoryId, region));
    }

    private <T> GenericRestResponse<T> wrap(String message, T data) {
        return new GenericRestResponse<>(LocalDateTime.now().toString(), "200", message, data);
    }
}
