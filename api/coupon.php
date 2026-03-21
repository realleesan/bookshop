<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST, GET');
header('Access-Control-Allow-Headers: Content-Type');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Connection failed"]);
    exit;
}

// Create coupons table if not exists
$sql = "CREATE TABLE IF NOT EXISTS `coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(6) NOT NULL,
  `discount_percent` int(11) NOT NULL DEFAULT 10,
  `email` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
$conn->query($sql);

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $action = $_POST['action'] ?? '';
    
    if ($action === 'create') {
        // Create new coupon
        $email = $_POST['email'] ?? '';
        
        if (empty($email)) {
            echo json_encode(["success" => false, "message" => "Email is required"]);
            exit;
        }
        
        // Generate 6-digit random code
        $code = str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT);
        
        // Set expiry date to 30 days from now
        $expires_at = date('Y-m-d H:i:s', strtotime('+30 days'));
        
        // Insert into database
        $stmt = $conn->prepare("INSERT INTO coupons (code, discount_percent, email, expires_at) VALUES (?, 10, ?, ?)");
        $stmt->bind_param("sss", $code, $email, $expires_at);
        
        if ($stmt->execute()) {
            echo json_encode([
                "success" => true, 
                "code" => $code, 
                "discount_percent" => 10,
                "expires_at" => $expires_at
            ]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to create coupon"]);
        }
        $stmt->close();
    } 
    elseif ($action === 'validate') {
        // Validate coupon
        $code = $_POST['code'] ?? '';
        
        if (empty($code)) {
            echo json_encode(["success" => false, "message" => "Mã giảm giá không được để trống"]);
            exit;
        }
        
        // Check if coupon exists and is valid
        $stmt = $conn->prepare("SELECT * FROM coupons WHERE code = ? AND is_used = 0 AND expires_at > NOW()");
        $stmt->bind_param("s", $code);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            $coupon = $result->fetch_assoc();
            echo json_encode([
                "success" => true,
                "valid" => true,
                "discount_percent" => $coupon['discount_percent'],
                "message" => "Mã giảm giá hợp lệ! Giảm " . $coupon['discount_percent'] . "%"
            ]);
        } else {
            echo json_encode([
                "success" => true,
                "valid" => false,
                "message" => "Mã giảm giá không hợp lệ hoặc đã hết hạn!"
            ]);
        }
        $stmt->close();
    }
    elseif ($action === 'use') {
        // Mark coupon as used after successful order
        $code = $_POST['code'] ?? '';
        
        if (empty($code)) {
            echo json_encode(["success" => false, "message" => "Mã giảm giá không được để trống"]);
            exit;
        }
        
        $stmt = $conn->prepare("UPDATE coupons SET is_used = 1 WHERE code = ?");
        $stmt->bind_param("s", $code);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Coupon marked as used"]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to update coupon"]);
        }
        $stmt->close();
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}

$conn->close();
