package com.lishe.rag.domain;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import java.util.Arrays;

@Converter
public class FloatArrayVectorConverter implements AttributeConverter<float[], String> {

    @Override
    public String convertToDatabaseColumn(float[] attribute) {
        if (attribute == null) {
            return null;
        }
        return Arrays.toString(attribute);
    }

    @Override
    public float[] convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) {
            return null;
        }
        String cleaned = dbData.replace("[", "").replace("]", "");
        if (cleaned.trim().isEmpty()) {
            return new float[0];
        }
        String[] parts = cleaned.split(",");
        float[] vector = new float[parts.length];
        for (int i = 0; i < parts.length; i++) {
            vector[i] = Float.parseFloat(parts[i].trim());
        }
        return vector;
    }
}
