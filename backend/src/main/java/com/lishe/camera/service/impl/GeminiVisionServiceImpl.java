package com.lishe.camera.service.impl;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lishe.camera.api.response.IdentifiedFood;
import com.lishe.camera.exception.VisionServiceException;
import com.lishe.camera.service.GeminiVisionService;
import com.lishe.nutrition.api.response.NutrientSummary;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.util.MimeType;
import org.springframework.util.MimeTypeUtils;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Collections;
import java.util.List;
import java.util.Locale;

@Service
@Slf4j
public class GeminiVisionServiceImpl implements GeminiVisionService {

    private static final String IDENTIFY_PROMPT = """
            Identify all foods visible in this image.
            For each food respond ONLY as a JSON array:
            [{\"name_en\":\"...\",\"name_sw\":\"...\",\"confidence\":0.0-1.0,\"estimated_grams\":100}]
            Only include foods you are confident about.
            """;

    private final ChatClient chatClient;
    private final ObjectMapper objectMapper;

    public GeminiVisionServiceImpl(ChatClient.Builder chatClientBuilder, ObjectMapper objectMapper) {
        this.chatClient = chatClientBuilder.build();
        this.objectMapper = objectMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public List<IdentifiedFood> identifyFoods(byte[] imageBytes) {
        if (imageBytes == null || imageBytes.length == 0) {
            return List.of();
        }

        try {
            MimeType mimeType = detectMimeType(imageBytes);
            ByteArrayResource imageResource = new ByteArrayResource(imageBytes) {
                @Override
                public String getFilename() {
                    return "camera-image";
                }
            };

            String response = chatClient.prompt()
                    .user(user -> user
                            .text(IDENTIFY_PROMPT)
                            .media(mimeType, imageResource))
                    .call()
                    .content();

            return parseIdentifiedFoods(response);
        } catch (Exception ex) {
            log.warn("Gemini vision identification failed; returning empty list: {}", ex.getMessage());
            return List.of();
        }
    }

    @Override
    @Transactional(readOnly = true)
    public String generateMealExplanation(NutrientSummary summary, String cohort) {
        NutrientSummary safeSummary = summary == null
                ? new NutrientSummary(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                : summary;

        String normalizedCohort = cohort == null || cohort.isBlank() ? "ADULT" : cohort.trim().toUpperCase(Locale.ROOT);
        String prompt = String.format(Locale.ROOT, """
                Eleza thamani ya lishe ya mlo huu kwa Kiswahili.
                Jumla ya kalori: %.2f, Protini: %.2fg, Wanga: %.2fg, Mafuta: %.2fg.
                Kikundi cha mtumiaji: %s.
                Toa ushauri mfupi wa lishe.
                """,
                safeSummary.getTotalKcal(),
                safeSummary.getTotalProtein(),
                safeSummary.getTotalCarbs(),
                safeSummary.getTotalFat(),
                normalizedCohort);

        try {
            String explanation = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();

            if (explanation == null || explanation.isBlank()) {
                return fallbackExplanation(normalizedCohort);
            }
            return explanation.trim();
        } catch (Exception ex) {
            log.warn("Gemini meal explanation failed; using fallback text: {}", ex.getMessage());
            return fallbackExplanation(normalizedCohort);
        }
    }

    private List<IdentifiedFood> parseIdentifiedFoods(String response) {
        if (response == null || response.isBlank()) {
            return List.of();
        }

        try {
            String sanitized = sanitizeJson(response);
            if (sanitized.isBlank()) {
                return List.of();
            }
            return objectMapper.readValue(sanitized, new TypeReference<List<IdentifiedFood>>() {
            });
        } catch (Exception ex) {
            log.warn("Unable to parse Gemini vision JSON response; returning empty list. Reason: {}", ex.getMessage());
            return Collections.emptyList();
        }
    }

    private String sanitizeJson(String response) {
        String cleaned = response.trim();
        if (cleaned.startsWith("```")) {
            cleaned = cleaned.replaceFirst("^```(?:json)?\\s*", "");
            if (cleaned.endsWith("```")) {
                cleaned = cleaned.substring(0, cleaned.length() - 3).trim();
            }
        }

        int arrayStart = cleaned.indexOf('[');
        int arrayEnd = cleaned.lastIndexOf(']');
        if (arrayStart >= 0 && arrayEnd > arrayStart) {
            cleaned = cleaned.substring(arrayStart, arrayEnd + 1);
        }

        return cleaned;
    }

    private String fallbackExplanation(String cohort) {
        return "Uchambuzi wa lishe umehifadhiwa, lakini maelezo ya ziada hayawezi kutolewa sasa. "
                + "Endelea kuchagua milo yenye uwiano kwa kikundi cha " + cohort + ".";
    }

    private MimeType detectMimeType(byte[] imageBytes) {
        if (looksLikePng(imageBytes)) {
            return MimeTypeUtils.IMAGE_PNG;
        }
        if (looksLikeWebp(imageBytes)) {
            return MimeTypeUtils.parseMimeType("image/webp");
        }
        return MimeTypeUtils.IMAGE_JPEG;
    }

    private boolean looksLikePng(byte[] imageBytes) {
        return imageBytes.length >= 8
                && (imageBytes[0] & 0xFF) == 0x89
                && imageBytes[1] == 0x50
                && imageBytes[2] == 0x4E
                && imageBytes[3] == 0x47
                && imageBytes[4] == 0x0D
                && imageBytes[5] == 0x0A
                && imageBytes[6] == 0x1A
                && imageBytes[7] == 0x0A;
    }

    private boolean looksLikeWebp(byte[] imageBytes) {
        return imageBytes.length >= 12
                && imageBytes[0] == 'R'
                && imageBytes[1] == 'I'
                && imageBytes[2] == 'F'
                && imageBytes[3] == 'F'
                && imageBytes[8] == 'W'
                && imageBytes[9] == 'E'
                && imageBytes[10] == 'B'
                && imageBytes[11] == 'P';
    }
}
