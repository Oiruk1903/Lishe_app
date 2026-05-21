package com.lishe.camera.exception;

public class CameraException extends RuntimeException {

    public CameraException(String message) {
        super(message);
    }

    public CameraException(String message, Throwable cause) {
        super(message, cause);
    }
}
