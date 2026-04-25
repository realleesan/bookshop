<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST, GET');
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

// Add ranking columns if they don't exist
$conn->query("ALTER TABLE products ADD COLUMN IF NOT EXISTS `search_count` INT(11) DEFAULT 0");
$conn->query("ALTER TABLE products ADD COLUMN IF NOT EXISTS `like_count` INT(11) DEFAULT 0");
$conn->query("ALTER TABLE products ADD COLUMN IF NOT EXISTS `sold_count` INT(11) DEFAULT 0");

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $action = $_POST['action'] ?? '';
    $productId = $_POST['product_id'] ?? '';
    
    if (empty($productId)) {
        echo json_encode(["success" => false, "message" => "Product ID is required"]);
        exit;
    }
    
    if ($action === 'increment_search') {
        // Increment search count
        $stmt = $conn->prepare("UPDATE products SET search_count = search_count + 1 WHERE id = ?");
        $stmt->bind_param("i", $productId);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Search count updated"]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to update search count"]);
        }
        $stmt->close();
    }
    elseif ($action === 'increment_like') {
        // Increment like count
        $stmt = $conn->prepare("UPDATE products SET like_count = like_count + 1 WHERE id = ?");
        $stmt->bind_param("i", $productId);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Like count updated"]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to update like count"]);
        }
        $stmt->close();
    }
    elseif ($action === 'increment_sold') {
        // Increment sold count (when order is placed)
        $quantity = $_POST['quantity'] ?? 1;
        $stmt = $conn->prepare("UPDATE products SET sold_count = sold_count + ? WHERE id = ?");
        $stmt->bind_param("ii", $quantity, $productId);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Sold count updated"]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to update sold count"]);
        }
        $stmt->close();
    }
    else {
        echo json_encode(["success" => false, "message" => "Invalid action"]);
    }
}
elseif ($method === 'GET') {
    $category = $_GET['category'] ?? '';
    $sortBy = $_GET['sort'] ?? 'sold_count'; // default to best selling
    
    $validSorts = ['sold_count', 'like_count', 'search_count'];
    if (!in_array($sortBy, $validSorts)) {
        $sortBy = 'sold_count';
    }
    
    $sql = "SELECT id, status, title, img, category, price, describes, search_count, like_count, sold_count 
            FROM products WHERE status = 1";
    
    if (!empty($category)) {
        $sql .= " AND category LIKE '%" . $conn->real_escape_string($category) . "%'";
    }
    
    $sql .= " ORDER BY " . $sortBy . " DESC LIMIT 10";
    
    $result = $conn->query($sql);
    $products = array();
    
    if ($result && $result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $products[] = $row;
        }
    }
    
    echo json_encode($products);
}

$conn->close();
