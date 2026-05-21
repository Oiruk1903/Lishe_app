package com.lishe.administration.domain;

public enum ActivityLevelStatus {
    INVALID(0, "ActivityLevelStatus.invalid"),
    SEDENTARY(100, "ActivityLevelStatus.sedentary"),/*Little or no exercise*/
    LIGHTLY_ACTIVE(200, "ActivityLevelStatus.lightly_active"),/*Light exercise 1-3 days/week*/
    MODERATELY_ACTIVE(300, "ActivityLevelStatus.moderately_active"),/*Moderate exercise 3-5 days/week*/
    VERY_ACTIVE(400, "ActivityLevelStatus.very_active");/*Hard exercise 6-7 days/week*/
    private final Integer value;
    private final String code;

    public static ActivityLevelStatus fromInt(final Integer value) {
        ActivityLevelStatus enumeration = ActivityLevelStatus.INVALID;
        switch (value) {
            case 100:
                enumeration = ActivityLevelStatus.SEDENTARY;
                break;
            case 200:
                enumeration = ActivityLevelStatus.LIGHTLY_ACTIVE;
                break;
            case 300:
                enumeration = ActivityLevelStatus.MODERATELY_ACTIVE;
                break;
            case 400:
                enumeration = ActivityLevelStatus.VERY_ACTIVE;
                break;
        }
        return enumeration;
    }

    private ActivityLevelStatus(Integer value, String code) {
        this.value = value;
        this.code = code;
    }

    public boolean hasStateOf(ActivityLevelStatus state) {
        return this.value.equals(state.getValue());
    }

    public Integer getValue() {
        return this.value;
    }

    public String getCode() {
        return this.code;
    }
}
