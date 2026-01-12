package org.myapplication.common.api.model;

public class Result<T, E> {

  /**
   * The success data
   */
  private final T success;

  /**
   * The error
   */
  private final E error;

  /**
   * Whether the result is successful
   */
  private final boolean isSuccess;

  public Result(T success, E error, boolean isSuccess) {
    this.success = success;
    this.error = error;
    this.isSuccess = isSuccess;
  }

  public static <T, E> Result<T, E> ok(T success) {
    return new Result<>(success, null, true);
  }

  public static <T, E> Result<T, E> err(E error) {
    return new Result<>(null, error, false);
  }

  public T getSuccess() {
    return success;
  }

  public E getError() {
    return error;
  }

  public boolean isSuccess() {
    return isSuccess;
  }

  public boolean isError() {
    return !isSuccess;
  }

  public Result<Void, E> mapToVoid() {
    return new Result<>(null, error, isSuccess);
  }
}
