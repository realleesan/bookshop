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
$dbname = "websach"; // Tên cơ sở dữ liệu

// Tạo kết nối đến cơ sở dữ liệu
$conn = new mysqli($servername, $username, $password, $dbname);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Kết nối cơ sở dữ liệu thất bại!"]));
}

// Thiết lập UTF-8 cho kết nối
$conn->set_charset("utf8");

// Lấy dữ liệu từ bảng orderDetails
$sql = "SELECT * FROM orderDetails";
$result = $conn->query($sql);

$orderDetails = [];

if ($result->num_rows > 0) {
    // Chuyển đổi từng hàng kết quả thành mảng liên kết
    while($row = $result->fetch_assoc()) {
        $orderDetails[] = $row;
    }
}

// Trả về dữ liệu dưới dạng JSON
echo json_encode($orderDetails);

// Đóng kết nối
$conn->close();
?>
