package com.lishe.administration.repository;

import com.lishe.administration.domain.AuthUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AuthRepository extends JpaRepository<AuthUser, Long> {
    Optional<AuthUser> findByUsername(String identifier);
}
