<?php
// Script thêm dữ liệu mẫu cho bảng orderdetails
// Chạy file này một lần trong trình duyệt để thêm dữ liệu

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Thêm dữ liệu mẫu
$sql = "INSERT INTO orderdetails (id, madon, product_id, note, product_price, soluong) VALUES 
(1, 'DH4', 1, 'Sach hay', 100000, 1),
(2, 'DH4', 2, 'Tang ai do', 50000, 2),
(3, 'DH5', 3, 'Giao som', 150000, 1),
(4, 'DH5', 4, '', 80000, 3)";

if ($conn->query($sql) === TRUE) {
    echo "Da them du lieu mau thanh cong!";
} else {
    echo "Loi: " . $conn->error;
}

$conn->close();
?>
