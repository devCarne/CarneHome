package stu.kms.carnehome.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        List<String> roleNames = new ArrayList<>();
        authentication.getAuthorities().forEach(auth -> {
            roleNames.add(auth.getAuthority());
        });

        if (roleNames.contains("ROLE_SUPER")) {

        }

        if (roleNames.contains("ROLE_NORMAL")) {

        }

        response.sendRedirect("/");
    }
}
