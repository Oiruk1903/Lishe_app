package com.lishe.administration.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class AuthTokenResponse {

    @JsonProperty("auth_token")
    private final String authToken;

    private final String role;
}
