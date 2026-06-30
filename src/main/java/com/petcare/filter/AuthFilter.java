package com.petcare.filter;

import com.petcare.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String path = request.getRequestURI().substring(request.getContextPath().length());

        if (path.startsWith("/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        boolean isProtected = path.startsWith("/dashboard") || path.startsWith("/admin") || path.startsWith("/staff");

        if (isProtected) {
            HttpSession session = request.getSession(false);
            boolean loggedIn = (session != null && session.getAttribute("user") != null);

            if (!loggedIn) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            } else {
                User user = (User) session.getAttribute("user");
                if ("CUSTOMER".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
