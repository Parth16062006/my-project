package com.onlineauction.dao;

import com.onlineauction.util.DatabaseUtil;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;
import static com.mongodb.client.model.Filters.eq;

public class PaymentDAO {

    public String createPayment(String bidId, double amount, String method) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> payments = db.getCollection("payments");
        Document d = new Document("bid_id", new ObjectId(bidId))
                .append("amount", amount)
                .append("payment_status", "PENDING")
                .append("payment_method", method);
        payments.insertOne(d);
        ObjectId id = d.getObjectId("_id");
        return id != null ? id.toHexString() : null;
    }

    public Document findById(String idHex) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> payments = db.getCollection("payments");
        return payments.find(eq("_id", new ObjectId(idHex))).first();
    }
}
