package com.lishe.analytics.api.response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WaterInTakeResponse {
    private int glassesDrunkPerDay;
    private int totalMlDrunkPerDay;
    private boolean isGoalMetToday;
}
