package com.lishe.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
        info = @Info(
                title = "Lishe AI API",
                version = "v1.0.0",
                description = "AI-Powered Nutrition Assistant for Tanzania - Grounded in TFNC Intelligence"
        ),
        security = @SecurityRequirement(name = "bearerAuth"),
        tags = {
                @Tag(name = "Auth", description = "Mobile OTP-based authentication for app users"),
                @Tag(name = "Specialist Auth", description = "Email/password authentication for specialists and web users"),
                @Tag(name = "User", description = "App user profile management"),
                @Tag(name = "Specialist Profile", description = "Specialist user profile management"),
                @Tag(name = "Nutrition", description = "Nutrition calculations, TFNC food catalog, and meal logging"),
                @Tag(name = "Water Intake", description = "Track and monitor daily water consumption"),
                @Tag(name = "Chat", description = "AI RAG-grounded TFNC nutrition chatbot"),
                @Tag(name = "Camera", description = "AI vision-based food image analysis"),
                @Tag(name = "Recommendations", description = "Personalized hybrid nutrition recommendations"),
                @Tag(name = "Analytics", description = "User nutrition progress and analytics"),
                @Tag(name = "Admin Analytics", description = "Platform-wide statistics for administrators"),
                @Tag(name = "Admin Reports", description = "PDF/Excel report generation and export")
        }
)
@SecurityScheme(
        name = "bearerAuth",
        type = SecuritySchemeType.HTTP,
        scheme = "bearer",
        bearerFormat = "JWT"
)
public class OpenApiConfig {
}
