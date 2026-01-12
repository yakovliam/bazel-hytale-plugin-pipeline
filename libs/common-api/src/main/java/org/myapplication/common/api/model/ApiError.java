package org.myapplication.common.api.model;

import java.util.Collections;
import java.util.Map;
import org.springframework.http.HttpStatus;

public class ApiError {

  /**
   * The error code
   */
  private final String code;

  /**
   * The error message
   */
  private final String message;

  /**
   * The HTTP status code
   */
  private final HttpStatus status;

  /**
   * Optional additional data
   */
  private final Map<String, Object> details;

  public ApiError(String code, String message, HttpStatus status, Map<String, Object> details) {
    this.code = code;
    this.message = message;
    this.status = status;
    this.details = details == null ? Collections.emptyMap() : Map.copyOf(details);
  }

  public ApiError(String code, String message, HttpStatus status) {
    this(code, message, status, null);
  }

  public static ApiError client(String message) {
    return new ApiError("CLIENT_ERROR", message, HttpStatus.BAD_REQUEST);
  }

  public static ApiError validation(String field, String message) {
    Map<String, Object> details = Map.of("field", field);
    return new ApiError("VALIDATION_ERROR", message, HttpStatus.UNPROCESSABLE_ENTITY, details);
  }

  public static ApiError notFound(String resource) {
    String msg = resource + " not found";
    return new ApiError("NOT_FOUND", msg, HttpStatus.NOT_FOUND);
  }

  public static ApiError server(String message) {
    return new ApiError("SERVER_ERROR", message, HttpStatus.INTERNAL_SERVER_ERROR);
  }

  public static ApiError network(String message) {
    return new ApiError("NETWORK_ERROR", message, HttpStatus.GATEWAY_TIMEOUT);
  }

  public static ApiError external(String code, String message, int httpStatus) {
    return new ApiError(code, message, HttpStatus.valueOf(httpStatus));
  }

  public static ApiError unauthorized(String message) {
    return new ApiError("UNAUTHORIZED", message, HttpStatus.UNAUTHORIZED);
  }

  public String getCode() {
    return code;
  }

  public String getMessage() {
    return message;
  }

  public HttpStatus getStatus() {
    return status;
  }

  public Map<String, Object> getDetails() {
    return details;
  }

  @Override
  public String toString() {
    return "ApiError{" + "code='" + code + '\'' + ", message='" + message + '\'' + ", status=" +
        status + ", details=" + details + '}';
  }
}
