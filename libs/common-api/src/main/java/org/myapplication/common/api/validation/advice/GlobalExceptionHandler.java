package org.myapplication.common.api.validation.advice;

import jakarta.persistence.EntityNotFoundException;
import java.util.Objects;
import org.myapplication.common.api.model.ApiError;
import org.myapplication.common.api.model.ApiResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

  private static final Logger LOGGER = LoggerFactory.getLogger(GlobalExceptionHandler.class);

  @ExceptionHandler(BadCredentialsException.class)
  public ResponseEntity<ApiResponse<?>> handleBadCredentials(BadCredentialsException e) {
    ApiError error = ApiError.unauthorized("Invalid credentials");
    return ResponseEntity.status(error.getStatus()).body(ApiResponse.error(error));
  }

  @ExceptionHandler(IllegalArgumentException.class)
  public ResponseEntity<ApiResponse<Void>> handleIllegalArgument(IllegalArgumentException e) {
    ApiError error = ApiError.validation("Invalid request", e.getMessage());
    return ResponseEntity.status(error.getStatus()).body(ApiResponse.error(error));
  }

  @ExceptionHandler(EntityNotFoundException.class)
  public ResponseEntity<ApiResponse<Void>> handleEntityNotFound(EntityNotFoundException e) {
    ApiError error = ApiError.notFound("Resource not found");
    return ResponseEntity.status(error.getStatus()).body(ApiResponse.error(error));
  }

  @ExceptionHandler(HttpMessageNotReadableException.class)
  public ResponseEntity<ApiResponse<Void>> handleHttpMessageNotReadable(
      HttpMessageNotReadableException e) {
    ApiError error = ApiError.validation("Invalid request", e.getMessage());
    return ResponseEntity.status(error.getStatus()).body(ApiResponse.error(error));
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<ApiResponse<Void>> handleValidationExceptions(
      MethodArgumentNotValidException ex) {
    String errorMessage =
        ex.getBindingResult().getFieldErrors().stream().map(FieldError::getDefaultMessage)
            .filter(Objects::nonNull).findFirst().orElse("Validation failed");

    ApiError error = ApiError.validation("Validation failed", errorMessage);

    return ResponseEntity.status(error.getStatus()).body(ApiResponse.error(error));
  }

  /**
   * Fallback exception handler
   * <p>
   * TODO: Implement all missing exception handlers
   */
  @ExceptionHandler(Exception.class)
  public ResponseEntity<ApiResponse<Void>> handleException(Exception e) {
    // log properly in production
    LOGGER.error("Internal server error", e);
    String message = e.getMessage();
    ApiError error = ApiError.server("Internal server error: " + message);
    return ResponseEntity.status(error.getStatus()).body(ApiResponse.error(error));
  }
}
