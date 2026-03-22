<?php
// Rating API - Handle product reviews and ratings
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Connection failed"]);
    exit;
}

$conn->set_charset("utf8");

$method = $_SERVER['REQUEST_METHOD'];

// Get product ratings (for displaying on product detail)
if ($method === 'GET' && isset($_GET['product_id'])) {
    $product_id = $_GET['product_id'];
    
    $sql = "SELECT r.*, u.username, u.email FROM ratings r 
            LEFT JOIN users u ON r.user_id = u.id 
            WHERE r.product_id = ? 
            ORDER BY r.created_at DESC";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $product_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $ratings = [];
    while ($row = $result->fetch_assoc()) {
        $ratings[] = $row;
    }
    
    // Calculate average rating
    $avgSql = "SELECT AVG(rating) as avg_rating, COUNT(*) as total_ratings FROM ratings WHERE product_id = ?";
    $avgStmt = $conn->prepare($avgSql);
    $avgStmt->bind_param("i", $product_id);
    $avgStmt->execute();
    $avgResult = $avgStmt->get_result();
    $avgData = $avgResult->fetch_assoc();
    
    echo json_encode([
        "success" => true,
        "ratings" => $ratings,
        "average_rating" => $avgData['avg_rating'] ? round($avgData['avg_rating'], 1) : 0,
        "total_ratings" => $avgData['total_ratings']
    ]);
    
    $stmt->close();
    $avgStmt->close();
    $conn->close();
    exit;
}

// Submit or update a rating
if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $product_id = $data['product_id'] ?? 0;
    $user_id = $data['user_id'] ?? 0;
    $order_id = $data['order_id'] ?? 0;
    $rating = $data['rating'] ?? 0;
    $comment = $data['comment'] ?? '';
    
    if ($product_id == 0 || $user_id == 0 || $order_id == 0 || $rating == 0) {
        echo json_encode(["success" => false, "message" => "Thiếu thông tin cần thiết"]);
        exit;
    }
    
    if ($rating < 1 || $rating > 5) {
        echo json_encode(["success" => false, "message" => "Đánh giá phải từ 1-5 sao"]);
        exit;
    }
    
    if (strlen($comment) > 300) {
        echo json_encode(["success" => false, "message" => "Bình luận không được quá 300 ký tự"]);
        exit;
    }
    
    // Check if rating already exists for this order and product
    $checkSql = "SELECT id FROM ratings WHERE order_id = ? AND product_id = ?";
    $checkStmt = $conn->prepare($checkSql);
    $checkStmt->bind_param("ii", $order_id, $product_id);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();
    
    if ($checkResult->num_rows > 0) {
        // Update existing rating
        $updateSql = "UPDATE ratings SET rating = ?, comment = ? WHERE order_id = ? AND product_id = ?";
        $updateStmt = $conn->prepare($updateSql);
        $updateStmt->bind_param("isii", $rating, $comment, $order_id, $product_id);
        
        if ($updateStmt->execute()) {
            echo json_encode(["success" => true, "message" => "Cập nhật đánh giá thành công!"]);
        } else {
            echo json_encode(["success" => false, "message" => "Lỗi khi cập nhật đánh giá"]);
        }
        $updateStmt->close();
    } else {
        // Insert new rating
        $insertSql = "INSERT INTO ratings (product_id, user_id, order_id, rating, comment) VALUES (?, ?, ?, ?, ?)";
        $insertStmt = $conn->prepare($insertSql);
        $insertStmt->bind_param("iiiis", $product_id, $user_id, $order_id, $rating, $comment);
        
        if ($insertStmt->execute()) {
            echo json_encode(["success" => true, "message" => "Đánh giá thành công!"]);
        } else {
            echo json_encode(["success" => false, "message" => "Lỗi khi thêm đánh giá"]);
        }
        $insertStmt->close();
    }
    
    $checkStmt->close();
    $conn->close();
    exit;
}

// Check if user has rated a product for a specific order
if ($method === 'GET' && isset($_GET['check_rating'])) {
    $order_id = $_GET['order_id'] ?? 0;
    $product_id = $_GET['product_id'] ?? 0;
    
    if ($order_id == 0 || $product_id == 0) {
        echo json_encode(["success" => false, "message" => "Thiếu thông tin"]);
        exit;
    }
    
    $sql = "SELECT * FROM ratings WHERE order_id = ? AND product_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $order_id, $product_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        $rating = $result->fetch_assoc();
        echo json_encode(["success" => true, "has_rated" => true, "rating" => $rating]);
    } else {
        echo json_encode(["success" => true, "has_rated" => false]);
    }
    
    $stmt->close();
    $conn->close();
    exit;
}

echo json_encode(["success" => false, "message" => "Invalid request"]);
$conn->close();
?>
