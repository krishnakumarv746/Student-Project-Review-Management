-- ===================================================
-- StudentReviewApp - Full Database Setup
-- Run this entire script in MySQL
-- ===================================================

-- Step 1: Drop and recreate database (⚠ WARNING: This deletes all existing data)
DROP DATABASE IF EXISTS student_review_db;
CREATE DATABASE student_review_db;
USE student_review_db;

-- ===================================================
-- Step 2: USERS table
-- ===================================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('STUDENT','TRAINER','ADMIN') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===================================================
-- Step 3: PROJECTS table (with deadline + file)
-- ===================================================
CREATE TABLE projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    student_id INT,
    trainer_id INT,
    status ENUM('ASSIGNED','UNDER_REVIEW','COMPLETED','REJECTED') DEFAULT 'ASSIGNED',
    feedback TEXT,
    grade VARCHAR(10),
    student_reply TEXT,
    due_date DATE DEFAULT NULL,
    project_file VARCHAR(500) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (trainer_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===================================================
-- Step 4: NOTIFICATIONS table
-- ===================================================
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT,
    is_read TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ===================================================
-- Step 5: Default ADMIN account
-- Username: admin
-- Password: admin123
-- ===================================================
INSERT INTO users (username, password, role) VALUES 
('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN');

-- ===================================================
-- Step 6: Verify
-- ===================================================
SELECT '✅ Database setup complete!' AS message;
SELECT 'Users table:' AS info;
DESCRIBE users;
SELECT 'Projects table:' AS info;
DESCRIBE projects;
SELECT 'Notifications table:' AS info;
DESCRIBE notifications;
SELECT 'Default admin account:' AS info;
SELECT id, username, role FROM users;