package com.lishe.administration.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDate;

@Getter
@AllArgsConstructor
public class ProfileEnvelopeResponse {

    @JsonProperty("user_id")
    private final String userId;

    @JsonProperty("full_name")
    private final String fullName;

    private final String email;

    @JsonProperty("phone_number")
    private final String phoneNumber;

    private final String role;

    private final String location;

    @JsonProperty("region_id")
    private final String regionId;

    @JsonProperty("date_of_birth")
    private final LocalDate dateOfBirth;

    private final String gender;

    @JsonProperty("health_condition")
    private final String healthCondition;

    @JsonProperty("pregnancy_status")
    private final String pregnancyStatus;

    @JsonProperty("nutrition_group")
    private final String nutritionGroup;

    @JsonProperty("data_encrypted")
    private final Boolean dataEncrypted;
}
