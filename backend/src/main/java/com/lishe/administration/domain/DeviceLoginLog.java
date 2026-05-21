package com.lishe.administration.domain;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "device_login_log")
public class DeviceLoginLog extends AbstractPersistableCustom<Long>{
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "device_id", referencedColumnName = "id", nullable = false)
    private Devices device;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "app_user", referencedColumnName = "id", nullable = false)
    private AppUser appUser;
    @Column(name = "ip_address", nullable = false)
    private String ipAddress;
    private String location;
    @Column(name = "login_at", nullable = false)
    private LocalDateTime loginAt;
}
