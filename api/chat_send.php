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

$data = json_decode(file_get_contents("php://input"), true);

$user_id = isset($data['user_id']) ? intval($data['user_id']) : 0;
$message = isset($data['message']) ? trim($data['message']) : "";
$sender_type = isset($data['sender_type']) ? $data['sender_type'] : "user";

if ($user_id <= 0 || empty($message)) {
    echo json_encode(["success" => false, "error" => "Invalid input"]);
    $conn->close();
    exit;
}

// Insert message
$stmt = $conn->prepare("INSERT INTO chat_messages (user_id, message, sender_type) VALUES (?, ?, ?)");
$stmt->bind_param("iss", $user_id, $message, $sender_type);

if ($stmt->execute()) {
    $message_id = $stmt->insert_id;
    
    // Update or create conversation
    $conv_stmt = $conn->prepare("INSERT INTO chat_conversations (user_id, last_message_at, unread_count) 
                                  VALUES (?, NOW(), 0)
                                  ON DUPLICATE KEY UPDATE last_message_at = NOW()");
    $conv_stmt->bind_param("i", $user_id);
    $conv_stmt->execute();
    
    // If message from user, increment unread count for admin
    if ($sender_type === 'user') {
        $update_unread = $conn->prepare("UPDATE chat_conversations SET unread_count = unread_count + 1 WHERE user_id = ?");
        $update_unread->bind_param("i", $user_id);
        $update_unread->execute();
    }
    
    echo json_encode(["success" => true, "message_id" => $message_id]);
} else {
    echo json_encode(["success" => false, "error" => $stmt->error]);
}

$stmt->close();
$conn->close();
