package com.lishe.recommendation.job;

import com.lishe.administration.domain.AppUser;
import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.repository.AppUserRepository;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.recommendation.service.RecommendationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Slf4j
@Component
@RequiredArgsConstructor
public class DailyRecommendationJob {

    private final RecommendationService recommendationService;
    private final UserAccountRepository userAccountRepository;
    private final AppUserRepository appUserRepository;

    @Scheduled(cron = "0 0 6 * * ?")
    public void runDailyRecommendations() {
        log.info("Starting scheduled daily recommendations job...");
        
        LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(7);
        List<UserAccount> activeAccounts = userAccountRepository.findByLastLoginAfter(sevenDaysAgo);
        
        int success = 0;
        int failure = 0;

        for (UserAccount account : activeAccounts) {
            try {
                if (account.getPhoneNumber() != null) {
                    appUserRepository.findByMobile(account.getPhoneNumber()).ifPresent(appUser -> {
                        recommendationService.getRecommendations(UUID.fromString(appUser.getLisheId()));
                    });
                    success++;
                }
            } catch (Exception e) {
                log.error("Failed to generate recommendation for user: {}", account.getEmail(), e);
                failure++;
            }
        }

        log.info("Scheduled daily recommendations completed. Success: {}, Failure: {}", success, failure);
    }
}
