package com.lishe.nutrition.service;

import com.lishe.nutrition.api.request.WeightTrackRequest;
import com.lishe.nutrition.api.response.BmiResponse;
import com.lishe.nutrition.api.response.WeightEntryResponse;
import com.lishe.nutrition.api.response.WeightTrendResponse;

import java.util.List;
import java.util.UUID;

public interface WeightTrackingService {

    WeightEntryResponse log(String email, WeightTrackRequest request);

    List<WeightEntryResponse> history(String email, int days);

    WeightEntryResponse latest(String email);

    BmiResponse currentBmi(String email);

    WeightTrendResponse trends(String email, int days);

    void delete(String email, UUID entryId);
}
