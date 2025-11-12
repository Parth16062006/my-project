package com.onlineauction.util;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class DatabaseUtil {
    private static final Properties properties = new Properties();
    private static MongoClient mongoClient;
    private static MongoDatabase database;
    
    static {
        try (InputStream input = DatabaseUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                throw new RuntimeException("db.properties file not found in classpath");
            }
            properties.load(input);
            initializeMongoClient();
        } catch (IOException e) {
            throw new RuntimeException("Failed to load database properties", e);
        }
    }
    
    private static void initializeMongoClient() {
        String connectionString = properties.getProperty("mongodb.uri");
        String databaseName = properties.getProperty("mongodb.database");
        
        if (connectionString == null || connectionString.trim().isEmpty()) {
            throw new RuntimeException("MongoDB connection string (mongodb.uri) is not configured in db.properties");
        }
        
        if (databaseName == null || databaseName.trim().isEmpty()) {
            throw new RuntimeException("MongoDB database name (mongodb.database) is not configured in db.properties");
        }
        
        try {
            // Create MongoDB client - mongodb+srv:// is automatically supported
            mongoClient = MongoClients.create(connectionString);
            
            // Get database instance
            database = mongoClient.getDatabase(databaseName);
            
            // Test connection by listing database names (optional, but helps verify connection)
            System.out.println("Successfully connected to MongoDB Atlas");
            System.out.println("Database: " + databaseName);
        } catch (Exception e) {
            throw new RuntimeException("Failed to connect to MongoDB: " + e.getMessage(), e);
        }
    }
    
    public static MongoDatabase getDatabase() {
        if (database == null) {
            throw new RuntimeException("Database connection not initialized");
        }
        return database;
    }
    
    public static MongoClient getMongoClient() {
        if (mongoClient == null) {
            throw new RuntimeException("MongoDB client not initialized");
        }
        return mongoClient;
    }
    
    public static void closeConnection() {
        if (mongoClient != null) {
            try {
                mongoClient.close();
                System.out.println("MongoDB connection closed");
            } catch (Exception e) {
                System.err.println("Error closing MongoDB connection: " + e.getMessage());
            }
        }
    }
}