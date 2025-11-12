package com.onlineauction.dao;

import com.onlineauction.util.DatabaseUtil;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.bson.types.ObjectId;
import java.util.ArrayList;
import java.util.List;
import static com.mongodb.client.model.Filters.eq;

public class ProductDAO {

    public static class Product {
        public String id;
        public String name;
        public String description;
        public double startPrice;
        public String sellerId;
        public String status;
    }

    public String createProduct(String name, String description, double startPrice, String sellerId) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> products = db.getCollection("products");
        Document doc = new Document("seller_id", new ObjectId(sellerId))
                .append("name", name)
                .append("description", description)
                .append("basePrice", startPrice)
                .append("currentPrice", startPrice)
                .append("status", "PENDING");
        products.insertOne(doc);
        ObjectId id = doc.getObjectId("_id");
        return id != null ? id.toHexString() : null;
    }

    public List<Document> listActiveProducts() {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> products = db.getCollection("products");
        List<Document> list = new ArrayList<>();
        products.find(eq("status", "ACTIVE")).into(list);
        return list;
    }

    public List<Document> listPendingProducts() {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> products = db.getCollection("products");
        List<Document> list = new ArrayList<>();
        products.find(eq("status", "PENDING")).into(list);
        return list;
    }

    public boolean approveProduct(String productId) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> products = db.getCollection("products");
        try {
            products.updateOne(eq("_id", new ObjectId(productId)), Updates.set("status", "ACTIVE"));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public Document findById(String idHex) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> products = db.getCollection("products");
        return products.find(eq("_id", new ObjectId(idHex))).first();
    }

    public boolean updateCurrentPrice(String productId, double newPrice) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> products = db.getCollection("products");
        try {
            products.updateOne(eq("_id", new ObjectId(productId)), Updates.set("currentPrice", newPrice));
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
