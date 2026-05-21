package com.lishe.nutrition.service;

import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.domain.UserHealthProfileRecord;
import com.lishe.administration.repository.UserAccountRepository;
import com.lishe.administration.repository.UserHealthProfileRecordRepository;
import com.lishe.nutrition.api.request.WeightTrackRequest;
import com.lishe.nutrition.api.response.BmiResponse;
import com.lishe.nutrition.api.response.BmiResult;
import com.lishe.nutrition.api.response.WeightEntryResponse;
import com.lishe.nutrition.api.response.WeightTrendResponse;
import com.lishe.nutrition.api.response.WeightTrendResponse.TrendPoint;
import com.lishe.nutrition.api.response.WeightTrendResponse.TrendStats;
import com.lishe.nutrition.domain.WeightLog;
import com.lishe.nutrition.exception.InsufficientDataException;
import com.lishe.nutrition.repository.WeightLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WeightTrackingServiceImpl implements WeightTrackingService {

    private static final double TARGET_BMI = 22.5;

    private final WeightLogRepository weightLogRepository;
    private final UserAccountRepository userAccountRepository;
    private final UserHealthProfileRecordRepository profileRepository;
    private final NutritionCalculationService calcService;

    // ─── write ───────────────────────────────────────────────────────────────

    @Override
    @Transactional
    public WeightEntryResponse log(String email, WeightTrackRequest request) {
        UserAccount account = resolve(email);

        // Determine height: use request value, or fall back to last logged height.
        double heightCm = resolveHeight(account, request.getHeightCm());

        BmiResult bmi = calcService.calculateBMI(request.getWeightKg(), heightCm);

        WeightLog log = new WeightLog();
        log.setAccount(account);
        log.setWeightKg(request.getWeightKg().floatValue());
        log.setHeightCm((float) heightCm);
        log.setBmiValue((float) bmi.getValue());
        log.setBmiCategory(bmi.getCategoryEn());
        log.setNote(request.getNote());
        log.setLoggedAt(LocalDateTime.now());

        WeightLog saved = weightLogRepository.save(log);
        return WeightEntryResponse.from(saved, account.getUserId().toString());
    }

    @Override
    @Transactional
    public void delete(String email, UUID entryId) {
        UserAccount account = resolve(email);
        WeightLog log = weightLogRepository.findByIdAndAccount(entryId, account)
                .orElseThrow(() -> new IllegalArgumentException("Weight entry not found"));
        weightLogRepository.delete(log);
    }

    // ─── read ─────────────────────────────────────────────────────────────────

    @Override
    @Transactional(readOnly = true)
    public List<WeightEntryResponse> history(String email, int days) {
        UserAccount account = resolve(email);
        LocalDateTime since = LocalDateTime.now().minusDays(Math.max(days, 1));
        return weightLogRepository
                .findByAccountAndLoggedAtAfterOrderByLoggedAtAsc(account, since)
                .stream()
                .map(log -> WeightEntryResponse.from(log, account.getUserId().toString()))
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public WeightEntryResponse latest(String email) {
        UserAccount account = resolve(email);
        WeightLog log = weightLogRepository.findFirstByAccountOrderByLoggedAtDesc(account)
                .orElseThrow(() -> new InsufficientDataException("No weight entries found"));
        return WeightEntryResponse.from(log, account.getUserId().toString());
    }

    @Override
    @Transactional(readOnly = true)
    public BmiResponse currentBmi(String email) {
        UserAccount account = resolve(email);
        WeightLog log = weightLogRepository.findFirstByAccountOrderByLoggedAtDesc(account)
                .orElseThrow(() -> new InsufficientDataException("No weight entries found — log your weight first"));

        double weight = log.getWeightKg();
        double height = log.getHeightCm() != null ? log.getHeightCm() : 0;
        if (height <= 0) throw new InsufficientDataException("Height missing — re-log weight with height");

        BmiResult bmi = calcService.calculateBMI(weight, height);

        String gender = gender(account);
        double idealWeight = devineIdealWeight(height, gender);
        double heightM = height / 100.0;

        double targetWeightKg = TARGET_BMI * (heightM * heightM);
        double weightToTarget  = round2(targetWeightKg - weight);

        return BmiResponse.builder()
                .bmi(round2(bmi.getValue()))
                .category(bmi.getCategoryEn())
                .categorySw(bmi.getCategorySw())
                .advice(bmi.getAdviceEn())
                .adviceSw(bmi.getAdviceSw())
                .weightKg(weight)
                .heightCm(height)
                .recordedAt(log.getLoggedAt() != null
                        ? log.getLoggedAt().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)
                        : null)
                .idealWeightKg(round2(idealWeight))
                .idealWeightMin(round2(idealWeight * 0.9))
                .idealWeightMax(round2(idealWeight * 1.1))
                .targetBmi(TARGET_BMI)
                .weightToTargetKg(weightToTarget)
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public WeightTrendResponse trends(String email, int days) {
        UserAccount account = resolve(email);
        LocalDateTime since = LocalDateTime.now().minusDays(Math.max(days, 1));

        List<WeightLog> logs = weightLogRepository
                .findByAccountAndLoggedAtAfterOrderByLoggedAtAsc(account, since);

        List<TrendPoint> points = logs.stream()
                .map(log -> TrendPoint.builder()
                        .date(log.getLoggedAt().toLocalDate().toString())
                        .weight(round2(log.getWeightKg() != null ? log.getWeightKg() : 0))
                        .bmi(log.getBmiValue() != null ? round2(log.getBmiValue()) : null)
                        .build())
                .toList();

        TrendStats stats = buildStats(logs);
        return WeightTrendResponse.builder().entries(points).stats(stats).build();
    }

    // ─── helpers ──────────────────────────────────────────────────────────────

    private UserAccount resolve(String email) {
        return userAccountRepository.findByEmail(email.trim().toLowerCase(Locale.ROOT))
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
    }

    private double resolveHeight(UserAccount account, Double requestedHeight) {
        if (requestedHeight != null && requestedHeight > 0) return requestedHeight;

        List<WeightLog> recent = weightLogRepository
                .findLatestWithHeightForAccount(account, PageRequest.of(0, 1));
        if (!recent.isEmpty() && recent.get(0).getHeightCm() != null) {
            return recent.get(0).getHeightCm();
        }

        throw new InsufficientDataException(
                "Height is required for your first weight entry — please include heightCm");
    }

    private String gender(UserAccount account) {
        Optional<UserHealthProfileRecord> profile = profileRepository.findByUser(account);
        String g = profile.map(UserHealthProfileRecord::getGender).orElse(null);
        return (g != null && g.toLowerCase(Locale.ROOT).startsWith("m")) ? "male" : "female";
    }

    private static double devineIdealWeight(double heightCm, String gender) {
        double inches = (heightCm - 152.4) / 2.54;
        return "male".equalsIgnoreCase(gender)
                ? 50.0 + 2.3 * inches
                : 45.5 + 2.3 * inches;
    }

    private TrendStats buildStats(List<WeightLog> logs) {
        if (logs.isEmpty()) {
            return TrendStats.builder()
                    .trend("stable").totalEntries(0).build();
        }

        double start   = logs.get(0).getWeightKg();
        double current = logs.get(logs.size() - 1).getWeightKg();
        double change  = round2(current - start);

        double lowest  = logs.stream().mapToDouble(WeightLog::getWeightKg).min().orElse(current);
        double highest = logs.stream().mapToDouble(WeightLog::getWeightKg).max().orElse(current);

        double weeks = logs.size() > 1
                ? ChronoUnit.DAYS.between(logs.get(0).getLoggedAt(), logs.get(logs.size() - 1).getLoggedAt()) / 7.0
                : 1.0;
        double weeklyChange = weeks > 0 ? round2(change / weeks) : 0;

        String trend = Math.abs(change) < 0.2 ? "stable"
                : change < 0 ? "decreasing"
                : "increasing";

        return TrendStats.builder()
                .startWeight(round2(start))
                .currentWeight(round2(current))
                .change(change)
                .trend(trend)
                .averageWeeklyChange(weeklyChange)
                .lowestWeight(round2(lowest))
                .highestWeight(round2(highest))
                .totalEntries(logs.size())
                .build();
    }

    private static double round2(double v) {
        return Math.round(v * 100.0) / 100.0;
    }
}
