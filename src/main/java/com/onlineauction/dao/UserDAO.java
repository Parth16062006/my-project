package com.onlineauction.dao;

import com.onlineauction.util.DatabaseUtil;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;
import static com.mongodb.client.model.Filters.eq;

public class UserDAO {

    public static class DbUser {
        public String id;
        public String username;
        public String passwordHash;
        public String role;
    }

    public boolean createUser(String username, String passwordHash, String role) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> users = db.getCollection("users");
        Document doc = new Document("username", username)
                .append("password", passwordHash)
                .append("role", role);
        try {
            users.insertOne(doc);
            ObjectId id = doc.getObjectId("_id");
            return id != null;
        } catch (Exception e) {
            // duplicate key or other error
            return false;
        }
    }

    public DbUser findByUsername(String username) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> users = db.getCollection("users");
        Document d = users.find(eq("username", username)).first();
        if (d == null) return null;
        DbUser u = new DbUser();
        u.id = d.getObjectId("_id").toHexString();
        u.username = d.getString("username");
        u.passwordHash = d.getString("password");
        u.role = d.getString("role");
        return u;
    }

    public DbUser findById(String idHex) {
        MongoDatabase db = DatabaseUtil.getDatabase();
        MongoCollection<Document> users = db.getCollection("users");
        Document d = users.find(eq("_id", new ObjectId(idHex))).first();
        if (d == null) return null;
        DbUser u = new DbUser();
        u.id = d.getObjectId("_id").toHexString();
        u.username = d.getString("username");
        u.passwordHash = d.getString("password");
        u.role = d.getString("role");
        return u;
    }
}
