package com.lishe.chat.api.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ChatMessageRequest {

    @JsonProperty("message")
    @NotBlank
    private String message;
}
