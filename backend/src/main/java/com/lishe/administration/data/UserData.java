package com.lishe.administration.data;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UserData {
    private String token;
    private ProfileData profile;
    private PreferenceData preference;
    private GoalStatusData goalStatus;
    private RecommendationData recommendation;

    protected UserData() {}

    public static UserData fromJson(final String token, final ProfileData profile, final PreferenceData preference, final GoalStatusData goalStatus, final RecommendationData recommendation) {
        return new UserData(token,profile, preference, goalStatus, recommendation);
    }

    private UserData(final String token,final ProfileData profile, final PreferenceData preference, final GoalStatusData goalStatus, final RecommendationData recommendation) {
        this.token = token;
        this.profile = profile;
        this.preference = preference;
        this.goalStatus = goalStatus;
        this.recommendation = recommendation;
    }
}
