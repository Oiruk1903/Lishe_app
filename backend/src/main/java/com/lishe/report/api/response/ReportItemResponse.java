package com.lishe.report.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ReportItemResponse {

    @JsonProperty("report_id")
    private final String reportId;

    @JsonProperty("report_type")
    private final String reportType;

    private final String summary;

    @JsonProperty("is_anonymised")
    private final Boolean isAnonymised;

    @JsonProperty("generated_at")
    private final String generatedAt;
}
