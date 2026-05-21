package com.lishe.administration.repository;

import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.domain.UserHealthProfileRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserHealthProfileRecordRepository extends JpaRepository<UserHealthProfileRecord, UUID> {
    Optional<UserHealthProfileRecord> findByUser(UserAccount user);
}
