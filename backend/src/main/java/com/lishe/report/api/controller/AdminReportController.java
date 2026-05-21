package com.lishe.report.api.controller;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.report.api.request.ExportReportRequest;
import com.lishe.report.api.request.GenerateReportRequest;
import com.lishe.report.api.response.AdminAnalyticsResponse;
import com.lishe.report.api.response.ReportExportResponse;
import com.lishe.report.api.response.ReportItemResponse;
import com.lishe.report.service.AdminReportService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(path = "/v1/admin/reports")
@RequiredArgsConstructor
@Tag(name = "Admin Reports", description = "PDF/Excel report generation and export (requires ADMIN role)")
@SecurityRequirement(name = "bearerAuth")
public class AdminReportController {

    private final AdminReportService adminReportService;

    @Operation(summary = "Get analytics dashboard", description = "Returns aggregate platform analytics for the admin dashboard")
    @GetMapping
    public ResponseEntity<GenericRestResponse<AdminAnalyticsResponse>> analytics() {
        return ResponseEntity.ok(adminReportService.getAnalyticsDashboard());
    }

    @Operation(summary = "List generated reports", description = "Returns all previously generated reports")
    @GetMapping("/list")
    public ResponseEntity<GenericRestResponse<List<ReportItemResponse>>> reports() {
        return ResponseEntity.ok(adminReportService.getReports());
    }

    @Operation(summary = "Generate a report", description = "Generates a new platform report based on the provided parameters")
    @PostMapping("/generate")
    public ResponseEntity<GenericRestResponse<ReportItemResponse>> generate(
            Authentication authentication,
            @Valid @RequestBody GenerateReportRequest request
    ) {
        return ResponseEntity.ok(adminReportService.generateReport(authentication.getName(), request));
    }

    @Operation(summary = "Export a report", description = "Exports an existing report to PDF or Excel format and returns a download path")
    @PostMapping("/{reportId}/export")
    public ResponseEntity<GenericRestResponse<ReportExportResponse>> export(
            @PathVariable UUID reportId,
            @Valid @RequestBody ExportReportRequest request
    ) {
        return ResponseEntity.ok(adminReportService.exportReport(reportId, request));
    }
}
