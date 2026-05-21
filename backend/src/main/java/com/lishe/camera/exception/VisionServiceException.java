package com.lishe.camera.exception;

public class VisionServiceException extends CameraException {

    public VisionServiceException(String message) {
        super(message);
    }

    public VisionServiceException(String message, Throwable cause) {
        super(message, cause);
    }
}
