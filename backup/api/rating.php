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
    $product_id = intval($_GET['product_id']);
    
    $sql = "SELECT r.*, COALESCE(r.user_fullname, u.fullname, 'Ẩn danh') as display_name, u.email FROM ratings r 
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
    $user_fullname = $data['user_fullname'] ?? '';
    $order_id = $data['order_id'] ?? 0;
    $rating = $data['rating'] ?? 0;
    $comment = $data['comment'] ?? '';
    
    // Handle string values - extract numeric part from "DH1" format and validate
    $product_id = is_numeric($product_id) ? intval($product_id) : 0;
    $order_id = is_numeric($order_id) ? intval($order_id) : 0;
    $rating = is_numeric($rating) ? intval($rating) : 0;
    
    // For user_id, it could be either a numeric ID or a phone string
    // If it's a phone string, look up the user in the database
    if (!is_numeric($user_id) && !empty($user_id)) {
        // This is a phone number, look up the user
        $phoneLookupSql = "SELECT id FROM users WHERE phone = ?";
        $phoneLookupStmt = $conn->prepare($phoneLookupSql);
        $phoneLookupStmt->bind_param("s", $user_id);
        $phoneLookupStmt->execute();
        $phoneLookupResult = $phoneLookupStmt->get_result();
        if ($phoneLookupResult->num_rows > 0) {
            $phoneUser = $phoneLookupResult->fetch_assoc();
            $user_id = $phoneUser['id'];
        } else {
            $user_id = 0;
        }
        $phoneLookupStmt->close();
    } else {
        $user_id = intval($user_id);
    }
    
    $errors = [];
    if ($product_id == 0) $errors[] = "product_id";
    if ($user_id == 0 || $user_id === '') $errors[] = "user_id";
    if ($order_id == 0) $errors[] = "order_id";
    if ($rating == 0) $errors[] = "rating";
    
    if (count($errors) > 0) {
        echo json_encode(["success" => false, "message" => "Thiếu thông tin: " . implode(", ", $errors)]);
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
        // Already rated - don't allow updating
        echo json_encode(["success" => false, "message" => "Sản phẩm này đã được đánh giá trong đơn hàng này!"]);
        $checkStmt->close();
        $conn->close();
        exit;
    } else {
        // Insert new rating
        $insertSql = "INSERT INTO ratings (product_id, user_id, order_id, rating, comment, user_fullname) VALUES (?, ?, ?, ?, ?, ?)";
        $insertStmt = $conn->prepare($insertSql);
        $insertStmt->bind_param("iiiiss", $product_id, $user_id, $order_id, $rating, $comment, $user_fullname);
        
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
    
    $sql = "SELECT rating, comment, created_at FROM ratings WHERE order_id = ? AND product_id = ?";
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

// Get all ratings (for admin)
if ($method === 'GET' && isset($_GET['admin']) && $_GET['admin'] === 'all') {
    $sql = "SELECT r.*, p.title as product_title, COALESCE(r.user_fullname, u.fullname, '') as display_name, u.email 
            FROM ratings r
            LEFT JOIN products p ON r.product_id = p.id
            LEFT JOIN users u ON r.user_id = u.id
            ORDER BY r.created_at DESC";
    
    $result = $conn->query($sql);
    
    $ratings = [];
    while ($row = $result->fetch_assoc()) {
        $ratings[] = $row;
    }
    
    echo json_encode(["success" => true, "ratings" => $ratings]);
    $conn->close();
    exit;
}

// Delete a rating (for admin)
if ($method === 'DELETE') {
    $data = json_decode(file_get_contents('php://input'), true);
    $rating_id = $data['id'] ?? 0;
    
    if ($rating_id == 0) {
        echo json_encode(["success" => false, "message" => "Thiếu ID đánh giá"]);
        exit;
    }
    
    $deleteSql = "DELETE FROM ratings WHERE id = ?";
    $deleteStmt = $conn->prepare($deleteSql);
    $deleteStmt->bind_param("i", $rating_id);
    
    if ($deleteStmt->execute()) {
        echo json_encode(["success" => true, "message" => "Xóa đánh giá thành công!"]);
    } else {
        echo json_encode(["success" => false, "message" => "Lỗi khi xóa đánh giá"]);
    }
    $deleteStmt->close();
    $conn->close();
    exit;
}

$conn->close();
?>
