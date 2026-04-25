<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Create chat_messages table
$sql1 = 'CREATE TABLE IF NOT EXISTS chat_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    sender_type ENUM("user", "admin") NOT NULL,
    is_read TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
)';

if ($conn->query($sql1) === TRUE) {
    echo "chat_messages table created successfully<br>";
} else {
    echo "Error creating chat_messages: " . $conn->error . "<br>";
}

// Create chat_conversations table
$sql2 = 'CREATE TABLE IF NOT EXISTS chat_conversations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    last_message_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unread_count INT DEFAULT 0,
    INDEX idx_user_id (user_id),
    INDEX idx_last_message (last_message_at)
)';

if ($conn->query($sql2) === TRUE) {
    echo "chat_conversations table created successfully<br>";
} else {
    echo "Error creating chat_conversations: " . $conn->error . "<br>";
}

$conn->close();
