// MongoDB Schema and Indexes

// Users Collection
db.createCollection("users");
db.users.createIndex({ "username": 1 }, { unique: true });
db.users.createIndex({ "email": 1 }, { unique: true });

// Products Collection
db.createCollection("products");
db.products.createIndex({ "seller_id": 1 });
db.products.createIndex({ "status": 1 });
db.products.createIndex({ "end_time": 1 });
db.products.createIndex({ "category": 1 });

// Bids Collection
db.createCollection("bids");
db.bids.createIndex({ "product_id": 1, "bid_time": -1 });
db.bids.createIndex({ "bidder_id": 1 });
db.bids.createIndex({ "is_winning": 1 });

// Payments Collection
db.createCollection("payments");
db.payments.createIndex({ "bid_id": 1 });
db.payments.createIndex({ "payment_status": 1 });
db.payments.createIndex({ "transaction_id": 1 });

// Notifications Collection
db.createCollection("notifications");
db.notifications.createIndex({ "user_id": 1 });
db.notifications.createIndex({ "type": 1 });
db.notifications.createIndex({ "is_read": 1 });

// Sample Document Schemas

/*
User Document Schema:
{
  "_id": ObjectId,
  "username": String,
  "email": String,
  "password": String,
  "role": String, // "BUYER", "SELLER", "ADMIN"
  "firstName": String,
  "lastName": String,
  "phone": String,
  "address": String,
  "createdAt": ISODate,
  "isActive": Boolean
}

Product Document Schema:
{
  "_id": ObjectId,
  "seller_id": ObjectId,
  "name": String,
  "description": String,
  "category": String,
  "basePrice": Decimal128,
  "currentPrice": Decimal128,
  "imagePath": String,
  "startTime": ISODate,
  "endTime": ISODate,
  "status": String, // "PENDING", "ACTIVE", "CLOSED", "CANCELLED"
  "minimumIncrement": Decimal128,
  "createdAt": ISODate
}

Bid Document Schema:
{
  "_id": ObjectId,
  "product_id": ObjectId,
  "bidder_id": ObjectId,
  "bidAmount": Decimal128,
  "bidTime": ISODate,
  "isWinning": Boolean
}

Payment Document Schema:
{
  "_id": ObjectId,
  "bid_id": ObjectId,
  "amount": Decimal128,
  "paymentStatus": String, // "PENDING", "COMPLETED", "FAILED"
  "paymentMethod": String,
  "transactionId": String,
  "paymentDate": ISODate
}

Notification Document Schema:
{
  "_id": ObjectId,
  "user_id": ObjectId,
  "message": String,
  "type": String, // "BID", "WIN", "PAYMENT", "SYSTEM"
  "isRead": Boolean,
  "createdAt": ISODate
}
*/