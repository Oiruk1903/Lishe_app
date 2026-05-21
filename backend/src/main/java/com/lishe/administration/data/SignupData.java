package com.lishe.administration.data;

import jakarta.validation.Valid;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SignupData {
    @Valid
    private BasicInfoData basicInfoData;
    @Valid
    private DeviceData deviceData;
}
