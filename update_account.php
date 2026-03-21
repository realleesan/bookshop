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

// Cập nhật thông tin tài khoản trong cơ sở dữ liệu
$sql = "UPDATE users SET fullname = ?, password = ?, status = ? WHERE phone = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssis", $fullname, $password, $status, $phone);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Cập nhật tài khoản thành công!"]);
} else {
    echo json_encode(["success" => false, "message" => "Đã xảy ra lỗi khi cập nhật tài khoản!"]);
}

$stmt->close();
$conn->close();
?>
