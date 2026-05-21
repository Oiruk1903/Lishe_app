package com.lishe.nutrition.domain;

import com.lishe.food.domain.Food;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "serving_sizes")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ServingSize {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "food_id", referencedColumnName = "food_id")
    private Food food;

    @Column(name = "label_en")
    private String labelEn;

    @Column(name = "label_sw")
    private String labelSw;

    @Column(name = "grams_equivalent", nullable = false)
    private Float gramsEquivalent;

    @Column(name = "measurement_type")
    private String measurementType;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
