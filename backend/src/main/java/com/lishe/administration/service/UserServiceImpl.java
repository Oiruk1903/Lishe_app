package com.lishe.administration.service;

import com.lishe.administration.api.request.ProfileRequest;
import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.administration.api.response.ProfileResponse;
import com.lishe.administration.data.GoalStatusData;
import com.lishe.administration.data.PreferenceData;
import com.lishe.administration.data.ProfileData;
import com.lishe.administration.domain.ActivityLevelStatus;
import com.lishe.administration.domain.AppUser;
import com.lishe.administration.domain.GoalStatus;
import com.lishe.administration.exception.ResponseMessages;
import com.lishe.administration.exception.UserNotFoundException;
import com.lishe.administration.repository.AppUserRepository;
import jakarta.transaction.Transactional;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;


@Service
@Log4j2
public class UserServiceImpl {
    private final AppUserRepository appUserRepository;

    public UserServiceImpl(AppUserRepository appUserRepository) {
        this.appUserRepository = appUserRepository;
    }

    private GoalStatusData getGoalStatusData(AppUser user) {
        String goalType = GoalStatus.fromInt(user.getGoalStatus()).name();
        String activityType = ActivityLevelStatus.fromInt(user.getActivityStatus()).name();
        GoalStatusData data = new GoalStatusData();
        data.setGoalType(goalType);
        data.setActivityLevel(activityType);
        data.setDiseaseCategory(user.getDiseaseCategory());
        return data;
    }

    @Transactional
    public GenericRestResponse<ProfileResponse> updateUserProfile(String lisheId, ProfileRequest request){
        log.info("Updating profile for mobile: {}.............", lisheId);

        final AppUser appUser = appUserRepository.findByLisheId(lisheId)
                .orElseThrow(() -> new UserNotFoundException(ResponseMessages.USER_NOT_FOUND));
        appUser.updateProfile(request.getWeight(), request.getHeight(), request.getGoalStatus(), request.getActivityStatus(),
                request.getBirthDate());
        appUserRepository.save(appUser);

        ProfileData profileData = ProfileData.fromJson(appUser.getMobile(), appUser.getFullName(), appUser.getGender(),
                appUser.getWeight(), appUser.getHeight());
        GoalStatusData goalStatusData = this.getGoalStatusData(appUser);
        ProfileResponse profileResponse = ProfileResponse.of(profileData, goalStatusData);

        GenericRestResponse<ProfileResponse> response = new GenericRestResponse<>();
        response.setTimestamp(LocalDateTime.now().toString());
        response.setStatusCode("200");
        response.setMessage("Profile updated successfully");
        response.setData(profileResponse);
        log.info("Profile updated successfully for user: {}", lisheId);
        return response;
    }

    public GenericRestResponse<ProfileResponse> getUserProfile(String lisheId) {
    log.info("Fetching profile for user: {}.............", lisheId);
    final AppUser appUser = appUserRepository.findByLisheId(lisheId)
            .orElseThrow(() -> new UserNotFoundException(ResponseMessages.USER_NOT_FOUND));

    ProfileData profileData = ProfileData.fromJson(appUser.getMobile(), appUser.getFullName(), appUser.getGender(),
            appUser.getWeight(), appUser.getHeight());

    GoalStatusData goalStatusData = this.getGoalStatusData(appUser);
    PreferenceData preferenceData = PreferenceData.fromJson(appUser.getDietStatus(), appUser.getAllergies(), appUser.getFavoriteFoods());
    ProfileResponse profileResponse = ProfileResponse.of(profileData, goalStatusData, preferenceData);

    GenericRestResponse<ProfileResponse> response = new GenericRestResponse<>();
    response.setTimestamp(LocalDateTime.now().toString());
    response.setStatusCode("200");
    response.setMessage("Profile fetched successfully");
    response.setData(profileResponse);
    log.info("Profile fetched successfully for user: {}", lisheId);
    return response;
    }

}
