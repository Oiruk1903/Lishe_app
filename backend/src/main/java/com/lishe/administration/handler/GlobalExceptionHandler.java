package com.lishe.administration.handler;


import com.lishe.administration.exception.*;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;


@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationExceptions(MethodArgumentNotValidException ex, HttpServletRequest request) {
        List<String> errors = ex.getBindingResult()
                .getFieldErrors()
                .stream()
                .map(error -> error.getField() + ": " + error.getDefaultMessage())
                .collect(Collectors.toList());
        ErrorResponse response = new ErrorResponse(
                LocalDateTime.now(),
                HttpStatus.BAD_REQUEST.value(),
                ResponseMessages.INVALID_INPUT,
                String.join("; ", errors),
                request.getRequestURI()
        );
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ErrorResponse> handlerUserAlreadyExists(DataIntegrityViolationException ex, HttpServletRequest request) {
        ErrorResponse response = new ErrorResponse(
                LocalDateTime.now(),
                HttpStatus.CONFLICT.value(),
                ex.getLocalizedMessage(),
                ex.getMessage(),
                request.getRequestURI()
        );
        return new ResponseEntity<>(response, HttpStatus.CONFLICT);
    }

    @ExceptionHandler(UserAlreadyExistsException.class)
    public ResponseEntity<ErrorResponse> handlerUserAlreadyExists(UserAlreadyExistsException ex, HttpServletRequest request) {
        ErrorResponse response = new ErrorResponse(
                LocalDateTime.now(),
                HttpStatus.CONFLICT.value(),
                ResponseMessages.ACCOUNT_ALREADY_EXISTS,
                ex.getMessage(),
                request.getRequestURI()
        );
        return new ResponseEntity<>(response, HttpStatus.CONFLICT);
    }

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handlerUserAlreadyExists(UserNotFoundException ex, HttpServletRequest request) {
        ErrorResponse response = new ErrorResponse(
                LocalDateTime.now(),
                HttpStatus.NOT_FOUND.value(),
                ResponseMessages.USER_NOT_FOUND,
                ex.getMessage(),
                request.getRequestURI()
        );
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(NullPointerException.class)
    public ResponseEntity<ErrorResponse> handleNullPointerException(NullPointerException ex, HttpServletRequest request) {
        ErrorResponse response = new ErrorResponse(
                LocalDateTime.now(),
                HttpStatus.BAD_REQUEST.value(),
                ResponseMessages.NULL_INPUT_VALUE,
                ex.getMessage(),
                request.getRequestURI()
        );
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler({EntityNotFoundException.class})
    public ResponseEntity<ErrorResponse> handleNotFound(RuntimeException ex, HttpServletRequest request) {
        ErrorResponse response = new ErrorResponse(
                LocalDateTime.now(),
                HttpStatus.NOT_FOUND.value(),
                ResponseMessages.USER_NOT_FOUND,
                ex.getMessage(),
                request.getRequestURI()
        );
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(HandleOtpException.class)
    public ResponseEntity<ErrorResponse> handleOtpException(HandleOtpException ex, HttpServletRequest request) {
        ErrorResponse response = new ErrorResponse(
                LocalDateTime.now(),
                HttpStatus.BAD_REQUEST.value(),
                ResponseMessages.INVALID_TOKEN,
                ex.getMessage(),
                request.getRequestURI()
        );
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleIllegalArgumentException(IllegalArgumentException ex, HttpServletRequest request) {
        ErrorResponse response = new ErrorResponse(
                LocalDateTime.now(),
                HttpStatus.BAD_REQUEST.value(),
                ResponseMessages.INVALID_INPUT,
                ex.getMessage(),
                request.getRequestURI()
        );
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

}
