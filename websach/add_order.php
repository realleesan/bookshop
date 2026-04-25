<?php
// 1. TẠM THỜI BẬT LỖI ĐỂ DEBUG - Xong thì tắt đi
error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { exit; }

$conn = new mysqli("localhost", "root", "", "websach");
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Kết nối thất bại"]));
}

// Lấy dữ liệu
$order = json_decode($_POST['order'], true);
$orderDetails = json_decode($_POST['orderDetails'], true);

// Kiểm tra nếu mảng rỗng
if (!$order || !$orderDetails) {
    die(json_encode(["success" => false, "message" => "Dữ liệu gửi lên bị trống hoặc sai định dạng JSON"]));
}

$phiVanChuyen = $order['phiVanChuyen'] ?? 0;
$giamGia = $order['giamGia'] ?? 0;
$trangThai = $order['trangthai'] ?? 0;

// CHÈN BẢNG ORDER
$sqlOrder = "INSERT INTO `order` (id, khachhang, hinhthucgiao, thoigiangiao, ghichu, tenguoinhan, sdtnhan, diachinhan, thoigiandat, tongtien, phiVanChuyen, giamGia, trangthai) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
$stmtOrder = $conn->prepare($sqlOrder);
$stmtOrder->bind_param("sssssssssiiii", 
    $order['id'], $order['khachhang'], $order['hinhthucgiao'], $order['ngaygiaohang'], 
    $order['ghichu'], $order['tenguoinhan'], $order['sdtnhan'], $order['diachinhan'], 
    $order['thoigiandat'], $order['tongtien'], $phiVanChuyen, $giamGia, $trangThai
);

if ($stmtOrder->execute()) {
    // CHÈN BẢNG ORDER DETAILS
    $sqlOrderDetails = "INSERT INTO orderdetails (madon, product_id, note, product_price, soluong) VALUES (?, ?, ?, ?, ?)";
    $stmtOrderDetails = $conn->prepare($sqlOrderDetails);
    
    $successCount = 0;
    foreach ($orderDetails as $detail) {
        // Kiểm tra kỹ Key của mảng detail ở đây
        $mDon  = $order['id']; // Dùng luôn ID của đơn hàng vừa tạo cho chắc chắn
        $pId   = $detail['id'] ?? $detail['product_id'] ?? 0; 
        $note  = $detail['note'] ?? "";
        $price = $detail['price'] ?? $detail['product_price'] ?? 0;
        $qty   = $detail['soluong'] ?? 0;

        $stmtOrderDetails->bind_param("sisii", $mDon, $pId, $note, $price, $qty);
        
        if($stmtOrderDetails->execute()) {
            $successCount++;
        }
    }
    
    echo json_encode([
        "success" => true, 
        "message" => "Thành công! Đã chèn đơn hàng và $successCount chi tiết mặt hàng."
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Lỗi SQL Order: " . $stmtOrder->error]);
}

$conn->close();
?>