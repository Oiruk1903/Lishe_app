package com.lishe.report.api.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GenerateReportRequest {

    @JsonProperty("report_type")
    @NotBlank
    private String reportType;

    @NotBlank
    private String summary;
}
