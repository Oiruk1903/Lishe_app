package com.lishe.chat.service;

import java.util.regex.Pattern;

public final class SafetyFilter {

    private static final Pattern NUTRITION_NUMERIC_PATTERN =
            Pattern.compile("\\b\\d+(\\.\\d+)?\\s*(kcal|mg|g|mcg)\\b", Pattern.CASE_INSENSITIVE);

    private static final Pattern DISALLOWED_KEYWORDS =
            Pattern.compile("\\b(supplement|medicine|drug|dose|tablet|capsule|prescription)\\b",
                    Pattern.CASE_INSENSITIVE);

    private SafetyFilter() {
    }

    public static String filter(String rawResponse) {
        if (rawResponse == null) {
            return "";
        }

        String filtered = rawResponse;

        if (NUTRITION_NUMERIC_PATTERN.matcher(filtered).find()) {
            filtered = NUTRITION_NUMERIC_PATTERN.matcher(filtered)
                    .replaceAll("[NUTRITION VALUE REMOVED]");
        }

        if (DISALLOWED_KEYWORDS.matcher(filtered).find()) {
            filtered = DISALLOWED_KEYWORDS.matcher(filtered)
                    .replaceAll("[NENO LISILORUHUSIWA]");
            filtered = filtered + " Tafadhali wasiliana na mtaalamu wa afya kwa ushauri wa kimatibabu.";
        }

        return filtered;
    }
}
