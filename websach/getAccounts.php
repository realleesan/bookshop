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

// Kết nối với cơ sở dữ liệu
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Kết nối thất bại: " . $conn->connect_error);
}

// Truy vấn để lấy thông tin người dùng và giỏ hàng của họ
$sql = "SELECT u.id, u.fullname, u.phone, u.password, u.address, u.email, u.status, u.join_date, u.userType, c.product_id, c.quantity, c.note
        FROM users u
        LEFT JOIN cart c ON u.id = c.user_id";
$result = $conn->query($sql);

$accounts = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $userId = $row['phone']; // Giả sử phone là unique và được dùng làm key

        // Kiểm tra nếu người dùng đã có trong mảng $accounts
        if (!isset($accounts[$userId])) {
            $accounts[$userId] = array(
                'id' => (int)$row['id'],
                'fullname' => $row['fullname'],
                'phone' => $row['phone'],
                'password' => $row['password'],
                'address' => $row['address'],
                'email' => $row['email'],
                'status' => (int)$row['status'],
                'join_date' => (new DateTime($row['join_date']))->format(DateTime::ATOM),
                'cart' => [],
                'userType' => (int)$row['userType']
            );
        }

        // Thêm sản phẩm vào giỏ hàng
        if ($row['product_id'] !== null) {
            $accounts[$userId]['cart'][] = array(
                'id' => $row['product_id'],
                'soluong' => (int)$row['quantity'],
                'note' => $row['note']
            );
        }
    }
}

// Chuyển đổi mảng kết hợp thành mảng số để sử dụng trong JSON
$accounts = array_values($accounts);

echo json_encode($accounts);

$conn->close();
?>
