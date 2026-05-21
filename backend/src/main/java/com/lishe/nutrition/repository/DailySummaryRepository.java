package com.lishe.nutrition.repository;

import com.lishe.nutrition.domain.DailySummary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface DailySummaryRepository extends JpaRepository<DailySummary, UUID> {
    Optional<DailySummary> findByUser_IdAndSummaryDate(Long userId, LocalDate date);

    List<DailySummary> findByUser_IdAndSummaryDateAfterOrderBySummaryDateAsc(Long userId, LocalDate date);

    List<DailySummary> findByUser_IdAndSummaryDateBetweenOrderBySummaryDateAsc(Long userId, LocalDate startDate, LocalDate endDate);
}
