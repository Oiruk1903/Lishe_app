package com.lishe.recommendation.repository;

import com.lishe.recommendation.domain.UserRecommendation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRecommendationRepository extends JpaRepository<UserRecommendation, UUID> {
    List<UserRecommendation> findByUser_IdAndRecommendationDate(Long userId, LocalDate date);
    List<UserRecommendation> findByUser_IdAndRecommendationDateAfterOrderByRecommendationDateDesc(Long userId, LocalDate date);
    Optional<UserRecommendation> findTopByUser_LisheIdAndRecommendationDate(String lisheId, LocalDate date);
}
