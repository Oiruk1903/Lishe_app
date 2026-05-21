package com.lishe.report.repository;

import com.lishe.report.domain.ReportExport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface ReportExportRepository extends JpaRepository<ReportExport, UUID> {
}
