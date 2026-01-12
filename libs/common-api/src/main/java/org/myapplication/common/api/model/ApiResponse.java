package org.myapplication.common.api.model;

import org.jetbrains.annotations.Nullable;

public class ApiResponse<T> {

  /**
   * The data returned from the request
   */
  @Nullable
  private final T data;
  /**
   * The error returned from the request
   */
  @Nullable
  private final ApiError error;
  /**
   * Indicates if the request was successful
   */
  private final boolean success;

  public ApiResponse(boolean success, @Nullable T data, @Nullable ApiError error) {
    this.success = success;
    this.data = data;
    this.error = error;
  }

  public static <T> ApiResponse<T> success(@Nullable T data) {
    return new ApiResponse<>(true, data, null);
  }

  public static <T> ApiResponse<T> successNoData() {
    return new ApiResponse<>(true, null, null);
  }

  public static <T> ApiResponse<T> error(ApiError error) {
    return new ApiResponse<>(false, null, error);
  }

  public boolean isSuccess() {
    return success;
  }

  @Nullable
  public T getData() {
    return data;
  }

  @Nullable
  public ApiError getError() {
    return error;
  }
}
