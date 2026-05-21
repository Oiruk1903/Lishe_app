package com.lishe.report.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ReportExportResponse {

    @JsonProperty("export_id")
    private final String exportId;

    @JsonProperty("report_id")
    private final String reportId;

    private final String format;

    @JsonProperty("file_path")
    private final String filePath;

    @JsonProperty("exported_at")
    private final String exportedAt;
}
