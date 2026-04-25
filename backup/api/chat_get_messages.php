<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$user_id_input = isset($_GET['user_id']) ? $_GET['user_id'] : "";

// Convert user_id_input to actual user ID if it's a phone number
$user_id = 0;

if (!empty($user_id_input)) {
    // Check if it's a phone number and find actual ID
    $stmt = $conn->prepare("SELECT id FROM users WHERE phone = ?");
    $stmt->bind_param("s", $user_id_input);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($row = $result->fetch_assoc()) {
        $user_id = $row['id'];
    } else {
        // Try as direct integer
        $user_id = intval($user_id_input);
    }
    $stmt->close();
}

if ($user_id <= 0) {
    echo json_encode(["error" => "Invalid user_id"]);
    $conn->close();
    exit;
}

// Check if conversation exists
$check_sql = "SELECT id FROM chat_conversations WHERE user_id = ?";
$check_stmt = $conn->prepare($check_sql);
$check_stmt->bind_param("i", $user_id);
$check_stmt->execute();
$check_result = $check_stmt->get_result();

if ($check_result->num_rows === 0) {
    // No conversation exists, return empty
    echo json_encode([]);
    $check_stmt->close();
    $conn->close();
    exit;
}

$check_stmt->close();

// Get messages for this user
$sql = "SELECT * FROM chat_messages WHERE user_id = ? ORDER BY created_at ASC";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$messages = [];
while ($row = $result->fetch_assoc()) {
    $messages[] = $row;
}

// Mark messages as read
$update_sql = "UPDATE chat_messages SET is_read = 1 WHERE user_id = ? AND sender_type = 'user' AND is_read = 0";
$update_stmt = $conn->prepare($update_sql);
$update_stmt->bind_param("i", $user_id);
$update_stmt->execute();

// Reset unread count for conversation
$reset_unread = $conn->prepare("UPDATE chat_conversations SET unread_count = 0 WHERE user_id = ?");
$reset_unread->bind_param("i", $user_id);
$reset_unread->execute();

echo json_encode($messages);

$stmt->close();
$conn->close();
