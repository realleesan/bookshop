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

$user_id_input = isset($data['user_id']) ? $data['user_id'] : "";
$message = isset($data['message']) ? trim($data['message']) : "";
$sender_type = isset($data['sender_type']) ? $data['sender_type'] : "user";

if (empty($user_id_input) || empty($message)) {
    echo json_encode(["success" => false, "error" => "Invalid input"]);
    $conn->close();
    exit;
}

// Check if user_id_input is a phone number and find the actual user ID
$user_id = 0;
$stmt = $conn->prepare("SELECT id FROM users WHERE phone = ?");
$stmt->bind_param("s", $user_id_input);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    $user_id = $row['id'];
} else {
    // If not found by phone, try to parse as integer (might be direct ID)
    $user_id = intval($user_id_input);
}

$stmt->close();

if ($user_id <= 0) {
    echo json_encode(["success" => false, "error" => "User not found"]);
    $conn->close();
    exit;
}

// Insert message using the actual user_id
$stmt = $conn->prepare("INSERT INTO chat_messages (user_id, message, sender_type) VALUES (?, ?, ?)");
$stmt->bind_param("iss", $user_id, $message, $sender_type);

if ($stmt->execute()) {
    $message_id = $stmt->insert_id;
    
    // Update or create conversation using the actual user_id
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
