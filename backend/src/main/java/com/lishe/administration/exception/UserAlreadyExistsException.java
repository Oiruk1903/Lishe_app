package com.lishe.administration.exception;

public class UserAlreadyExistsException extends RuntimeException {
    public UserAlreadyExistsException() {
        super(ResponseMessages.ACCOUNT_ALREADY_EXISTS);
    }
}
