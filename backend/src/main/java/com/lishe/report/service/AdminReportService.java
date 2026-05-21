package com.lishe.report.service;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.alert.repository.NutritionAlertRepository;
import com.lishe.chat.repository.ChatLogRepository;
import com.lishe.food.repository.MealPlanRepository;
import com.lishe.report.api.request.ExportReportRequest;
import com.lishe.report.api.request.GenerateReportRequest;
import com.lishe.report.api.response.AdminAnalyticsResponse;
import com.lishe.report.api.response.ReportExportResponse;
import com.lishe.report.api.response.ReportItemResponse;
import com.lishe.report.domain.Report;
import com.lishe.report.domain.ReportExport;
import com.lishe.report.repository.ReportExportRepository;
import com.lishe.report.repository.ReportRepository;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AdminReportService {

    private final ReportRepository reportRepository;
    private final ReportExportRepository reportExportRepository;
    private final UserAccountRepository userAccountRepository;
    private final MealPlanRepository mealPlanRepository;
    private final ChatLogRepository chatLogRepository;
    private final NutritionAlertRepository nutritionAlertRepository;

    @Value("${report.export.dir:${java.io.tmpdir}/lishe-exports}")
    private String exportDirectory;

    @Transactional(readOnly = true)
    public GenericRestResponse<AdminAnalyticsResponse> getAnalyticsDashboard() {
        long totalUsers = userAccountRepository.count();
        long totalMealPlans = mealPlanRepository.count();
        long totalChatLogs = chatLogRepository.count();
        long totalAlerts = nutritionAlertRepository.count();
        long totalReports = reportRepository.count();

        AdminAnalyticsResponse payload = new AdminAnalyticsResponse(
                totalUsers,
                totalMealPlans,
                totalChatLogs,
                totalAlerts,
                totalReports,
                "All analytics are aggregated and anonymised."
        );

        return response("200", "Admin analytics fetched", payload);
    }

    @Transactional(readOnly = true)
    public GenericRestResponse<List<ReportItemResponse>> getReports() {
        List<ReportItemResponse> payload = reportRepository.findAllByOrderByGeneratedAtDesc().stream()
                .map(this::toReportItem)
                .toList();

        return response("200", "Reports fetched", payload);
    }

    @Transactional
    public GenericRestResponse<ReportItemResponse> generateReport(String principal, GenerateReportRequest request) {
        UserAccount admin = resolveUser(principal);

        Report report = new Report();
        report.setGeneratedBy(admin);
        report.setReportType(request.getReportType());
        report.setSummary(request.getSummary());
        report.setIsAnonymised(Boolean.TRUE);

        Report saved = reportRepository.save(report);
        return response("200", "Report generated", toReportItem(saved));
    }

    @Transactional
    public GenericRestResponse<ReportExportResponse> exportReport(UUID reportId, ExportReportRequest request) {
        Report report = reportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("Report not found"));

        String format = request.getFormat().trim().toUpperCase(Locale.ROOT);
        if (!"PDF".equals(format) && !"EXCEL".equals(format)) {
            throw new IllegalArgumentException("Export format must be PDF or Excel");
        }

        Path target = buildTargetPath(report.getReportId(), format);
        writeExportFile(target, format, report);

        ReportExport export = new ReportExport();
        export.setReport(report);
        export.setFormat(format);
        export.setFilePath(target.toAbsolutePath().toString());

        ReportExport savedExport = reportExportRepository.save(export);

        ReportExportResponse payload = new ReportExportResponse(
                savedExport.getExportId().toString(),
                report.getReportId().toString(),
                savedExport.getFormat(),
                savedExport.getFilePath(),
                savedExport.getExportedAt() == null ? null : savedExport.getExportedAt().toString()
        );

        return response("200", "Report exported", payload);
    }

    private void writeExportFile(Path target, String format, Report report) {
        try {
            Files.createDirectories(target.getParent());
            if ("PDF".equals(format)) {
                writePdf(target, report);
            } else {
                writeExcel(target, report);
            }
        } catch (IOException ex) {
            throw new IllegalArgumentException("Failed to write " + format + " export file", ex);
        }
    }

    private void writePdf(Path target, Report report) throws IOException {
        Document document = new Document();
        try (OutputStream outputStream = new FileOutputStream(target.toFile())) {
            PdfWriter.getInstance(document, outputStream);
            document.open();
            document.add(new Paragraph("Lishe Report"));
            document.add(new Paragraph("Report ID: " + report.getReportId()));
            document.add(new Paragraph("Type: " + report.getReportType()));
            document.add(new Paragraph("Summary: " + report.getSummary()));
            document.add(new Paragraph("Generated At: " + report.getGeneratedAt()));
            document.add(new Paragraph("Anonymised: " + report.getIsAnonymised()));
        } catch (DocumentException ex) {
            throw new IOException("Failed to generate PDF", ex);
        } finally {
            document.close();
        }
    }

    private void writeExcel(Path target, Report report) throws IOException {
        try (XSSFWorkbook workbook = new XSSFWorkbook();
             OutputStream outputStream = new FileOutputStream(target.toFile())) {
            Sheet sheet = workbook.createSheet("report");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("Field");
            header.createCell(1).setCellValue("Value");

            writeRow(sheet, 1, "Report ID", String.valueOf(report.getReportId()));
            writeRow(sheet, 2, "Type", report.getReportType());
            writeRow(sheet, 3, "Summary", report.getSummary());
            writeRow(sheet, 4, "Generated At", String.valueOf(report.getGeneratedAt()));
            writeRow(sheet, 5, "Anonymised", String.valueOf(report.getIsAnonymised()));

            sheet.autoSizeColumn(0);
            sheet.autoSizeColumn(1);
            workbook.write(outputStream);
        }
    }

    private void writeRow(Sheet sheet, int rowIndex, String key, String value) {
        Row row = sheet.createRow(rowIndex);
        row.createCell(0).setCellValue(key);
        row.createCell(1).setCellValue(value == null ? "" : value);
    }

    private Path buildTargetPath(UUID reportId, String format) {
        String extension = "PDF".equals(format) ? ".pdf" : ".xlsx";
        return Paths.get(exportDirectory, "report-" + reportId + extension);
    }

    private UserAccount resolveUser(String principal) {
        String normalized = principal == null ? "" : principal.trim();
        return userAccountRepository.findByEmail(normalized.toLowerCase(Locale.ROOT))
                .orElseGet(() -> userAccountRepository.findByPhoneNumber(normalized)
                        .orElseThrow(() -> new IllegalArgumentException("Authenticated admin not found")));
    }

    private ReportItemResponse toReportItem(Report report) {
        return new ReportItemResponse(
                report.getReportId().toString(),
                report.getReportType(),
                report.getSummary(),
                report.getIsAnonymised(),
                report.getGeneratedAt() == null ? null : report.getGeneratedAt().toString()
        );
    }

    private <T> GenericRestResponse<T> response(String statusCode, String message, T data) {
        return new GenericRestResponse<>(
                LocalDateTime.now().toString(),
                statusCode,
                message,
                data
        );
    }
}
