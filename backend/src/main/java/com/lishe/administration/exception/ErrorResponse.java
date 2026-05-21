package com.lishe.administration.exception;

import java.time.LocalDateTime;

public record ErrorResponse(
        LocalDateTime timestamp,
        int statusCode,
        String message,
        String details,
        String path
) {}
