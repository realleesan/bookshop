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

if ($user_id <= 0) {
    echo json_encode(["success" => false, "error" => "Invalid user_id"]);
    $conn->close();
    exit;
}

// Delete messages
$stmt = $conn->prepare("DELETE FROM chat_messages WHERE user_id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();

// Delete conversation
$stmt2 = $conn->prepare("DELETE FROM chat_conversations WHERE user_id = ?");
$stmt2->bind_param("i", $user_id);
$stmt2->execute();

echo json_encode(["success" => true]);

$stmt->close();
$stmt2->close();
$conn->close();
