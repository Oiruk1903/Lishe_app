package com.lishe.food.repository;

import com.lishe.food.domain.FoodRegionAvailability;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface FoodRegionAvailabilityRepository extends JpaRepository<FoodRegionAvailability, UUID> {
    List<FoodRegionAvailability> findByRegionRegionId(UUID regionId);
}
