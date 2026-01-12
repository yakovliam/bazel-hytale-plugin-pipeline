package org.myapplication.commonweb.service.jwt;

import java.util.Optional;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

public class UserClaims {

  /**
   * The user's preferred username
   */
  @Nullable
  private String preferredUsername;

  /**
   * The user's email
   */
  @Nullable
  private String email;

  /**
   * Default constructor
   */
  public UserClaims() {
  }

  /**
   * Constructor
   *
   * @param preferredUsername preferred username
   * @param email             email
   */
  public UserClaims(@NotNull String preferredUsername, @NotNull String email) {
    this.preferredUsername = preferredUsername;
    this.email = email;
  }

  public Optional<String> getPreferredUsername() {
    return Optional.ofNullable(preferredUsername);
  }

  public UserClaims setPreferredUsername(@Nullable String preferredUsername) {
    this.preferredUsername = preferredUsername;
    return this;
  }

  public Optional<String> getEmail() {
    return Optional.ofNullable(email);
  }

  public UserClaims setEmail(@Nullable String email) {
    this.email = email;
    return this;
  }
}
