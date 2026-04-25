<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Connection failed"]);
    exit;
}

$phone = $_GET['phone'] ?? '';

if (empty($phone)) {
    echo json_encode(["success" => false, "message" => "Phone is required"]);
    exit;
}

// Get user info
$stmt = $conn->prepare("SELECT * FROM users WHERE phone = ?");
$stmt->bind_param("s", $phone);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    
    // Get cart
    $cartStmt = $conn->prepare("SELECT product_id, quantity, note FROM cart WHERE phone = ?");
    $cartStmt->bind_param("s", $phone);
    $cartStmt->execute();
    $cartResult = $cartStmt->get_result();
    
    $cart = [];
    while ($cartRow = $cartResult->fetch_assoc()) {
        $cart[] = $cartRow;
    }
    $cartStmt->close();
    
    // Build user object similar to localStorage format
    $userData = [
        'fullname' => $user['fullname'],
        'phone' => $user['phone'],
        'password' => $user['password'],
        'address' => $user['address'],
        'email' => $user['email'],
        'status' => $user['status'],
        'join' => $user['join_date'],
        'cart' => $cart,
        'userType' => $user['userType']
    ];
    
    echo json_encode(["success" => true, "user" => $userData]);
} else {
    echo json_encode(["success" => false, "message" => "User not found"]);
}

$stmt->close();
$conn->close();