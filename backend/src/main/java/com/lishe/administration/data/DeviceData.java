package com.lishe.administration.data;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;
import org.springframework.validation.annotation.Validated;

@Getter
@Setter
@Validated
public class DeviceData {
    @NotBlank
    private String deviceToken;
    @NotBlank
    private String deviceName;
    @NotBlank
    private String deviceModel; // e.g. Sm-a115F
    @NotBlank
    private String deviceOsType; // e.g. Android 14
    @NotBlank
    private String manufacturer; // e.g. Samsung
    @NotBlank
    private String ipAddress; // e.g. Dar es Salaam, Tanzania

    protected DeviceData() {
    }

    public static DeviceData fromJson(String deviceName, String deviceModel, String deviceOsType, String manufacturer, String ipAddress) {
        return new DeviceData(deviceName, deviceModel, deviceOsType, manufacturer, ipAddress);
    }

    private DeviceData(final String deviceName, final String deviceModel, final String deviceOsType, final String manufacturer, final String ipAddress){
        this.deviceName = deviceName;
        this.deviceModel = deviceModel;
        this.deviceOsType = deviceOsType;
        this.manufacturer = manufacturer;
        this.ipAddress = ipAddress;
    }
}
