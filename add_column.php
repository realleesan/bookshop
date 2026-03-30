<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$conn->set_charset("utf8");

// Add user_fullname column if it doesn't exist
$result = $conn->query("ALTER TABLE ratings ADD user_fullname VARCHAR(255) DEFAULT ''");

if ($result) {
    echo "Column added successfully!";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>