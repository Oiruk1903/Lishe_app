package com.lishe.camera.repository;

import com.lishe.camera.domain.CameraAnalysis;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface CameraAnalysisRepository extends JpaRepository<CameraAnalysis, UUID> {
    List<CameraAnalysis> findByUser_IdOrderByCreatedAtDesc(Long userId);
}
