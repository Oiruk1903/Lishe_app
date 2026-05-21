package com.lishe.report.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Represents an exported report in various formats.
 * Tracks exports of reports in PDF, CSV, Excel, etc.
 */
@Entity
@Table(name = "report_exports")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReportExport {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "export_id")
    private UUID exportId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "report_id", referencedColumnName = "report_id", nullable = false)
    private Report report;

    @Column(name = "format")
    private String format;

    @Column(name = "file_path")
    private String filePath;

    @Column(name = "exported_at", nullable = false, updatable = false)
    private LocalDateTime exportedAt;

    @PrePersist
    protected void onCreate() {
        exportedAt = LocalDateTime.now();
    }
}
