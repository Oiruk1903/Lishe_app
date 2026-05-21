package com.lishe.analytics.api;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.analytics.dto.PlatformStatsResponse;
import com.lishe.analytics.service.AdminAnalyticsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/v1/admin/analytics")
@RequiredArgsConstructor
@Tag(name = "Admin Analytics", description = "Platform-wide analytics for administrators")
public class AdminController {

    private final AdminAnalyticsService adminAnalyticsService;

    @Operation(summary = "Get platform stats", description = "Retrieve global platform metrics (Requires ADMIN role)")
    @GetMapping("/platform")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<GenericRestResponse<PlatformStatsResponse>> getPlatformStats() {
        PlatformStatsResponse data = adminAnalyticsService.getPlatformStats();
        return ResponseEntity.ok(new GenericRestResponse<>(
                LocalDateTime.now().toString(),
                "200",
                "Platform statistics fetched",
                data
        ));
    }
}
