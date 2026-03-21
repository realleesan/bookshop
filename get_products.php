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

// Kết nối với cơ sở dữ liệu
$conn = new mysqli($servername, $username, $password, $dbname);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Set charset to UTF-8
$conn->set_charset("utf8");

// Truy vấn dữ liệu từ bảng sản phẩm
$sql = "SELECT id, status, title, img, category, price, describes FROM products";
$result = $conn->query($sql);

$products = array();

if ($result && $result->num_rows > 0) {
    // Lưu dữ liệu sản phẩm vào mảng
    while($row = $result->fetch_assoc()) {
        $products[] = $row;
    }
}

// Trả về dữ liệu dưới dạng JSON
echo json_encode($products);


$conn->close();
?>
