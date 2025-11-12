package com.onlineauction.servlets;

import com.onlineauction.dao.BidDAO;
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

@WebServlet(name = "ViewMyBidsServlet", urlPatterns = {"/viewMyBids"})
public class ViewMyBidsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=auth");
            return;
        }
        Object uid = session.getAttribute("userId");
        BidDAO bidDAO = new BidDAO();
        List<Document> bids = bidDAO.listBidsByUser((String) uid);
        // Convert ObjectIds to strings for JSP compatibility
        List<Document> bidsWithStringIds = new ArrayList<>();
        for (Document bid : bids) {
            Document bidCopy = new Document(bid);
            ObjectId productId = bidCopy.getObjectId("product_id");
            if (productId != null) {
                bidCopy.put("product_id", productId.toString());
            }
            bidsWithStringIds.add(bidCopy);
        }
        req.setAttribute("bids", bidsWithStringIds);
        req.getRequestDispatcher("/viewMyBids.jsp").forward(req, resp);
    }
}