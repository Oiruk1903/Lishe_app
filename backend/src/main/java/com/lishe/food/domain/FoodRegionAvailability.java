package com.lishe.food.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * Represents the availability of a food item in a specific region.
 * Tracks seasonal availability, staple status, and local naming conventions.
 */
@Entity
@Table(name = "food_region_availability")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FoodRegionAvailability {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "availability_id")
    private UUID availabilityId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "food_id", referencedColumnName = "food_id", nullable = false)
    private Food food;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "region_id", referencedColumnName = "region_id", nullable = false)
    private TzRegion region;

    @Column(name = "season")
    private String season;

    @Column(name = "availability_level")
    private String availabilityLevel;

    @Column(name = "is_staple")
    private Boolean isStaple = false;

    @Column(name = "local_name")
    private String localName;
}
