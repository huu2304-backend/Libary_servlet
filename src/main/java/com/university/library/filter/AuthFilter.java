package com.university.library.filter;

import com.university.library.model.User;
import com.university.library.utils.AppConstants;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/home"}, dispatcherTypes = {DispatcherType.REQUEST})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute(AppConstants.SESSION_USER) : null;
        String path = req.getServletPath();
        if (user == null) {
            res.sendRedirect(req.getContextPath() + AppConstants.URL_LOGIN);
            return;
        }

        if (path.startsWith("/admin")) {
            if (AppConstants.ROLE_ADMIN.equals(user.getRole())) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(req.getContextPath() + AppConstants.URL_HOME);
            }
        } else {
            chain.doFilter(request, response);
        }
    }
}