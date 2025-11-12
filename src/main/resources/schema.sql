-- MySQL schema for Online Auction System
-- Run this in your MySQL server (after creating database 'online_auction_db')

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('user','seller','admin') NOT NULL DEFAULT 'user'
);

CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  start_price DECIMAL(12,2) NOT NULL,
  seller_id INT NOT NULL,
  status ENUM('pending','active') NOT NULL DEFAULT 'pending',
  FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS bids (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Sample admin creation: replace '<bcrypt_hash>' with a bcrypt-hashed password
-- INSERT INTO users (username, password, role) VALUES ('admin','<bcrypt_hash>', 'admin');
