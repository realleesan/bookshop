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

// Kết nối đến cơ sở dữ liệu
$servername = "localhost"; // Địa chỉ máy chủ MySQL
$username = "root"; // Tên đăng nhập MySQL
$password = ""; // Mật khẩu MySQL
$dbname = "websach"; // Tên cơ sở dữ liệu

$conn = new mysqli($servername, $username, $password, $dbname);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Kết nối cơ sở dữ liệu thất bại!"]));
}

// Lấy dữ liệu từ yêu cầu
$id = $_POST['id'];
$title = $_POST['title'];
$category = $_POST['category'];
$price = $_POST['price'];
$status = $_POST['status'];
$desc = $_POST['desc'];
$oldImagePath = $_POST['oldImagePath']; // Đường dẫn ảnh cũ

$newImagePath = $oldImagePath; // Mặc định là ảnh cũ

// Handle file upload
$uploadDir = "./assets/img/products/";

// Kiểm tra xem có ảnh mới được tải lên không
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
            $newImagePath = "./assets/img/products/" . $newFileName;
            
            // Xóa ảnh cũ nếu đường dẫn ảnh cũ hợp lệ và khác với ảnh mới
            if ($oldImagePath && $oldImagePath !== $newImagePath && $oldImagePath !== "./assets/img/blank-image.png") {
                // Try both with and without ./ prefix
                $fullOldPath = $oldImagePath;
                if (file_exists($fullOldPath)) {
                    unlink($fullOldPath);
                }
            }
        } else {
            echo json_encode(["success" => false, "message" => "Lỗi khi tải lên hình ảnh!"]);
            exit;
        }
    } else {
        echo json_encode(["success" => false, "message" => "Định dạng file không được hỗ trợ!"]);
        exit;
    }
}

// Cập nhật sản phẩm trong cơ sở dữ liệu
$sql = "UPDATE products SET title = ?, category = ?, price = ?, describes = ?, img = ?, status = ? WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssissii", $title, $category, $price, $desc, $newImagePath, $status, $id);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Sản phẩm đã được cập nhật thành công!", "img" => $newImagePath]);
} else {
    echo json_encode(["success" => false, "message" => "Lỗi khi cập nhật sản phẩm!"]);
}

$stmt->close();
$conn->close();
?>
