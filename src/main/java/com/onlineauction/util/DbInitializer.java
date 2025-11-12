package com.onlineauction.util;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.IndexOptions;
import org.bson.Document;

public class DbInitializer {

    public static void main(String[] args) {
        System.out.println("Starting DB initialization using MongoDB Java driver...");
        MongoDatabase db = DatabaseUtil.getDatabase();

        // Users collection and indexes
        if (!collectionExists(db, "users")) {
            db.createCollection("users");
            System.out.println("Created collection: users");
        }
        MongoCollection<Document> users = db.getCollection("users");
        users.createIndex(new Document("username", 1), new IndexOptions().unique(true));
        users.createIndex(new Document("email", 1), new IndexOptions().unique(true));
        System.out.println("Ensured indexes on users: username(unique), email(unique)");

        // Products collection and indexes
        if (!collectionExists(db, "products")) {
            db.createCollection("products");
            System.out.println("Created collection: products");
        }
        MongoCollection<Document> products = db.getCollection("products");
        products.createIndex(new Document("seller_id", 1));
        products.createIndex(new Document("status", 1));
        products.createIndex(new Document("end_time", 1));
        products.createIndex(new Document("category", 1));
        System.out.println("Ensured indexes on products");

        // Bids collection and indexes
        if (!collectionExists(db, "bids")) {
            db.createCollection("bids");
            System.out.println("Created collection: bids");
        }
        MongoCollection<Document> bids = db.getCollection("bids");
        bids.createIndex(new Document("product_id", 1).append("bid_time", -1));
        bids.createIndex(new Document("bidder_id", 1));
        bids.createIndex(new Document("is_winning", 1));
        System.out.println("Ensured indexes on bids");

        // Payments collection and indexes
        if (!collectionExists(db, "payments")) {
            db.createCollection("payments");
            System.out.println("Created collection: payments");
        }
        MongoCollection<Document> payments = db.getCollection("payments");
        payments.createIndex(new Document("bid_id", 1));
        payments.createIndex(new Document("payment_status", 1));
        payments.createIndex(new Document("transaction_id", 1));
        System.out.println("Ensured indexes on payments");

        // Notifications collection and indexes
        if (!collectionExists(db, "notifications")) {
            db.createCollection("notifications");
            System.out.println("Created collection: notifications");
        }
        MongoCollection<Document> notifications = db.getCollection("notifications");
        notifications.createIndex(new Document("user_id", 1));
        notifications.createIndex(new Document("type", 1));
        notifications.createIndex(new Document("is_read", 1));
        System.out.println("Ensured indexes on notifications");

        System.out.println("DB initialization complete.");
        DatabaseUtil.closeConnection();
    }

    private static boolean collectionExists(MongoDatabase db, String name) {
        for (String colName : db.listCollectionNames()) {
            if (colName.equals(name)) return true;
        }
        return false;
    }
}
