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
$data = json_decode(file_get_contents('php://input'), true);
$phone = $data['phone'];

// Xóa tài khoản khỏi cơ sở dữ liệu
$sql = "DELETE FROM users WHERE phone = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $phone);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Xóa tài khoản thành công!"]);
} else {
    echo json_encode(["success" => false, "message" => "Đã xảy ra lỗi khi xóa tài khoản!"]);
}

$stmt->close();
$conn->close();
?>
