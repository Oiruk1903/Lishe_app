package com.lishe.administration.api.response;

import com.lishe.administration.data.GoalStatusData;
import com.lishe.administration.data.PreferenceData;
import com.lishe.administration.data.ProfileData;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProfileResponse {
    private ProfileData profileData;
    private GoalStatusData goalStatusData;
    private PreferenceData preferenceData;

    public static ProfileResponse of(final ProfileData profileData, final GoalStatusData goalStatusData) {
        return new ProfileResponse(profileData, goalStatusData);
    }

    public static ProfileResponse of(final ProfileData profileData, final GoalStatusData goalStatusData, final PreferenceData preferenceData) {
        return new ProfileResponse(profileData, goalStatusData, preferenceData);
    }

    private ProfileResponse(final ProfileData profileData, final GoalStatusData goalStatusData) {
        this.profileData = profileData;
        this.goalStatusData = goalStatusData;
    }

    private ProfileResponse(final ProfileData profileData, final GoalStatusData goalStatusData,final PreferenceData preferenceData) {
        this.profileData = profileData;
        this.goalStatusData = goalStatusData;
        this.preferenceData = preferenceData;
    }
}

