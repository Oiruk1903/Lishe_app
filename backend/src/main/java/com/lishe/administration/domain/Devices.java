package com.lishe.administration.domain;

import com.lishe.administration.data.DeviceData;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "devices",
        indexes = {
        @Index(name = "idx_device_token", columnList = "device_token", unique = true),
        @Index(name = "idx_mobile", columnList = "mobile")
})
@Getter
@Setter
public class Devices extends AbstractPersistableCustom<Long>{
    @Column(nullable = false)
    private String mobile;
    @Column(name = "device_token")
    private String deviceToken;
    private String deviceName;
    private String deviceModel; // e.g.  Sm-a115F
    private String deviceOsType; // e.g. Android 14
    private String manufacturer; // e.g. Samsung
    private String ipAddress;
    private LocalDateTime registeredDate;
    private Boolean isActive;
    private Boolean isBanned;
    private LocalDateTime activatedDate;
    private LocalDateTime deactivatedDate;

    protected Devices() {
    }

    public static Devices create(final String mobile, final DeviceData deviceData) {
        final String deviceToken = deviceData.getDeviceToken();
        final String deviceName = deviceData.getDeviceName();
        final String deviceModel = deviceData.getDeviceModel();
        final String deviceOsType = deviceData.getDeviceOsType();
        final String manufacturer = deviceData.getManufacturer();
        final String ipAddress = deviceData.getIpAddress();
        return new Devices(mobile, deviceToken, deviceName, deviceModel, deviceOsType, manufacturer, ipAddress);
    }

    private Devices(final String mobile, final String deviceToken, final String deviceName, final String deviceModel, final String deviceOsType, final String manufacturer, final String ipAddress) {
        this.mobile = mobile;
        this.deviceToken = deviceToken;
        this.deviceName = deviceName;
        this.deviceModel = deviceModel;
        this.deviceOsType = deviceOsType;
        this.manufacturer = manufacturer;
        this.ipAddress = ipAddress;
        this.registeredDate = LocalDateTime.now();
        this.activatedDate = LocalDateTime.now();
        this.isActive = true;
        this.isBanned = false;
    }

    public boolean getIsActive() {
       return this.isActive;
    }

    public void deactivate(){
        this.deactivatedDate = LocalDateTime.now();
        this.isActive = false;
    }

    public void activate(){
        this.activatedDate = LocalDateTime.now();
        this.isActive = true;
    }

}
