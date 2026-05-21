package com.lishe.chat.api.controller;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.chat.api.request.ChatMessageRequest;
import com.lishe.chat.api.response.ChatHistoryItemResponse;
import com.lishe.chat.api.response.ChatMessageResponse;
import com.lishe.chat.service.ChatService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(path = "/v1/ai/chat")
@RequiredArgsConstructor
@Tag(name = "Chat", description = "AI RAG-grounded TFNC nutrition chatbot")
@SecurityRequirement(name = "bearerAuth")
public class ChatController {

    private final ChatService chatService;

    @Operation(
            summary = "Send a chat message",
            description = "Sends a question to the TFNC nutrition AI assistant. Context is grounded via pgvector semantic search."
    )
    @PostMapping
    public ResponseEntity<GenericRestResponse<ChatMessageResponse>> chat(
            Authentication authentication,
            @Valid @RequestBody ChatMessageRequest request
    ) {
        return ResponseEntity.ok(chatService.chat(authentication.getName(), request.getMessage()));
    }

    @Operation(summary = "Get chat history", description = "Returns the conversation history for the authenticated user")
    @GetMapping("/history")
    public ResponseEntity<GenericRestResponse<List<ChatHistoryItemResponse>>> history(Authentication authentication) {
        return ResponseEntity.ok(chatService.getHistory(authentication.getName()));
    }
}
