package com.lishe.jwt.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.annotation.web.configurers.HeadersConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final AuthenticationProvider authenticationProvider;
    private final JwtFilter jwtAuthenticationFilter;

    private static final String[] SWAGGER_WHITELIST = {
            "/swagger-ui.html",
            "/swagger-ui/**",
            "/v3/api-docs",
            "/v3/api-docs/**",
            "/swagger-resources/**",
            "/webjars/**"
    };

    private static final String[] PUBLIC_PATHS = {
            "/v1/auth/register",
            "/v1/auth/login",
            "/v1/auth/refresh",
            "/v1/auth/forgot-password",
            "/v1/auth/forgot-password/verify",
            "/v1/auth/forgot-password/reset",
    };

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .csrf(AbstractHttpConfigurer::disable)
                .headers(headers -> headers
                        .httpStrictTransportSecurity(hsts -> hsts
                                .includeSubDomains(true)
                                .preload(true)
                                .maxAgeInSeconds(63072000)
                        )
                        .contentSecurityPolicy(csp -> csp
                                .policyDirectives("default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:")
                        )
                        .frameOptions(HeadersConfigurer.FrameOptionsConfig::sameOrigin)
                )
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(SWAGGER_WHITELIST).permitAll()
                        .requestMatchers(PUBLIC_PATHS).permitAll()
                        .requestMatchers("/actuator/health").permitAll()
                        .requestMatchers("/v1/admin/**").hasAnyAuthority("ADMIN", "ROLE_ADMIN")
                        .anyRequest().authenticated()
                )
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authenticationProvider(authenticationProvider)
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of(
                "http://localhost:3000",
                "http://192.168.145.49:3000"
        ));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("Authorization", "Cache-Control", "Content-Type"));
        configuration.setExposedHeaders(List.of("X-Rate-Limit-Remaining", "X-Rate-Limit-Reset"));
        configuration.setMaxAge(3600L); // 1 hour
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
/*@Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html")
                .hasRole("ADMIN")
                .anyRequest().authenticated()
            )
            .csrf().ignoringRequestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html")
            .and()
            .build();
    }
*/