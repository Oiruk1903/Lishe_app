package com.lishe.administration.exception;

public class HandleOtpException extends RuntimeException {
    public HandleOtpException() {
        super(ResponseMessages.INVALID_TOKEN);
    }

    public HandleOtpException(String message) {
        super(message);
    }
}
