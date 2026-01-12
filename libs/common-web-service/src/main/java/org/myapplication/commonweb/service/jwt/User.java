package org.myapplication.commonweb.service.jwt;

import java.util.UUID;
import org.jetbrains.annotations.NotNull;
import org.springframework.security.oauth2.jwt.Jwt;

public class User {

  /**
   * The user ID
   *
   * <p>
   * Equivalent to the JWT subject
   * </p>
   */
  @NotNull
  private UUID id;

  /**
   * The user claims
   */
  @NotNull
  private UserClaims claims;

  /**
   * The JWT
   *
   * <p>
   * The JWT is just provided for reference. It's the jwt used to resolve this user object.
   * It's just here in case it's needed for some reason.
   * </p>
   */
  @NotNull
  private Jwt jwt;

  /**
   * Constructor
   *
   * @param id     the user ID
   * @param claims the user claims
   * @param jwt    the JWT
   */
  public User(@NotNull UUID id, @NotNull UserClaims claims, @NotNull Jwt jwt) {
    this.id = id;
    this.claims = claims;
    this.jwt = jwt;
  }

  public UUID getId() {
    return id;
  }

  public User setId(UUID id) {
    this.id = id;
    return this;
  }

  public UserClaims getClaims() {
    return claims;
  }

  public User setClaims(UserClaims claims) {
    this.claims = claims;
    return this;
  }

  public Jwt getJwt() {
    return jwt;
  }

  public User setJwt(Jwt jwt) {
    this.jwt = jwt;
    return this;
  }
}
