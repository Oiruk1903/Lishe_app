package com.lishe.administration.data;

import com.lishe.administration.domain.DietCategory;
import lombok.Getter;
import lombok.Setter;

import java.util.Set;

@Setter
@Getter
public class PreferenceData {
    private String dietType;
    private Set<String> allergies;
    private Set<String> favoriteFoods;

    protected PreferenceData() {
        // Default constructor for JPA or serialization
    }

    public static PreferenceData fromJson(final Integer dietStatus, final Set<String> allergies, final Set<String> favoriteFoods) {
        final String  dietType = DietCategory.fromInt(dietStatus).name();
        return new PreferenceData(dietType, allergies, favoriteFoods);
    }
    private PreferenceData(final String dietType, final Set<String> allergies, final Set<String> favoriteFoods) {
        this.dietType = dietType;
        this.allergies = allergies;
        this.favoriteFoods = favoriteFoods;
    }
}
