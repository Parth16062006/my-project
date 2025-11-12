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

@WebServlet(name = "BrowseServlet", urlPatterns = {"/browse"})
public class BrowseServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Document> products = productDAO.listActiveProducts();
            // Convert ObjectIds to strings for JSP compatibility
            List<Document> productsWithStringIds = new ArrayList<>();
            if (products != null) {
                for (Document product : products) {
                    Document productCopy = new Document(product);
                    ObjectId id = productCopy.getObjectId("_id");
                    if (id != null) {
                        productCopy.put("_id", id.toString());
                    }
                    productsWithStringIds.add(productCopy);
                }
            }
            req.setAttribute("products", productsWithStringIds);
            req.getRequestDispatcher("/browse.jsp").forward(req, resp);
        } catch (Exception e) {
            // Log error and show empty products list
            System.err.println("Error loading products: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Unable to load products. Please try again later.");
            req.setAttribute("products", new ArrayList<Document>());
            req.getRequestDispatcher("/browse.jsp").forward(req, resp);
        }
    }
}