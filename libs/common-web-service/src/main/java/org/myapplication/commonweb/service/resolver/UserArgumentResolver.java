package org.myapplication.commonweb.service.resolver;

import org.jetbrains.annotations.NotNull;
import org.myapplication.commonweb.service.jwt.User;
import org.myapplication.commonweb.service.jwt.UserContextService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.MethodParameter;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

@Component
public class UserArgumentResolver implements HandlerMethodArgumentResolver {

  private static final Logger LOGGER = LoggerFactory.getLogger(UserArgumentResolver.class);
  private final UserContextService userContextService;

  @Autowired
  public UserArgumentResolver(UserContextService userContextService) {
    this.userContextService = userContextService;
  }

  @Override
  public boolean supportsParameter(MethodParameter parameter) {
    return parameter.getParameterType().equals(User.class);
  }

  @Override
  public Object resolveArgument(@NotNull MethodParameter parameter,
                                ModelAndViewContainer mavContainer, NativeWebRequest webRequest,
                                WebDataBinderFactory binderFactory) {
    LOGGER.info("Resolving user argument");
    // resolve user once from model or security context
    User cachedUser =
        (User) webRequest.getAttribute("currentUser", RequestAttributes.SCOPE_REQUEST);

    if (cachedUser != null) {
      return cachedUser;
    }

    User currentUser = resolveCurrentUser();

    if (currentUser == null) {
      throw new BadCredentialsException("No current user found");
    }

    webRequest.setAttribute("currentUser", currentUser, RequestAttributes.SCOPE_REQUEST);

    return currentUser;
  }

  /**
   * Resolves the current user from the security context via the {@link UserContextService}
   *
   * @return the current user
   */
  private User resolveCurrentUser() {
    Jwt jwtUser = (Jwt) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

    if (jwtUser == null) {
      return null;
    }

    return userContextService.resolveUser(jwtUser);
  }
}
