package com.lishe.nutrition.repository;

import com.lishe.administration.domain.AppUser;
import com.lishe.nutrition.domain.UserHealthProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserHealthProfileRepository extends JpaRepository<UserHealthProfile, UUID> {
    Optional<UserHealthProfile> findByUser(AppUser user);
}