package com.lishe.food.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

/**
 * Represents a Tanzanian region.
 * Stores geographic and climate information for food availability tracking.
 */
@Entity
@Table(name = "tz_regions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TzRegion {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "region_id")
    private UUID regionId;

    @Column(name = "region_name", nullable = false, unique = true)
    private String regionName;

    @Column(name = "zone")
    private String zone;

    @Column(name = "climate_type")
    private String climateType;
}
