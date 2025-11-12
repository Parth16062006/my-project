package com.onlineauction.servlets;

import com.onlineauction.dao.BidDAO;
import com.onlineauction.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "PlaceBidServlet", urlPatterns = {"/placeBid"})
public class PlaceBidServlet extends HttpServlet {

    private final BidDAO bidDAO = new BidDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=auth");
            return;
        }
        String userId = (String) session.getAttribute("userId");
        String pid = req.getParameter("product_id");
        String amt = req.getParameter("amount");
        String productId;
        double amount;
        try {
            productId = pid;
            amount = Double.parseDouble(amt);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/?error=invalid");
            return;
        }
        try {
            org.bson.Document p = productDAO.findById(productId);
            if (p == null || !"ACTIVE".equals(p.getString("status"))) {
                resp.sendRedirect(req.getContextPath() + "/?error=product_unavailable");
                return;
            }
            double max = bidDAO.getMaxBidForProduct(productId);
            double basePrice = 0.0;
            Object baseObj = p.get("basePrice");
            if (baseObj instanceof Number) basePrice = ((Number) baseObj).doubleValue();
            double minAllowed = Math.max(basePrice, max);
            if (amount <= minAllowed) {
                resp.sendRedirect(req.getContextPath() + "/?error=low_bid");
                return;
            }
            boolean ok = bidDAO.createBid(userId, productId, amount);
            if (ok) {
                // Update product's current price to the new bid amount
                productDAO.updateCurrentPrice(productId, amount);
                resp.sendRedirect(req.getContextPath() + "/browse");
            } else {
                resp.sendRedirect(req.getContextPath() + "/?error=bid_failed");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
