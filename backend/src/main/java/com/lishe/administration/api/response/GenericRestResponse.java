package com.lishe.administration.api.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
@NoArgsConstructor
@Schema(description = "Standard API response envelope used by all Lishe endpoints")
public class GenericRestResponse<T> implements Serializable {
    @JsonProperty("timestamp")
    @Schema(description = "Response timestamp (ISO-8601)", example = "2025-08-01T10:00:00")
    private String timestamp;
    @JsonProperty("statusCode")
    @Schema(description = "Application-level status code (mirrors HTTP status)", example = "200")
    private String statusCode;
    @JsonProperty("message")
    @Schema(description = "Human-readable response message", example = "Account created successfully")
    private String message;
    @JsonProperty("locale")
    @Schema(description = "Response locale (en or sw)", example = "en")
    private String locale;
    @Schema(description = "Response payload — structure depends on the endpoint")
    private T data;

    public GenericRestResponse(String timestamp, String statusCode, String message, T data) {
        this(timestamp, statusCode, message, null, data);
    }

    public GenericRestResponse(String timestamp, String statusCode, String message, String locale, T data) {
        this.timestamp = timestamp;
        this.statusCode = statusCode;
        this.message = message;
        this.locale = locale;
        this.data = data;
    }

    @Override
    public String toString(){
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(this);
        }catch (JsonProcessingException e){
            return "{}";
        }
    }

    public static <T> GenericRestResponse<T> fromJson(String json, TypeReference<GenericRestResponse<T>> typeReference){
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            return objectMapper.readValue(json, typeReference);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
