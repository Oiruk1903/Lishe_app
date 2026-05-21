package com.lishe.administration.exception;

public class UserNotFoundException extends RuntimeException{
    public UserNotFoundException() {
        super(ResponseMessages.USER_NOT_FOUND);
    }

    public  UserNotFoundException(String message) {
        super(message);
    }

}
