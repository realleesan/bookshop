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

// Kết nối đến cơ sở dữ liệu
$conn = new mysqli($servername, $username, $password, $dbname);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Kết nối cơ sở dữ liệu thất bại!"]));
}

// Thiết lập UTF-8 cho kết nối
$conn->set_charset("utf8");

// Đọc dữ liệu từ yêu cầu POST
$data = json_decode(file_get_contents('php://input'), true);

$orderId = isset($data['orderId']) ? $data['orderId'] : '';
$phone = isset($data['phone']) ? $data['phone'] : '';
$confirmText = isset($data['confirmText']) ? $data['confirmText'] : '';
$userPassword = isset($data['password']) ? $data['password'] : '';

// Kiểm tra giá trị đầu vào
if (empty($orderId) || empty($phone) || empty($confirmText) || empty($userPassword)) {
    echo json_encode(["success" => false, "message" => "Thiếu thông tin cần thiết!"]);
    $conn->close();
    exit;
}

// Kiểm tra text xác nhận
if ($confirmText !== "tôi xác nhận hủy") {
    echo json_encode(["success" => false, "message" => "Text xác nhận không đúng!"]);
    $conn->close();
    exit;
}

// Kiểm tra mật khẩu người dùng
$phoneEscaped = $conn->real_escape_string($phone);
$sql = "SELECT password FROM users WHERE phone = '$phoneEscaped'";
$result = $conn->query($sql);

if ($result->num_rows === 0) {
    echo json_encode(["success" => false, "message" => "Người dùng không tồn tại!"]);
    $conn->close();
    exit;
}

$row = $result->fetch_assoc();
if ($row['password'] !== $userPassword) {
    echo json_encode(["success" => false, "message" => "Mật khẩu không đúng!"]);
    $conn->close();
    exit;
}

// Lấy thông tin đơn hàng để kiểm tra
$orderIdEscaped = $conn->real_escape_string($orderId);
$sql = "SELECT trangthai FROM `order` WHERE id = '$orderIdEscaped'";
$result = $conn->query($sql);

if ($result->num_rows === 0) {
    echo json_encode(["success" => false, "message" => "Đơn hàng không tồn tại!"]);
    $conn->close();
    exit;
}

$order = $result->fetch_assoc();
$currentStatus = intval($order['trangthai']);

// Chỉ cho phép hủy đơn hàng khi đang ở trạng thái chờ xử lý (0)
if ($currentStatus !== 0) {
    echo json_encode(["success" => false, "message" => "Không thể hủy đơn hàng! Chỉ có thể hủy khi đơn hàng đang chờ xử lý."]);
    $conn->close();
    exit;
}

// Cập nhật trạng thái đơn hàng thành đã hủy (3)
$sql = "UPDATE `order` SET trangthai = 3 WHERE id = '$orderIdEscaped'";

if ($conn->query($sql)) {
    echo json_encode(["success" => true, "message" => "Hủy đơn hàng thành công!"]);
} else {
    echo json_encode(["success" => false, "message" => "Đã xảy ra lỗi khi hủy đơn hàng: " . $conn->error]);
}

$conn->close();
?>