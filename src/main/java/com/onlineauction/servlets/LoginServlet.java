package com.onlineauction.servlets;

import at.favre.lib.crypto.bcrypt.BCrypt;
import com.onlineauction.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        
        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=missing");
            return;
        }
        
        try {
            UserDAO.DbUser user = userDAO.findByUsername(username.trim());
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
                return;
            }
            
            BCrypt.Result result = BCrypt.verifyer().verify(password.toCharArray(), user.passwordHash);
            if (result.verified) {
                // Invalidate any existing session to prevent session fixation
                HttpSession oldSession = req.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }
                
                // Create new session
                HttpSession session = req.getSession(true);
                session.setAttribute("userId", user.id);
                session.setAttribute("username", user.username);
                session.setAttribute("role", user.role);
                
                // Set session timeout to 30 minutes
                session.setMaxInactiveInterval(30 * 60);
                
                // Prevent session fixation
                session.setAttribute("loginTime", System.currentTimeMillis());
                
                resp.sendRedirect(req.getContextPath() + "/");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
        }
    }
}
