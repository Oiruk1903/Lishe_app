package com.lishe.chat.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class ChatMessageResponse {

    @JsonProperty("ai_response")
    private final String aiResponse;

    @JsonProperty("referral_flagged")
    private final Boolean referralFlagged;

    @JsonProperty("advisory_message")
    private final String advisoryMessage;
}
