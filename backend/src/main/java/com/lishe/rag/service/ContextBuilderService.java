package com.lishe.rag.service;

import com.lishe.nutrition.domain.UserHealthProfile;

public interface ContextBuilderService {
    String buildContext(String userQuery, UserHealthProfile profile);
}
