package com.lishe.camera.service;

import com.lishe.camera.api.response.CameraAnalysisResponse;

public interface FoodCameraService {

    CameraAnalysisResponse analyzeImage(String email, byte[] imageBytes, String mimeType);
}
