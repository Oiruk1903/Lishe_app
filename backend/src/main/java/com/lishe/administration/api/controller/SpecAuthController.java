package com.lishe.administration.api.controller;

import com.lishe.administration.api.request.*;
import com.lishe.administration.api.response.GenericRestResponse;
import com.lishe.administration.api.response.MobileAuthResponse;
import com.lishe.administration.api.response.UserDto;
import com.lishe.administration.service.SpecAuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Map;

@RestController
@RequestMapping(path = "/v1/auth")
@RequiredArgsConstructor
@Tag(name = "Mobile Auth", description = "Email/password authentication for the mobile app")
public class SpecAuthController {

    private final SpecAuthService specAuthService;

    @Operation(summary = "Register a new account")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Account registered, JWT returned"),
            @ApiResponse(responseCode = "400", description = "Validation error", content = @Content),
            @ApiResponse(responseCode = "409", description = "Email already registered", content = @Content)
    })
    @PostMapping("/register")
    public ResponseEntity<GenericRestResponse<MobileAuthResponse>> register(
            @Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.ok(specAuthService.register(request));
    }

    @Operation(summary = "Login with email and password")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Login successful, JWT returned"),
            @ApiResponse(responseCode = "401", description = "Invalid credentials", content = @Content)
    })
    @PostMapping("/login")
    public ResponseEntity<GenericRestResponse<MobileAuthResponse>> login(
            @Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(specAuthService.login(request));
    }

    @Operation(summary = "Refresh access token using a valid refresh token")
    @PostMapping("/refresh")
    public ResponseEntity<GenericRestResponse<MobileAuthResponse>> refresh(
            @RequestBody Map<String, String> body) {
        String refreshToken = body.get("refresh_token");
        if (refreshToken == null || refreshToken.isBlank()) {
            throw new IllegalArgumentException("refresh_token is required");
        }
        return ResponseEntity.ok(specAuthService.refresh(refreshToken));
    }

    @Operation(summary = "Logout (client should discard the token)")
    @SecurityRequirement(name = "bearerAuth")
    @PostMapping("/logout")
    public ResponseEntity<GenericRestResponse<String>> logout() {
        GenericRestResponse<String> response = new GenericRestResponse<>(
                java.time.LocalDateTime.now().toString(), "200", "Logged out successfully", "ok");
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Get current user profile")
    @SecurityRequirement(name = "bearerAuth")
    @GetMapping("/profile")
    public ResponseEntity<GenericRestResponse<UserDto>> getProfile(Principal principal) {
        return ResponseEntity.ok(specAuthService.getProfile(principal.getName()));
    }

    @Operation(summary = "Update current user profile")
    @SecurityRequirement(name = "bearerAuth")
    @PutMapping("/profile")
    public ResponseEntity<GenericRestResponse<UserDto>> updateProfile(
            Principal principal,
            @RequestBody MobileProfileRequest request) {
        return ResponseEntity.ok(specAuthService.updateProfile(principal.getName(), request));
    }

    @Operation(summary = "Change password")
    @SecurityRequirement(name = "bearerAuth")
    @PostMapping("/change-password")
    public ResponseEntity<GenericRestResponse<String>> changePassword(
            Principal principal,
            @RequestBody Map<String, String> body) {
        String oldPassword = body.get("old_password");
        String newPassword = body.get("new_password");
        return ResponseEntity.ok(specAuthService.changePassword(principal.getName(), oldPassword, newPassword));
    }

    @Operation(summary = "Request password reset code via email")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Reset code sent"),
            @ApiResponse(responseCode = "404", description = "Email not found", content = @Content)
    })
    @PostMapping("/forgot-password")
    public ResponseEntity<GenericRestResponse<String>> forgotPassword(
            @Valid @RequestBody ForgotPasswordRequest request) {
        return ResponseEntity.ok(specAuthService.forgotPassword(request));
    }

    @Operation(summary = "Verify password reset code")
    @PostMapping("/forgot-password/verify")
    public ResponseEntity<GenericRestResponse<Boolean>> verifyResetCode(
            @Valid @RequestBody VerifyResetCodeRequest request) {
        return ResponseEntity.ok(specAuthService.verifyResetCode(request));
    }

    @Operation(summary = "Reset password using email and code")
    @PostMapping("/forgot-password/reset")
    public ResponseEntity<GenericRestResponse<String>> resetPassword(
            @Valid @RequestBody ResetPasswordRequest request) {
        return ResponseEntity.ok(specAuthService.resetPassword(request));
    }
}
