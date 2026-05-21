package com.lishe.administration.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class MobileAuthResponse {

    private UserDto user;
    private String token;

    @JsonProperty("refresh_token")
    private String refreshToken;
}
