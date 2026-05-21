package com.lishe.analytics.domain;

import com.lishe.administration.domain.GoalStatus;

public enum ProgressType {

    INVALID(0, "ProgressType.invalid"),
    WATER_INTAKE(100, "ProgressType.water_intake"),
    STEPS_WALKED(200, "ProgressType.steps_walked"),
    MEAL_FOLLOWED(300, "ProgressType.meal_followed"),
    EXERCISE_COMPLETED(400, "ProgressType.exercise_completed"),
    WEIGHT_LOSS(500, "ProgressType.weight_loss"),
    WEIGHT_GAIN(600, "ProgressType.weight_gain"),
    GOAL_ACHIEVED(700, "ProgressType.goal_achieved");

    private final Integer value;
    private final String code;

    public static ProgressType fromInt(final Integer value) {
        ProgressType enumeration = ProgressType.INVALID;
        switch (value) {
            case 100:
                enumeration = WATER_INTAKE;
                break;
            case 200:
                enumeration = STEPS_WALKED;
                break;
            case 300:
                enumeration = MEAL_FOLLOWED;
                break;
            case 400:
                enumeration = EXERCISE_COMPLETED;
                break;
            case 500:
                enumeration = WEIGHT_LOSS;
                break;
            case 600:
                enumeration = WEIGHT_GAIN;
                break;
            case 700:
                enumeration = GOAL_ACHIEVED;
                break;
        }
        return enumeration;
    }

    private ProgressType(final Integer value, final String code){
        this.value = value;
        this.code = code;
    }

    public boolean hasStateOf(GoalStatus state) {
        return this.value.equals(state.getValue());
    }

    public Integer getValue() {
        return this.value;
    }

    public String getCode() {
        return this.code;
    }
}
