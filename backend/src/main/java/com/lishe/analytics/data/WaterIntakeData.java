package com.lishe.analytics.data;


import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WaterIntakeData {
    private int glassesDrunk;
    private int totalMlDrunk;
    private int totalGoalsMetPerWeek;// e.g., 5 out of 7 goals met
    private String notes;

}
//public static final int GLASS_ML = 250; // 250 milliliters per glass