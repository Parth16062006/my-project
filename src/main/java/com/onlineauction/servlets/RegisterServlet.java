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

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Username and password are required");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        
        // Validate username length
        if (username.length() < 3) {
            req.setAttribute("error", "Username must be at least 3 characters long");
            req.setAttribute("username", username); // Preserve username
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        
        // Validate password length
        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters long");
            req.setAttribute("username", username); // Preserve username
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        
        // Validate role
        if (role == null || (!role.equals("user") && !role.equals("seller"))) {
            role = "user";
        }
        
        // Check if user already exists
        UserDAO.DbUser existingUser = userDAO.findByUsername(username);
        if (existingUser != null) {
            req.setAttribute("error", "Username already exists. Please choose a different username.");
            req.setAttribute("username", username); // Preserve username
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        
        try {
            // Hash password and create user
            String hash = BCrypt.withDefaults().hashToString(12, password.toCharArray());
            boolean created = userDAO.createUser(username.trim(), hash, role);
            
            if (created) {
                // Create session and auto-login user after registration
                HttpSession session = req.getSession(true);
                UserDAO.DbUser newUser = userDAO.findByUsername(username.trim());
                if (newUser != null) {
                    session.setAttribute("userId", newUser.id);
                    session.setAttribute("username", newUser.username);
                    session.setAttribute("role", newUser.role);
                    // Set session timeout to 30 minutes
                    session.setMaxInactiveInterval(30 * 60);
                    resp.sendRedirect(req.getContextPath() + "/?msg=registered");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=registered");
                }
            } else {
                req.setAttribute("error", "Registration failed. Please try again.");
                req.setAttribute("username", username); // Preserve username
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            req.setAttribute("username", username); // Preserve username
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
