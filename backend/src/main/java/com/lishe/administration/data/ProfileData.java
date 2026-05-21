package com.lishe.administration.data;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProfileData {
    private String lisheId;
    private String username;
    private String gender;
    private Double weight;
    private Double height;

    protected ProfileData() {
        // Default constructor for JPA or serialization
    }

    public static ProfileData fromJson(final String lisheId, final String username, final String gender, final Double weight, final Double height) {
        return new ProfileData(lisheId, username, gender, weight, height);
    }
    private ProfileData (final String lisheId, final String username, final String gender, final Double weight, final Double height) {
        this.lisheId = lisheId;
        this.username = username;
        this.gender = gender;
        this.weight = weight;
        this.height = height;
    }
}
