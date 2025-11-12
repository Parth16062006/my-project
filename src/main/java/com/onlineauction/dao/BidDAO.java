package com.onlineauction.dao;

import com.onlineauction.util.DatabaseUtil;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Sorts;
import org.bson.Document;
import org.bson.types.ObjectId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import static com.mongodb.client.model.Filters.eq;

public class BidDAO {

    public static class Bid {
        public String id;
        public String userId;
        public String productId;
        public double amount;
        public Date createdAt;
    }

    public boolean createBid(String userId, String productId, double amount) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> bids = db.getCollection("bids");
        Document doc = new Document("bidder_id", new ObjectId(userId))
                .append("product_id", new ObjectId(productId))
                .append("bidAmount", amount)
                .append("bidTime", new Date())
                .append("is_winning", false);
        try {
            bids.insertOne(doc);
            return doc.getObjectId("_id") != null;
        } catch (Exception e) {
            return false;
        }
    }

    public double getMaxBidForProduct(String productId) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> bids = db.getCollection("bids");
        Document d = bids.find(eq("product_id", new ObjectId(productId))).sort(Sorts.descending("bidAmount")).first();
        if (d == null) return 0.0;
        Object amt = d.get("bidAmount");
        if (amt instanceof Number) return ((Number) amt).doubleValue();
        try { return Double.parseDouble(String.valueOf(amt)); } catch (Exception ex) { return 0.0; }
    }

    public List<Document> listBidsByUser(String userId) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> bids = db.getCollection("bids");
        List<Document> list = new ArrayList<>();
        bids.find(eq("bidder_id", new ObjectId(userId))).sort(Sorts.descending("bidTime")).into(list);
        return list;
    }
}
