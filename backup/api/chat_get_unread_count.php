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

// Get total unread count
$sql = "SELECT SUM(unread_count) as total_unread FROM chat_conversations";
$result = $conn->query($sql);
$row = $result->fetch_assoc();

$total_unread = $row['total_unread'] ? intval($row['total_unread']) : 0;

echo json_encode(["total_unread" => $total_unread]);

$conn->close();
