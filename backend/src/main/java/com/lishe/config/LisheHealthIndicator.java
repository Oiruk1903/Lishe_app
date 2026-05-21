package com.lishe.config;

import lombok.RequiredArgsConstructor;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class LisheHealthIndicator implements HealthIndicator {

    private final JdbcTemplate jdbcTemplate;


    @Override
    public Health health() {
        Health.Builder status = Health.up();
        
        try {
            // 1. DB Check
            jdbcTemplate.execute("SELECT 1");
            status.withDetail("database", "Reachable");

            // 2. Foods Count
            Long foodCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM foods", Long.class);
            status.withDetail("foods_loaded", foodCount);
            if (foodCount == 0) status.status("WARNING").withDetail("foods_warning", "No foods in TFNC database");

            // 3. Embeddings Count
            Long embeddingCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM food_embeddings", Long.class);
            status.withDetail("embeddings_loaded", embeddingCount);
            if (embeddingCount == 0) status.status("WARNING").withDetail("embeddings_warning", "RAG vector store is empty");

            // 4. Gemini Configuration Status
            status.withDetail("gemini_ai", "Configured (Ping disabled to save token budget)");

        } catch (Exception e) {
            status.down(e);
        }

        return status.build();
    }
}
