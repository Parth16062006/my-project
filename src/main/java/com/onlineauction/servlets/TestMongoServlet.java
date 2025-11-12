package com.onlineauction.servlets;

import com.onlineauction.util.DatabaseUtil;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "TestMongoServlet", urlPatterns = {"/test-mongo"})
public class TestMongoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> users = db.getCollection("users");
        Document d = new Document("username", "test_user")
                .append("password", "test")
                .append("role", "BUYER");
        users.insertOne(d);
        resp.setContentType("text/plain");
        resp.getWriter().println("Inserted test user with _id=" + d.getObjectId("_id"));
    }
}
