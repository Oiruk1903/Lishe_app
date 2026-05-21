package com.lishe.administration.api.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RegisterRequest {

    @NotBlank
    private String fullName;

    @Email
    @NotBlank
    private String email;

    @NotBlank
    private String phoneNumber;

    @NotBlank
    private String password;

    @NotBlank
    private String dateOfBirth;

    @NotBlank
    private String gender;

    private String category;
}
