<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

echo "=== Chat Conversations ===\n";
$sql = "SELECT * FROM chat_conversations ORDER BY id";
$result = $conn->query($sql);
while ($row = $result->fetch_assoc()) {
    echo "ID: " . $row['id'] . " | UserID: " . $row['user_id'] . " | Last: " . $row['last_message_at'] . "\n";
}

echo "\n=== Deleting duplicates (keeping highest ID for each user_id) ===\n";

// Delete duplicates, keeping only the one with highest ID
$sql = "DELETE FROM chat_conversations 
        WHERE id NOT IN (
            SELECT MAX(id) FROM chat_conversations GROUP BY user_id
        )";
if ($conn->query($sql)) {
    echo "Deleted duplicates. Affected rows: " . $conn->affected_rows . "\n";
}

echo "\n=== After cleanup ===\n";
$sql = "SELECT * FROM chat_conversations ORDER BY id";
$result = $conn->query($sql);
while ($row = $result->fetch_assoc()) {
    echo "ID: " . $row['id'] . " | UserID: " . $row['user_id'] . " | Last: " . $row['last_message_at'] . "\n";
}

$conn->close();
