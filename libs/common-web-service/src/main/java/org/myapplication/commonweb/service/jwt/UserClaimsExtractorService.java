package org.myapplication.commonweb.service.jwt;

import java.util.Map;

import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;

/**
 * User claims extractor service
 *
 * <p>
 * A service responsible for extracting user claims from a JWT.
 * </p>
 */
@Service
public class UserClaimsExtractorService {

  private static final String PREFERRED_USERNAME_CLAIM = "preferred_username";
  private static final String EMAIL_CLAIM = "email";

  /**
   * Extract user claims from a JWT
   *
   * @param jwt the JWT
   * @return the user claims
   */
  public UserClaims extractClaims(Jwt jwt) {
    Map<String, Object> claims = jwt.getClaims();

    String preferredUsername = (String) claims.get(PREFERRED_USERNAME_CLAIM);
    String email = (String) claims.get(EMAIL_CLAIM);

    UserClaims userClaims = new UserClaims();

    userClaims.setPreferredUsername(preferredUsername);
    userClaims.setEmail(email);

    return userClaims;
  }
}
