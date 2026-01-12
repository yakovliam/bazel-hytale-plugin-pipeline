package org.myapplication.commonweb.service.jwt;

import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;

/**
 * User context service
 *
 * <p>
 * A service responsible for resolving the user from the JWT.
 * </p>
 */
@Service
public class UserContextService {

  private static final Logger LOGGER = org.slf4j.LoggerFactory.getLogger(UserContextService.class);

  private final UserCreatorService userCreatorService;

  @Autowired
  public UserContextService(UserCreatorService userCreatorService) {
    this.userCreatorService = userCreatorService;
  }

  /**
   * Resolve the user from the JWT
   *
   * @param jwt the JWT
   * @return the user
   */
  @Cacheable("users")
  public User resolveUser(Jwt jwt) {
    if (jwt == null) {
      LOGGER.error("jwt is null");
      return null;
    }

    return userCreatorService.createUser(jwt);
  }
}
