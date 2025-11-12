package com.onlineauction.servlets;

import com.onlineauction.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AddProductServlet", urlPatterns = {"/add-product"})
public class AddProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=auth");
            return;
        }
        Object role = session.getAttribute("role");
        if (role == null || !"seller".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=auth");
            return;
        }
        req.getRequestDispatcher("/add-product.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=auth");
            return;
        }
        Object role = session.getAttribute("role");
        if (role == null || !"seller".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=auth");
            return;
        }
        String sellerId = (String) session.getAttribute("userId");
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String sp = req.getParameter("start_price");
        double startPrice = 0.0;
        try {
            startPrice = Double.parseDouble(sp);
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid price");
            req.getRequestDispatcher("/add-product.jsp").forward(req, resp);
            return;
        }
        String id = productDAO.createProduct(name, description, startPrice, sellerId);
        if (id != null) {
            resp.sendRedirect(req.getContextPath() + "/?msg=product_submitted");
        } else {
            req.setAttribute("error", "Failed to add product");
            req.getRequestDispatcher("/add-product.jsp").forward(req, resp);
        }
    }
}
