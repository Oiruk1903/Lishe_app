package com.lishe.administration.api.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MobileProfileRequest {
    private String fullName;
    private String phoneNumber;
    private String gender;
    private String cohort;
    private Double height;
    private Double targetWeight;
}
