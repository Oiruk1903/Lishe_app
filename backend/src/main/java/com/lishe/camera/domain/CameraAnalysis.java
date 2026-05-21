package com.lishe.camera.domain;

import com.lishe.administration.domain.AppUser;
import com.lishe.administration.domain.UserAccount;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "camera_analyses")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CameraAnalysis {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private AppUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id")
    private UserAccount account;

    @Column(name = "image_hash")
    private String imageHash;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "identified_foods", columnDefinition = "jsonb")
    private String identifiedFoods;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "matched_foods", columnDefinition = "jsonb")
    private String matchedFoods;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "nutrient_summary", columnDefinition = "jsonb")
    private String nutrientSummary;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
