package com.lishe.administration.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class RegistrationResponse {

    @JsonProperty("user_id")
    private final String userId;

    private final String email;

    @JsonProperty("nutrition_group")
    private final String nutritionGroup;
}
