package com.lishe.administration.domain;

public enum GoalStatus {
    INVALID(0, "GoalStatus.invalid"),
    LOSE_WEIGHT(100, "GoalStatus.lose_weight"),
    EAT_HEALTHIER(200, "GoalStatus.eat_weight"),
    MANAGE_HEALTH(300, "GoalStatus.manage_health");
    private final Integer value;
    private final String code;

    public static GoalStatus fromInt(final Integer value) {
        GoalStatus enumeration = GoalStatus.INVALID;
        switch (value) {
            case 100:
                enumeration = LOSE_WEIGHT;
                break;
            case 200:
                enumeration = EAT_HEALTHIER;
                break;
            case  300:
                enumeration = MANAGE_HEALTH;
                break;
        }
        return enumeration;
    }

    private GoalStatus(final Integer value, final String code){
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
