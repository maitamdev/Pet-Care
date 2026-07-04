package com.petcare.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class SecurityHeadersFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletResponse http = (HttpServletResponse) response;
        http.setHeader("X-Content-Type-Options", "nosniff");
        http.setHeader("X-Frame-Options", "DENY");
        http.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        http.setHeader("Permissions-Policy", "camera=(), microphone=(), geolocation=()");
        http.setHeader("Content-Security-Policy",
                "default-src 'self'; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; " +
                "font-src 'self' https://cdn.jsdelivr.net; img-src 'self' data:; " +
                "script-src 'self' 'unsafe-inline'; frame-ancestors 'none'; form-action 'self'");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
