package com.lishe.administration.repository;

import com.lishe.administration.domain.UserAccount;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserAccountRepository extends JpaRepository<UserAccount, UUID> {
    Optional<UserAccount> findByEmail(String email);
    Optional<UserAccount> findByPhoneNumber(String phoneNumber);
    Optional<UserAccount> findByResetToken(String resetToken);
    List<UserAccount> findByLastLoginAfter(LocalDateTime dateTime);
}
