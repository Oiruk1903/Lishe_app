package com.lishe.nutrition.repository;

import com.lishe.administration.domain.UserAccount;
import com.lishe.nutrition.domain.WeightLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface WeightLogRepository extends JpaRepository<WeightLog, UUID> {

    // Legacy AppUser queries (kept for analytics module)
    List<WeightLog> findByUser_IdOrderByLoggedAtDesc(Long userId);

    @Query("SELECT AVG(w.bmiValue) FROM WeightLog w")
    Double findAverageBmiValue();

    // UserAccount-based queries (Flutter / email users)
    List<WeightLog> findByAccountOrderByLoggedAtAsc(UserAccount account);

    Optional<WeightLog> findFirstByAccountOrderByLoggedAtDesc(UserAccount account);

    List<WeightLog> findByAccountAndLoggedAtAfterOrderByLoggedAtAsc(
            UserAccount account, LocalDateTime since);

    // Latest entry that has a height value (used to infer height for BMI)
    @Query("SELECT w FROM WeightLog w WHERE w.account = :account AND w.heightCm IS NOT NULL ORDER BY w.loggedAt DESC")
    List<WeightLog> findLatestWithHeightForAccount(@Param("account") UserAccount account,
            org.springframework.data.domain.Pageable pageable);

    Optional<WeightLog> findByIdAndAccount(UUID id, UserAccount account);
}
