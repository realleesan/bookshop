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

// Lấy dữ liệu từ yêu cầu POST
$title = $_POST['title'];
$category = $_POST['category'];
$price = $_POST['price'];
$desc = $_POST['desc'];
$status = $_POST['status'];

// Handle file upload
$img = "";
$uploadDir = "./assets/img/products/";

// Check if file was uploaded
if (isset($_FILES['img']) && $_FILES['img']['error'] === UPLOAD_ERR_OK) {
    $fileTmpPath = $_FILES['img']['tmp_name'];
    $fileName = $_FILES['img']['name'];
    $fileSize = $_FILES['img']['size'];
    $fileType = $_FILES['img']['type'];
    
    // Get file extension
    $fileNameCmps = explode(".", $fileName);
    $fileExtension = strtolower(end($fileNameCmps));
    
    // Allowed extensions
    $allowedfileExtensions = array('jpg', 'jpeg', 'png', 'gif');
    
    if (in_array($fileExtension, $allowedfileExtensions)) {
        // Create new file name to avoid duplicates
        $newFileName = md5(time() . $fileName) . '.' . $fileExtension;
        
        // Create directory if it doesn't exist
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }
        
        // Move the file to the upload directory
        $dest_path = $uploadDir . $newFileName;
        
        if(move_uploaded_file($fileTmpPath, $dest_path)) {
            $img = "./assets/img/products/" . $newFileName;
        } else {
            echo json_encode(["success" => false, "message" => "Lỗi khi tải lên hình ảnh!"]);
            exit;
        }
    } else {
        echo json_encode(["success" => false, "message" => "Định dạng file không được hỗ trợ!"]);
        exit;
    }
} else {
    // No file uploaded, use default or empty
    $img = "./assets/img/blank-image.png";
}

// Chuẩn bị câu lệnh SQL để thêm sản phẩm vào cơ sở dữ liệu
$sql = "INSERT INTO products (title, img, category, price, describes, status) VALUES (?, ?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sssisi", $title, $img, $category, $price, $desc, $status);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Sản phẩm đã được thêm vào cơ sở dữ liệu thành công!", "img" => $img]);
} else {
    echo json_encode(["success" => false, "message" => "Lỗi khi thêm sản phẩm vào cơ sở dữ liệu!"]);
}

$stmt->close();
$conn->close();
?>
