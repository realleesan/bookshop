<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

echo "=== chat_conversations structure ===\n";
$sql = "SHOW CREATE TABLE chat_conversations";
$result = $conn->query($sql);
$row = $result->fetch_assoc();
echo $row['Create Table'] . "\n\n";

echo "=== chat_messages structure ===\n";
$sql = "SHOW CREATE TABLE chat_messages";
$result = $conn->query($sql);
$row = $result->fetch_assoc();
echo $row['Create Table'] . "\n";

$conn->close();
