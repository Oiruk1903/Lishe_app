package com.lishe.nutrition.api.response;

import com.lishe.food.domain.Food;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class FoodResponse {

    private String id;
    private String nameSw;
    private String nameEn;
    private String category;
    private double caloriesPer100g;
    private double proteinPer100g;
    private double carbsPer100g;
    private double fatPer100g;
    private double fiberPer100g;
    private double standardServingSize;
    private String servingUnit;
    private String zone;
    private boolean isLocal;
    private String imageUrl;

    public static FoodResponse from(Food food) {
        return FoodResponse.builder()
                .id(food.getFoodId().toString())
                .nameSw(food.getFoodNameSw() != null ? food.getFoodNameSw() : "")
                .nameEn(food.getFoodNameEn())
                .category(food.getFoodGroup() != null ? food.getFoodGroup() : "")
                .caloriesPer100g(nvl(food.getCaloriesPer100g()))
                .proteinPer100g(nvl(food.getProteinG()))
                .carbsPer100g(nvl(food.getCarbsG()))
                .fatPer100g(nvl(food.getFatG()))
                .fiberPer100g(nvl(food.getFibreG()))
                .standardServingSize(100.0)
                .servingUnit("g")
                .zone("all")
                .isLocal(true)
                .imageUrl(null)
                .build();
    }

    private static double nvl(Double value) {
        return value != null ? value : 0.0;
    }
}
