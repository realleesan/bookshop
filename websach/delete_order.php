<?php
// Turn off error reporting
error_reporting(0);
ini_set('display_errors', 0);

// CORS headers for ngrok and other domains
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Set JSON content type
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

// Kết nối đến cơ sở dữ liệu
$conn = new mysqli($servername, $username, $password, $dbname);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Kết nối cơ sở dữ liệu thất bại!"]));
}

// Đọc dữ liệu từ yêu cầu POST
$rawInput = file_get_contents('php://input');
$data = json_decode($rawInput, true);
$orderId = $data['id'] ?? '';

// Validate input
if (empty($orderId)) {
    echo json_encode(["success" => false, "message" => "Thiếu mã đơn hàng!"]);
    $conn->close();
    exit;
}

// Bắt đầu transaction để đảm bảo tính toàn vẹn
$conn->begin_transaction();

try {
    // Xóa chi tiết đơn hàng trước
    $orderIdEscaped = $conn->real_escape_string($orderId);
    $sqlDetails = "DELETE FROM orderdetails WHERE madon = '$orderIdEscaped'";
    $resultDetails = $conn->query($sqlDetails);
    
    // Xóa đơn hàng
    $sqlOrder = "DELETE FROM `order` WHERE id = '$orderIdEscaped'";
    $resultOrder = $conn->query($sqlOrder);
    
    // Commit transaction
    $conn->commit();
    
    // Kiểm tra xem câu lệnh DELETE order có thành công không (không phải affected_rows)
    if ($resultOrder) {
        echo json_encode(["success" => true, "message" => "Xóa đơn hàng thành công!"]);
    } else {
        echo json_encode(["success" => false, "message" => "Đã xảy ra lỗi khi xóa đơn hàng!"]);
    }
} catch (Exception $e) {
    // Rollback nếu có lỗi
    $conn->rollback();
    echo json_encode(["success" => false, "message" => "Đã xảy ra lỗi khi xóa đơn hàng!"]);
}

$conn->close();
?>