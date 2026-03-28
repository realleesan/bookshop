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
// Sử dụng CAST để so sánh đúng với cột kiểu TEXT
$sql = "DELETE FROM users WHERE CAST(phone AS CHAR) = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $phone);

$stmt->execute();

// Kiểm tra số bản ghi bị ảnh hưởng
$affectedRows = $stmt->affected_rows;

if ($affectedRows > 0) {
    echo json_encode(["success" => true, "message" => "Xóa tài khoản thành công!"]);
} else {
    // Không tìm thấy tài khoản để xóa (user không tồn tại hoặc phone không khớp)
    echo json_encode(["success" => false, "message" => "Không tìm thấy tài khoản để xóa!"]);
}

$stmt->close();
$conn->close();
?>
