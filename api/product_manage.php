<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST, GET, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "websach";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Connection failed"]);
    exit;
}

$conn->set_charset("utf8");

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $action = $data['action'] ?? '';
    $productId = $data['id'] ?? 0;
    
    if ($productId == 0) {
        echo json_encode(["success" => false, "message" => "Product ID is required"]);
        exit;
    }
    
    if ($action === 'permanent_delete') {
        // Permanently delete product from database
        $stmt = $conn->prepare("DELETE FROM products WHERE id = ?");
        $stmt->bind_param("i", $productId);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Product permanently deleted"]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to delete product"]);
        }
        $stmt->close();
    }
    elseif ($action === 'delete') {
        // Soft delete (set status to 0) - legacy support
        $stmt = $conn->prepare("UPDATE products SET status = 0 WHERE id = ?");
        $stmt->bind_param("i", $productId);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Product deleted"]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to delete product"]);
        }
        $stmt->close();
    }
    else {
        echo json_encode(["success" => false, "message" => "Invalid action"]);
    }
}

$conn->close();
