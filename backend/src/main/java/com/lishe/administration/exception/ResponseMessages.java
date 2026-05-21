package com.lishe.administration.exception;

public class ResponseMessages {
    //USER MANAGEMENT ERROR MESSAGES
    public static final String ACCOUNT_CREATION_SUCCESS = "Account created successfully";
    public static final String USER_NOT_FOUND = "User not found";
    public static final String ACCOUNT_ALREADY_EXISTS = "Account already exists with this mobile number";

    // INPUT VALIDATION ERROR MESSAGES
    public static final String INVALID_INPUT = "Invalid input data";
    public static final String NULL_INPUT_VALUE = "Input data cannot be null";
    public static final String USER_ID_NULL = "User ID cannot be null";

    //SERVICE ERROR MESSAGES
    public static final String INTERNAL_SERVER_ERROR = "Internal server error";
    public static final String RESOURCE_NOT_FOUND = "Requested resource not found";
    public static final String OPERATION_FAILED = "Operation failed, please try again later";

    // SECURITY ERROR MESSAGES
    public static final String INVALID_CREDENTIALS = "Invalid credentials";
    public static final String UNAUTHORIZED_ACCESS = "Unauthorized access";
    public static final String INVALID_TOKEN = "Invalid or expired token";
}
