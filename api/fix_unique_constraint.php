<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// First, delete duplicates keeping only the one with highest ID
echo "=== Step 1: Deleting duplicate conversations ===\n";
$sql = "DELETE FROM chat_conversations 
        WHERE id NOT IN (
            SELECT MAX(id) FROM chat_conversations GROUP BY user_id
        )";
if ($conn->query($sql)) {
    echo "Deleted duplicates. Affected rows: " . $conn->affected_rows . "\n";
} else {
    echo "Error: " . $conn->error . "\n";
}

// Now add unique constraint
echo "\n=== Step 2: Adding unique constraint ===\n";
$sql = "ALTER TABLE chat_conversations ADD UNIQUE INDEX unique_user_id (user_id)";
if ($conn->query($sql) === TRUE) {
    echo "Added unique constraint successfully\n";
} else {
    echo "Error: " . $conn->error . "\n";
}

// Verify the structure
echo "\n=== Step 3: Verifying table structure ===\n";
$sql = "SHOW CREATE TABLE chat_conversations";
$result = $conn->query($sql);
$row = $result->fetch_assoc();
echo $row['Create Table'] . "\n";

$conn->close();
