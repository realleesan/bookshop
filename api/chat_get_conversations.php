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

// Get all conversations with user info
$sql = "SELECT c.*, u.fullname, u.email, u.phone 
        FROM chat_conversations c 
        LEFT JOIN users u ON c.user_id = u.id 
        ORDER BY c.last_message_at DESC";
$result = $conn->query($sql);

$conversations = [];
while ($row = $result->fetch_assoc()) {
    // Get last message preview
    $msg_sql = "SELECT message FROM chat_messages WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";
    $msg_stmt = $conn->prepare($msg_sql);
    $msg_stmt->bind_param("i", $row['user_id']);
    $msg_stmt->execute();
    $msg_result = $msg_stmt->get_result();
    if ($msg_row = $msg_result->fetch_assoc()) {
        $row['last_message'] = $msg_row['message'];
    }
    $msg_stmt->close();
    
    $conversations[] = $row;
}

echo json_encode($conversations);

$conn->close();
