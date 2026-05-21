package com.lishe.config;

import org.springframework.ai.document.Document;
import org.springframework.ai.embedding.AbstractEmbeddingModel;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.embedding.EmbeddingRequest;
import org.springframework.ai.embedding.EmbeddingResponse;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AiConfig {

    @Bean
    @ConditionalOnMissingBean(EmbeddingModel.class)
    public EmbeddingModel noOpEmbeddingModel() {
        return new AbstractEmbeddingModel() {
            @Override
            public EmbeddingResponse call(EmbeddingRequest request) {
                throw new UnsupportedOperationException(
                        "EmbeddingModel not configured — set AI_PROVIDER=spring-ai-gemini with " +
                        "SPRING_AI_MODEL_EMBEDDING=vertexai and Google Cloud credentials.");
            }

            @Override
            public float[] embed(Document document) {
                throw new UnsupportedOperationException(
                        "EmbeddingModel not configured — set AI_PROVIDER=spring-ai-gemini with " +
                        "SPRING_AI_MODEL_EMBEDDING=vertexai and Google Cloud credentials.");
            }
        };
    }
}
