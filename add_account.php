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
$address = $data['address'];
$email = $data['email'];
$status = $data['status'];
$join_date = $data['join'];
$userType = $data['userType'];

// Thêm tài khoản mới vào cơ sở dữ liệu
$sql = "INSERT INTO users (fullname, phone, password, address, email, status, join_date, userType) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sssssssi", $fullname, $phone, $password, $address, $email, $status, $join_date, $userType);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Tạo tài khoản thành công!"]);
} else {
    echo json_encode(["success" => false, "message" => "Đã xảy ra lỗi khi thêm tài khoản!"]);
}

$stmt->close();
$conn->close();
?>
