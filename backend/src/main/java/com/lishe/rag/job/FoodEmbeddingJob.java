package com.lishe.rag.job;

import com.lishe.rag.service.EmbeddingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class FoodEmbeddingJob {

    private final EmbeddingService embeddingService;

    @EventListener(ApplicationReadyEvent.class)
    public void onApplicationReady() {
        log.info("Application is ready. Starting background food embedding job...");
        embeddingService.embedAllFoods();
    }
}
