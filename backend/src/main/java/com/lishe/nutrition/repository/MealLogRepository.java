package com.lishe.nutrition.repository;

import com.lishe.administration.domain.UserAccount;
import com.lishe.nutrition.domain.MealLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface MealLogRepository extends JpaRepository<MealLog, UUID> {

    // Legacy AppUser-based queries (kept for analytics module)
    List<MealLog> findByUser_IdAndLoggedAtBetween(Long userId, LocalDateTime start, LocalDateTime end);
    List<MealLog> findByUser_IdAndLoggedAtBetweenOrderByLoggedAtAsc(Long userId, LocalDateTime start, LocalDateTime end);

    @Query("SELECT COUNT(DISTINCT m.user) FROM MealLog m WHERE m.loggedAt >= :start AND m.loggedAt < :end")
    long countActiveUsersBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    // UserAccount-based queries (Flutter / email users)
    List<MealLog> findByAccountAndLoggedAtBetweenOrderByLoggedAtDesc(
            UserAccount account, LocalDateTime start, LocalDateTime end);

    Optional<MealLog> findByIdAndAccount(UUID id, UserAccount account);
}
