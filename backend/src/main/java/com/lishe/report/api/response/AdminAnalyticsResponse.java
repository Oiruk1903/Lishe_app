package com.lishe.report.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class AdminAnalyticsResponse {

    @JsonProperty("total_users")
    private final long totalUsers;

    @JsonProperty("total_meal_plans")
    private final long totalMealPlans;

    @JsonProperty("total_chat_logs")
    private final long totalChatLogs;

    @JsonProperty("total_alerts")
    private final long totalAlerts;

    @JsonProperty("total_reports")
    private final long totalReports;

    @JsonProperty("anonymised_note")
    private final String anonymisedNote;
}
