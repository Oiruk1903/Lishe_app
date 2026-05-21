package com.lishe.chat.repository;

import com.lishe.administration.domain.UserAccount;
import com.lishe.chat.domain.ChatLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ChatLogRepository extends JpaRepository<ChatLog, UUID> {
    List<ChatLog> findByUserOrderByCreatedAtDesc(UserAccount user);
}
