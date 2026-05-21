package com.lishe.administration.domain;

public enum DietCategory {

    INVALID(0, "DietCategory.invalid"),
    MOTHERS_AND_CHILDREN(100, "DietCategory.mothers_and_children"),
    ADOLESCENTS(200, "DietCategory.adolescents"),
    NCD(300, "DietCategory.ncd"),
    MALNUTRITION(400, "DietCategory.malnutrition"),
    SCHOOL_STUDENTS(500, "DietCategory.school_students"),
    UNIVERSITY_STUDENTS(600, "DietCategory.university_students");
    private final Integer value;
    private final String code;

    public static DietCategory fromInt(final Integer value) {
        DietCategory enumeration = DietCategory.INVALID;

        switch (value) {
            case 100:
                enumeration = MOTHERS_AND_CHILDREN;
                break;
            case 200:
                enumeration = ADOLESCENTS;
                break;
            case 300:
                enumeration = NCD;
                break;
            case 400:
                enumeration = MALNUTRITION;
                break;
            case 500:
                enumeration = SCHOOL_STUDENTS;
                break;
            case 600:
                enumeration = UNIVERSITY_STUDENTS;
                break;
        }
        return enumeration;
    }

    private  DietCategory(final Integer value, final String code) {
        this.value = value;
        this.code = code;
    }

    public boolean hasStateOf(DietCategory state) {
        return this.value.equals(state.getValue());
    }

    public Integer getValue() {
        return this.value;
    }

    public String getCode() {
        return this.code;
    }
}
