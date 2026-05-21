package com.lishe.administration.api.response;

import com.lishe.administration.domain.UserAccount;
import com.lishe.administration.domain.UserHealthProfileRecord;
import lombok.Builder;
import lombok.Getter;

import java.time.format.DateTimeFormatter;

@Getter
@Builder
public class UserDto {

    private String id;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String dateOfBirth;
    private String gender;
    private String cohort;
    private String createdAt;

    public static UserDto from(UserAccount account, UserHealthProfileRecord profile) {
        return UserDto.builder()
                .id(account.getUserId().toString())
                .fullName(account.getFullName())
                .email(account.getEmail())
                .phoneNumber(account.getPhoneNumber())
                .dateOfBirth(profile != null && profile.getDateOfBirth() != null
                        ? profile.getDateOfBirth().toString()
                        : null)
                .gender(profile != null ? profile.getGender() : null)
                .cohort(profile != null ? profile.getNutritionGroup() : null)
                .createdAt(account.getCreatedAt() != null
                        ? account.getCreatedAt().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)
                        : null)
                .build();
    }
}
