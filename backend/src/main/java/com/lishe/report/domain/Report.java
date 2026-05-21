package com.lishe.report.domain;

import com.lishe.administration.domain.UserAccount;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Represents a generated report.
 * Reports can include health summaries, nutritional analysis, progress reports, etc.
 */
@Entity
@Table(name = "reports")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Report {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "report_id")
    private UUID reportId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "generated_by", referencedColumnName = "user_id", nullable = false)
    private UserAccount generatedBy;

    @Column(name = "report_type")
    private String reportType;

    @Column(name = "summary", columnDefinition = "TEXT")
    private String summary;

    @Column(name = "is_anonymised")
    private Boolean isAnonymised = false;

    @Column(name = "generated_at", nullable = false, updatable = false)
    private LocalDateTime generatedAt;

    @OneToMany(mappedBy = "report", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<ReportExport> reportExports;

    @PrePersist
    protected void onCreate() {
        generatedAt = LocalDateTime.now();
    }
}
