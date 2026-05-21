package com.lishe.administration.data;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
public class RecommendationData {
    private List<String> morning;
    private List<String> afternoon;
    private List<String> evening;

    protected RecommendationData() {
        // Default constructor for serialization frameworks
    }
    /**
     * Constructor to initialize RecommendationData with meal lists.
     *
     * @param morning   List of food items for the morning meal.
     * @param afternoon List of food items for the afternoon meal.
     * @param evening   List of food items for the evening meal.
     */
    public RecommendationData(List<String> morning, List<String> afternoon, List<String> evening) {
        this.morning = morning;
        this.afternoon = afternoon;
        this.evening = evening;
    }
}
