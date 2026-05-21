package com.lishe.administration.api.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VerifyResetCodeRequest {

    @Email
    @NotBlank
    private String email;

    @NotBlank
    private String code;
}
