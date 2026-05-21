package com.lishe.administration.domain;

import com.lishe.administration.data.BasicInfoData;
import jakarta.persistence.*;
import lombok.Getter;

import java.time.LocalDate;
import java.time.Period;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "app_user", indexes = {@Index(name = "idx_app_user_auth_user", columnList = "auth_user", unique = true), @Index(name = "idx_app_user_mobile", columnList = "mobile", unique = true)})
@Getter
public class AppUser extends AbstractPersistableCustom<Long> {
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "auth_user")
    private AuthUser authUser;
    @Column(name = "lishe_id", unique = true, nullable = false, updatable = false)
    private String lisheId;
    @Column(name = "full_name", nullable = false)
    private String fullName;
    @Column(name = "gender", nullable = false)
    private String gender;
    @Column(name = "birth_date", nullable = false)
    private LocalDate birthDate;
    @Column(name = "mobile", nullable = false, unique = true)
    private String mobile;
    @Column(name = "profile_picture_url")
    private String profilePictureUrl;
    @Column(name = "disease_category", nullable = true)
    private String diseaseCategory;
    @Column(name = "cohort")
    private String cohort;
    @Column(name = "height", nullable = false)
    private Double height;
    @Column(name = "weight", nullable = false)
    private Double weight;
    @Column(name = "goal_status", nullable = false)
    private Integer goalStatus;
    @Column(name = "activity_status", nullable = false)
    private Integer activityStatus;
    @Column(name = "diet_status", nullable = false)
    private Integer dietStatus;

    @ElementCollection
    @CollectionTable(name = "user_allergies", joinColumns = @JoinColumn(name = "id"))
    @Column(name = "allergy")
    private Set<String> allergies;

    @ElementCollection
    @CollectionTable(name = "user_favorites", joinColumns = @JoinColumn(name = "id"))
    @Column(name = "favorite_food")
    private Set<String> favoriteFoods;


    protected AppUser() {
        // Default constructor for JPA
    }

    @PrePersist
    public void generateLisheId() {
        if (this.lisheId == null) {
            this.lisheId = UUID.randomUUID().toString();
        }
    }

    public static AppUser fromJson(AuthUser authUser, BasicInfoData basicInfoData, LocalDate birthDate) {
       final String fullName = basicInfoData.getName();
       final String gender = basicInfoData.getGender();
       final String mobile = basicInfoData.getMobile();
       final Double height = basicInfoData.getHeight();
       final Double weight = basicInfoData.getWeight();
       final String diseaseCategory = basicInfoData.getDiseaseType();
       final Integer goalStatus = basicInfoData.getGoalStatus();
       final Integer activityStatus = basicInfoData.getActivityStatus();
       final Integer dietStatus = basicInfoData.getDietStatus() != null ? basicInfoData.getDietStatus() : null;
       final Set<String> allergies = basicInfoData.getAllergies() != null ? Set.copyOf(basicInfoData.getAllergies()) : Set.of();
       final Set<String> favoriteFoods = basicInfoData.getFavoriteFoods() != null ? Set.copyOf(basicInfoData.getFavoriteFoods()) : Set.of();
       return new AppUser(authUser, fullName, gender, birthDate, mobile, diseaseCategory, height, weight, goalStatus, activityStatus, dietStatus, allergies, favoriteFoods);
    }

    public void updateProfile(Double height, Double weight, Integer goalStatus, Integer activityStatus, LocalDate birthDate) {
        this.height = height;
        this.weight = weight;
        this.goalStatus = goalStatus;
        this.activityStatus = activityStatus;
        this.birthDate = birthDate;
    }

    private AppUser(AuthUser authUser, String fullName, String gender, LocalDate birthDate, String mobile, String diseaseCategory, Double height, Double weight, Integer goalStatus, Integer activityStatus, Integer dietStatus, Set<String> allergies, Set<String> favoriteFoods) {
        this.authUser = authUser;
        this.fullName = fullName;
        this.gender = gender;
        this.birthDate = birthDate;
        this.mobile = mobile;
        this.diseaseCategory = diseaseCategory;
        this.height = height;
        this.weight = weight;
        this.goalStatus = goalStatus;
        this.activityStatus = activityStatus;
        this.dietStatus = dietStatus;
        this.allergies = allergies;
        this.favoriteFoods = favoriteFoods;
    }

    public void setCohort(String cohort) {
        this.cohort = cohort;
    }

    // Dynamically calculate the age
    public Integer getAge() {
        if (this.birthDate == null) {
            return null;
        }
        return Period.between(this.birthDate, LocalDate.now()).getYears();
    }
}
