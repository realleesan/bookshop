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

$servername = "localhost"; // Địa chỉ máy chủ MySQL
$username = "root"; // Tên đăng nhập MySQL
$password = ""; // Mật khẩu MySQL
$dbname = "websach"; // Tên cơ sở dữ liệu của bạn

// Kết nối đến cơ sở dữ liệu
$conn = new mysqli($servername, $username, $password, $dbname);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Kết nối cơ sở dữ liệu thất bại!"]));
}

// Đọc dữ liệu từ yêu cầu POST
$rawInput = file_get_contents('php://input');
$data = json_decode($rawInput, true);
$phone = $data['phone'] ?? '';

// Debug: ghi log giá trị phone
$debugMsg = date('Y-m-d H:i:s') . " | raw: '" . $rawInput . "' | phone: '" . $phone . "' | len: " . strlen($phone) . "\n";
file_put_contents('test_delete.log', $debugMsg, FILE_APPEND);

// Bắt đầu transaction để đảm bảo tính toàn vẹn dữ liệu
$conn->begin_transaction();

try {
    $phoneEscaped = $conn->real_escape_string($phone);
    
    // Bước 1: Lấy danh sách đơn hàng của user
    $sqlGetOrders = "SELECT id FROM `order` WHERE khachhang = '$phoneEscaped'";
    $resultGetOrders = $conn->query($sqlGetOrders);
    $orderIds = [];
    if ($resultGetOrders && $resultGetOrders->num_rows > 0) {
        while($row = $resultGetOrders->fetch_assoc()) {
            $orderIds[] = $row['id'];
        }
    }
    
    // Bước 2: Xóa chi tiết đơn hàng của các đơn đó
    foreach ($orderIds as $orderId) {
        $orderIdEscaped = $conn->real_escape_string($orderId);
        $conn->query("DELETE FROM orderdetails WHERE madon = '$orderIdEscaped'");
    }
    
    // Bước 3: Xóa các đơn hàng của user
    $conn->query("DELETE FROM `order` WHERE khachhang = '$phoneEscaped'");
    
    // Bước 4: Xóa tài khoản user
    $sql = "DELETE FROM users WHERE phone = '$phoneEscaped'";
    $result = $conn->query($sql);
    
    // Commit transaction
    $conn->commit();
    
    // Kiểm tra số bản ghi bị ảnh hưởng
    $affectedRows = $conn->affected_rows;

    if ($result && $affectedRows > 0) {
        echo json_encode(["success" => true, "message" => "Xóa tài khoản và các đơn hàng liên quan thành công!"]);
    } else {
        echo json_encode(["success" => false, "message" => "Không tìm thấy tài khoản để xóa!"]);
    }
} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["success" => false, "message" => "Đã xảy ra lỗi khi xóa tài khoản!"]);
}

$conn->close();
?>
