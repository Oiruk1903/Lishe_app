package com.lishe.recommendation.domain;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lishe.administration.data.RecommendationData;
import com.lishe.administration.domain.AppUser;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "user_recommendations")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserRecommendation {

    private static final ObjectMapper objectMapper = new ObjectMapper();

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private AppUser user;

    @Column(name = "recommendation_date", nullable = false)
    private LocalDate recommendationDate;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "recommendations", columnDefinition = "jsonb")
    private String recommendations;

    @Column(name = "feedback")
    private String feedback;

    @Column(name = "generated_at")
    private LocalDateTime generatedAt;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public static UserRecommendation fromJson(AppUser user, RecommendationData data) {
        try {
            return UserRecommendation.builder()
                    .user(user)
                    .recommendationDate(LocalDate.now())
                    .recommendations(objectMapper.writeValueAsString(data))
                    .generatedAt(LocalDateTime.now())
                    .build();
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Error serializing recommendations", e);
        }
    }

    public String getMorning() {
        return getMealList("morning");
    }

    public String getAfternoon() {
        return getMealList("afternoon");
    }

    public String getEvening() {
        return getMealList("evening");
    }

    private String getMealList(String mealType) {
        try {
            RecommendationData data = objectMapper.readValue(this.recommendations, RecommendationData.class);
            return switch (mealType) {
                case "morning" -> String.join(",", data.getMorning());
                case "afternoon" -> String.join(",", data.getAfternoon());
                case "evening" -> String.join(",", data.getEvening());
                default -> "";
            };
        } catch (JsonProcessingException e) {
            return "";
        }
    }
}
