package com.lishe.report.api.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ExportReportRequest {

    @NotBlank
    private String format;
}
