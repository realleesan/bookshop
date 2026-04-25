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

// Bật chế độ hiển thị lỗi để dễ dàng debug
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Kết nối tới cơ sở dữ liệu
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Kết nối thất bại: " . $conn->connect_error]));
}

// Lấy dữ liệu JSON từ phía client
$input = json_decode(file_get_contents('php://input'), true);
$userPhone = $input['phone'];
$cart = $input['cart'];





// Xóa giỏ hàng cũ của người dùng
$sql = "DELETE c 
FROM cart c
JOIN users u ON c.user_id = u.id
WHERE u.phone = '$userPhone';
";
if ($conn->query($sql) === FALSE) {
    die(json_encode(["status" => "error", "message" => "Lỗi khi xóa giỏ hàng: " . $conn->error]));
}

// Chèn giỏ hàng mới vào cơ sở dữ liệu
foreach ($cart as $item) {
    $productId = $item['id']; // Chỉnh lại key thành 'id' theo đúng dữ liệu bạn cung cấp
    $quantity = $item['soluong']; // Chỉnh lại key thành 'soluong'
    $note = $conn->real_escape_string($item['note']); // Tránh lỗi SQL Injection

    // Thực hiện truy vấn chèn sản phẩm vào giỏ hàng
    $sql = "INSERT INTO cart (user_id, product_id, quantity, note) VALUES (
        (SELECT id FROM users WHERE phone = '$userPhone'),
        '$productId', '$quantity', '$note')";

    if ($conn->query($sql) === FALSE) {
        die(json_encode(["status" => "error", "message" => "Lỗi khi chèn giỏ hàng: " . $conn->error]));
    }
}

echo json_encode(["status" => "success", "message" => "Giỏ hàng đã được cập nhật."]);

$conn->close();
?>
