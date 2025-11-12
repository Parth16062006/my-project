package com.onlineauction.servlets;

import com.onlineauction.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.bson.Document;
import org.bson.types.ObjectId;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=auth");
            return;
        }
        Object role = session.getAttribute("role");
        if (role == null || !"admin".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=auth");
            return;
        }
        ProductDAO productDAO = new ProductDAO();
        List<Document> products = productDAO.listPendingProducts();
        // Convert ObjectIds to strings for JSP compatibility
        List<Document> productsWithStringIds = new ArrayList<>();
        for (Document product : products) {
            Document productCopy = new Document(product);
            ObjectId id = productCopy.getObjectId("_id");
            if (id != null) {
                productCopy.put("_id", id.toString());
            }
            ObjectId sellerId = productCopy.getObjectId("seller_id");
            if (sellerId != null) {
                productCopy.put("seller_id", sellerId.toString());
            }
            productsWithStringIds.add(productCopy);
        }
        req.setAttribute("products", productsWithStringIds);
        req.getRequestDispatcher("/admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=auth");
            return;
        }
        Object role = session.getAttribute("role");
        if (role == null || !"admin".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=auth");
            return;
        }
        String action = req.getParameter("action");
        String id = req.getParameter("id");
        if (!"approve".equals(action) || id == null) {
            resp.sendRedirect(req.getContextPath() + "/admin?error=invalid");
            return;
        }
        try {
            if (new ProductDAO().approveProduct(id)) {
                resp.sendRedirect(req.getContextPath() + "/admin?msg=approved");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin?error=failed");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin?error=invalid");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}