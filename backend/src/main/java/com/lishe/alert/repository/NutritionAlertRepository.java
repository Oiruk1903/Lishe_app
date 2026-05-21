package com.lishe.alert.repository;

import com.lishe.administration.domain.UserAccount;
import com.lishe.alert.domain.NutritionAlert;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface NutritionAlertRepository extends JpaRepository<NutritionAlert, UUID> {
    List<NutritionAlert> findByUserOrderBySentAtDesc(UserAccount user);
}
