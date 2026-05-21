package com.lishe.chat.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ChatHistoryItemResponse {

    @JsonProperty("log_id")
    private final String logId;

    @JsonProperty("user_message")
    private final String userMessage;

    @JsonProperty("ai_response")
    private final String aiResponse;

    @JsonProperty("referral_flagged")
    private final Boolean referralFlagged;

    @JsonProperty("created_at")
    private final String createdAt;
}
