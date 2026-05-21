package com.lishe.nutrition.repository;

import com.lishe.administration.domain.AppUser;
import com.lishe.administration.domain.UserAccount;
import com.lishe.nutrition.domain.WaterIntakeLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface WaterIntakeLogRepository extends JpaRepository<WaterIntakeLog, UUID> {

    // Legacy AppUser-based
    @Query("SELECT SUM(w.amountMl) FROM WaterIntakeLog w WHERE w.user = :user AND w.loggedAt >= :start AND w.loggedAt < :end")
    Integer sumAmountByUserAndDateRange(@Param("user") AppUser user, @Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    List<WaterIntakeLog> findByUserAndLoggedAtBetween(AppUser user, LocalDateTime start, LocalDateTime end);

    // UserAccount-based (Flutter / email users)
    @Query("SELECT SUM(w.amountMl) FROM WaterIntakeLog w WHERE w.account = :account AND w.loggedAt >= :start AND w.loggedAt < :end")
    Integer sumAmountByAccountAndDateRange(@Param("account") UserAccount account, @Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
}
