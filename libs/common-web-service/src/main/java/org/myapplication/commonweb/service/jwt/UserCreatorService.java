package org.myapplication.commonweb.service.jwt;

import java.util.UUID;

import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;

/**
 * User creator service
 *
 * <p>
 * A service responsible for creating a user from a JWT.
 * </p>
 */
@Service
public class UserCreatorService {

  private static final Logger LOGGER = org.slf4j.LoggerFactory.getLogger(UserCreatorService.class);

  private final UserClaimsExtractorService claimsExtractorService;

  @Autowired
  public UserCreatorService(UserClaimsExtractorService claimsExtractorService) {
    this.claimsExtractorService = claimsExtractorService;
  }

  /**
   * Create a user from a JWT
   *
   * @param jwt the JWT
   * @return the user
   */
  public User createUser(Jwt jwt) {
    UserClaims claims = claimsExtractorService.extractClaims(jwt);

    String subject = jwt.getSubject();

    if (subject == null || subject.isEmpty()) {
      LOGGER.error("subject is null or empty");
      return null;
    }

    if (claims == null) {
      LOGGER.error("claims is null");
      return null;
    }

    UUID subjectUuid = null;
    try {
      subjectUuid = UUID.fromString(subject);
    } catch (IllegalArgumentException e) {
      LOGGER.error("subject is not a valid UUID");
      return null;
    }

    return new User(subjectUuid, claims, jwt);
  }
}
