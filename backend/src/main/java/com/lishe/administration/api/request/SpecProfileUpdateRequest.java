package com.lishe.administration.api.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Past;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class SpecProfileUpdateRequest {

    @JsonProperty("full_name")
    private String fullName;

    private String location;

    @JsonProperty("phone_number")
    private String phoneNumber;

    @JsonProperty("date_of_birth")
    @Past
    private LocalDate dateOfBirth;

    private String gender;

    @JsonProperty("health_condition")
    private String healthCondition;

    @JsonProperty("pregnancy_status")
    private String pregnancyStatus;

    @JsonProperty("nutrition_group")
    private String nutritionGroup;

    @JsonProperty("region_id")
    private String regionId;
}
