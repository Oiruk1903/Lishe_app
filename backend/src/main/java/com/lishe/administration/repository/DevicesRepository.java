package com.lishe.administration.repository;

import com.lishe.administration.domain.Devices;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DevicesRepository extends JpaRepository<Devices, String> {

    Optional<Devices> findByDeviceTokenAndMobile(String deviceToken, String mobile);

    List<Devices> findByMobile(String mobile);
}
