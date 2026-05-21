package com.lishe.administration.data;

import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.validation.annotation.Validated;

import java.util.List;


@Getter
@Setter
@Validated
public class BasicInfoData {
    @NotBlank
    private String name;
    @NotBlank
    private String mobile;
    @NotBlank
    private String gender;
    @NotNull
    @Positive
    private Integer goalStatus;
    private String diseaseType;
    @NotNull
    @Positive
    private Integer dietStatus;
    @NotNull
    @Positive
    private Integer activityStatus;
    @NotNull
    @Positive
    private Double weight;
    @NotNull
    @Positive
    @DecimalMin(value = "50.0", message = "Height must be at least 50 cm")
    @DecimalMax(value = "300.0", message = "Height must be at most 300 cm")
    private Double height;
    @NotNull
    @PositiveOrZero
    private Double bmiValue;
    @NotNull
    @Positive
    private Integer age;
    private List<String> allergies;
    private List<String> favoriteFoods;

}
