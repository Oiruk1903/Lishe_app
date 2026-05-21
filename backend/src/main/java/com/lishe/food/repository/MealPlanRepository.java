package com.lishe.food.repository;

import com.lishe.administration.domain.UserAccount;
import com.lishe.food.domain.MealPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface MealPlanRepository extends JpaRepository<MealPlan, UUID> {
    List<MealPlan> findByUserOrderByGeneratedAtDesc(UserAccount user);
}
