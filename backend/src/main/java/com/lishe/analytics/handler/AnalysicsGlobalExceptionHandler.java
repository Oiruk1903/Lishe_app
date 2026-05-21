package com.lishe.analytics.handler;

import com.lishe.analytics.exception.ErrorResponse;
import com.lishe.analytics.exception.ResponseMessages;
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
public class AnalysicsGlobalExceptionHandler {

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
}
