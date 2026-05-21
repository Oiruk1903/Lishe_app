package com.lishe.nutrition.exception;

public class NutritionException extends RuntimeException {

    public NutritionException(String message) {
        super(message);
    }

    public NutritionException(String message, Throwable cause) {
        super(message, cause);
    }
}