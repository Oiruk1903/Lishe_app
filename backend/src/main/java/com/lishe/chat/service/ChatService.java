package com.lishe.chat.service;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.domain.UserHealthProfileRecord;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.administration.repository.UserHealthProfileRecordRepository;
import com.lishe.chat.api.response.ChatHistoryItemResponse;
import com.lishe.chat.api.response.ChatMessageResponse;
import com.lishe.chat.domain.ChatLog;
import com.lishe.chat.repository.ChatLogRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import java.util.Set;

@Service
@Slf4j
public class ChatService {

    private static final String REFERRAL_ADVISORY = "This question may need a licensed health professional. Please consult your nearest clinician or nutrition specialist.";

    private static final Set<String> REFERRAL_KEYWORDS = Set.of(
            "severe", "blood", "bleeding", "faint", "unconscious", "pregnancy complication",
            "chest pain", "stroke", "emergency", "suicidal", "overdose", "hospital"
    );

    private final ChatLogRepository chatLogRepository;
    private final UserAccountRepository userAccountRepository;
    private final UserHealthProfileRecordRepository profileRepository;
    private final ChatClient chatClient;

    public ChatService(ChatLogRepository chatLogRepository,
                       UserAccountRepository userAccountRepository,
                       UserHealthProfileRecordRepository profileRepository,
                       ChatClient.Builder chatClientBuilder) {
        this.chatLogRepository = chatLogRepository;
        this.userAccountRepository = userAccountRepository;
        this.profileRepository = profileRepository;
        this.chatClient = chatClientBuilder.build();
    }

    @Transactional
    public GenericRestResponse<ChatMessageResponse> chat(String principal, String userMessage) {
        UserAccount user = resolveUser(principal);
        UserHealthProfileRecord profile = profileRepository.findByUser(user)
                .orElseThrow(() -> new IllegalArgumentException("Health profile not found"));

        String prompt = buildPrompt(profile, userMessage);
        String aiResponse = chatClient.prompt(prompt).call().content();

        boolean referralFlagged = shouldFlagReferral(userMessage, aiResponse);
        String finalResponse = referralFlagged ? aiResponse + "\n\n" + REFERRAL_ADVISORY : aiResponse;

        ChatLog log = new ChatLog();
        log.setUser(user);
        log.setUserMessage(userMessage);
        log.setAiResponse(finalResponse);
        log.setReferralFlagged(referralFlagged);
        chatLogRepository.save(log);

        ChatMessageResponse payload = new ChatMessageResponse(finalResponse, referralFlagged, referralFlagged ? REFERRAL_ADVISORY : null);
        return response("200", "Chat response generated", payload);
    }

    @Transactional(readOnly = true)
    public GenericRestResponse<List<ChatHistoryItemResponse>> getHistory(String principal) {
        UserAccount user = resolveUser(principal);
        List<ChatHistoryItemResponse> payload = chatLogRepository.findByUserOrderByCreatedAtDesc(user).stream()
                .map(item -> new ChatHistoryItemResponse(
                        item.getLogId().toString(),
                        item.getUserMessage(),
                        item.getAiResponse(),
                        item.getReferralFlagged(),
                        item.getCreatedAt() == null ? null : item.getCreatedAt().toString()
                ))
                .toList();

        return response("200", "Chat history fetched", payload);
    }

    private UserAccount resolveUser(String principal) {
        String normalized = principal == null ? "" : principal.trim();
        return userAccountRepository.findByEmail(normalized.toLowerCase(Locale.ROOT))
            .orElseGet(() -> userAccountRepository.findByPhoneNumber(normalized)
                .orElseThrow(() -> new IllegalArgumentException("Authenticated user not found")));
    }

    private String buildPrompt(UserHealthProfileRecord profile, String userMessage) {
        String systemPrompt = "You are Lishe nutrition assistant. Follow TFNC-aligned guidance for Tanzanian nutrition. " +
                "Give practical and safe recommendations only, avoid diagnosis, and suggest professional referral for complex medical questions.";

        String context = String.format(
                Locale.ROOT,
                "User context: nutrition_group=%s, health_condition=%s, pregnancy_status=%s, gender=%s.",
                safe(profile.getNutritionGroup()),
                safe(profile.getHealthCondition()),
                safe(profile.getPregnancyStatus()),
                safe(profile.getGender())
        );

        return systemPrompt + "\n" + context + "\nUser question: " + userMessage;
    }

    private boolean shouldFlagReferral(String userMessage, String aiResponse) {
        String combined = (safe(userMessage) + " " + safe(aiResponse)).toLowerCase(Locale.ROOT);
        return REFERRAL_KEYWORDS.stream().anyMatch(combined::contains);
    }

    private String safe(String value) {
        return value == null ? "" : value;
    }

    private <T> GenericRestResponse<T> response(String statusCode, String message, T data) {
        return new GenericRestResponse<>(
                LocalDateTime.now().toString(),
                statusCode,
                message,
                data
        );
    }
}
