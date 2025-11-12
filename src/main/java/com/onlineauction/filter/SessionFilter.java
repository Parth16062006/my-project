package com.onlineauction.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Session Filter to protect authenticated routes
 * This filter ensures that users are logged in before accessing protected resources
 */
@WebFilter(filterName = "SessionFilter", urlPatterns = {"/add-product", "/viewMyBids", "/placeBid", "/admin"})
public class SessionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Check if session exists and has userId
        if (session == null || session.getAttribute("userId") == null) {
            // Redirect to login with error message
            String contextPath = httpRequest.getContextPath();
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=auth");
            return;
        }

        // Check if session has expired (custom check)
        Long loginTime = (Long) session.getAttribute("loginTime");
        if (loginTime != null) {
            long currentTime = System.currentTimeMillis();
            long sessionAge = currentTime - loginTime;
            // 30 minutes = 30 * 60 * 1000 milliseconds
            if (sessionAge > 30 * 60 * 1000) {
                session.invalidate();
                String contextPath = httpRequest.getContextPath();
                httpResponse.sendRedirect(contextPath + "/login.jsp?error=session_expired");
                return;
            }
        }

        // Session is valid, continue with the request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}

