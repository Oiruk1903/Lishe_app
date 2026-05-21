package com.lishe.camera.api.controller;

import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.camera.api.response.CameraAnalysisResponse;
import com.lishe.camera.exception.InvalidImageException;
import com.lishe.camera.service.FoodCameraService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/v1/ai")
@RequiredArgsConstructor
@Validated
@Tag(name = "Camera", description = "AI food image analysis via Gemini Vision")
@SecurityRequirement(name = "bearerAuth")
public class CameraController {

    private final FoodCameraService foodCameraService;

    @Operation(
            summary = "Analyze a food plate image",
            description = "Upload a photo of a meal; Gemini Vision identifies foods and calculates TFNC-aligned nutrition."
    )
    @PostMapping(value = "/analyze-plate", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<GenericRestResponse<CameraAnalysisResponse>> analyzeImage(
            Authentication authentication,
            @NotNull @RequestParam("image") MultipartFile image) {

        if (image.isEmpty()) throw new InvalidImageException("Image file is required");

        try {
            CameraAnalysisResponse payload = foodCameraService.analyzeImage(
                    authentication.getName(),
                    image.getBytes(),
                    image.getContentType()
            );
            return ResponseEntity.ok(wrap("Camera analysis completed", payload));
        } catch (java.io.IOException ex) {
            throw new InvalidImageException("Unable to read uploaded image file");
        }
    }

    private <T> GenericRestResponse<T> wrap(String message, T data) {
        return new GenericRestResponse<>(
                LocalDateTime.now().toString(), "200", message,
                LocaleContextHolder.getLocale().getLanguage(), data);
    }
}
