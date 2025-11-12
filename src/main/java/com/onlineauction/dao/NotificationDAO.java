package com.onlineauction.dao;

import com.onlineauction.util.DatabaseUtil;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;
import static com.mongodb.client.model.Filters.eq;

public class NotificationDAO {

    public String createNotification(String userId, String message, String type) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> noti = db.getCollection("notifications");
        Document d = new Document("user_id", new ObjectId(userId))
                .append("message", message)
                .append("type", type)
                .append("is_read", false);
        noti.insertOne(d);
        ObjectId id = d.getObjectId("_id");
        return id != null ? id.toHexString() : null;
    }

    public Document findById(String idHex) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> noti = db.getCollection("notifications");
        return noti.find(eq("_id", new ObjectId(idHex))).first();
    }
}
