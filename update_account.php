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
$data = json_decode(file_get_contents('php://input'), true);
$fullname = $data['fullname'];
$phone = $data['phone'];
$password = $data['password'];
$status = $data['status'];

// Chuyển đổi status sang số nguyên
$statusInt = $status ? 1 : 0;

// Cập nhật thông tin tài khoản trong cơ sở dữ liệu
// Sử dụng real_escape_string thay vì prepared statements để tránh vấn đề với phone number
$fullnameEscaped = $conn->real_escape_string($fullname);
$phoneEscaped = $conn->real_escape_string($phone);
$passwordEscaped = $conn->real_escape_string($password);

$sql = "UPDATE users SET fullname = '$fullnameEscaped', password = '$passwordEscaped', status = $statusInt WHERE phone = '$phoneEscaped'";

if ($conn->query($sql)) {
    echo json_encode(["success" => true, "message" => "Cập nhật tài khoản thành công!"]);
} else {
    echo json_encode(["success" => false, "message" => "Đã xảy ra lỗi khi cập nhật tài khoản!"]);
}

$conn->close();
?>
