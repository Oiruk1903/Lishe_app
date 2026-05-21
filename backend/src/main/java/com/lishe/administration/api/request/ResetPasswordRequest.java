package com.lishe.administration.api.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResetPasswordRequest {

    @Email
    @NotBlank
    private String email;

    @NotBlank
    private String code;

    @NotBlank
    @Size(min = 6)
    private String newPassword;
}
