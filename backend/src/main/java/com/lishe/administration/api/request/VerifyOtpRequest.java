package com.lishe.administration.api.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VerifyOtpRequest {
    private String otp;
    private String mobile;
}
