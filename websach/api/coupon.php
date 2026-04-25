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

// 1. Khởi tạo bảng nếu chưa có
$sql = "CREATE TABLE IF NOT EXISTS `coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `discount_percent` int(11) NOT NULL DEFAULT 10,
  `email` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
$conn->query($sql);

$sqlSettings = "CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(50) NOT NULL UNIQUE,
  `setting_value` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
$conn->query($sqlSettings);

$conn->query("INSERT IGNORE INTO `settings` (`setting_key`, `setting_value`) VALUES ('footer_discount_percent', '10')");
$conn->query("INSERT IGNORE INTO `settings` (`setting_key`, `setting_value`) VALUES ('coupon_duration_hours', '0')");
$conn->query("INSERT IGNORE INTO `settings` (`setting_key`, `setting_value`) VALUES ('coupon_duration_minutes', '30')");
$conn->query("INSERT IGNORE INTO `settings` (`setting_key`, `setting_value`) VALUES ('coupon_duration_seconds', '0')");

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $action = $_POST['action'] ?? '';

    if ($action === 'create') {
        $email = $_POST['email'] ?? '';
        if (empty($email)) {
            echo json_encode(["success" => false, "message" => "Email is required"]);
            exit;
        }

        do {
            $code = str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT);
            $check = $conn->prepare("SELECT id FROM coupons WHERE code = ?");
            $check->bind_param("s", $code);
            $check->execute();
            $resultCheck = $check->get_result();
        } while ($resultCheck->num_rows > 0);

        // Get duration settings
        $hours = 0;
        $minutes = 30;
        $seconds = 0;
        $debug_duration_rows = [];
        $stmtDuration = $conn->prepare("SELECT setting_key, setting_value FROM settings WHERE setting_key LIKE 'coupon_duration_%'");
        $stmtDuration->execute();
        $resultDuration = $stmtDuration->get_result();
        while ($rowDuration = $resultDuration->fetch_assoc()) {
            $rowDuration['setting_key'] = trim($rowDuration['setting_key']);
            $debug_duration_rows[] = $rowDuration;
            if ($rowDuration['setting_key'] === 'coupon_duration_hours') {
                $hours = intval($rowDuration['setting_value']);
            } elseif ($rowDuration['setting_key'] === 'coupon_duration_minutes') {
                $minutes = intval($rowDuration['setting_value']);
            } elseif ($rowDuration['setting_key'] === 'coupon_duration_seconds') {
                $seconds = intval($rowDuration['setting_value']);
            }
        }
        $stmtDuration->close();

        // Calculate expires_at based on duration settings
        $durationStr = "+{$hours} hours {$minutes} minutes {$seconds} seconds";
        $expires_at = date('Y-m-d H:i:s', strtotime($durationStr));

        $discountPercent = 10;
        $stmtSetting = $conn->prepare("SELECT setting_value FROM settings WHERE setting_key = 'footer_discount_percent'");
        $stmtSetting->execute();
        $resultSetting = $stmtSetting->get_result();
        if ($rowSetting = $resultSetting->fetch_assoc()) {
            $discountPercent = intval($rowSetting['setting_value']);
        }
        $stmtSetting->close();

        $stmt = $conn->prepare("INSERT INTO coupons (code, discount_percent, email, expires_at) VALUES (?, ?, ?, ?)");
        // Dùng ssss để bảo toàn số 0 ở đầu mã
        $stmt->bind_param("ssss", $code, $discountPercent, $email, $expires_at);

        if ($stmt->execute()) {
            echo json_encode([
                "success" => true,
                "code" => $code,
                "discount_percent" => $discountPercent,
                "expires_at" => $expires_at,
                "duration_hours" => $hours,
                "duration_minutes" => $minutes,
                "duration_seconds" => $seconds,
                "debug_db_rows" => $debug_duration_rows
            ]);
        } else {
            echo json_encode(["success" => false, "message" => "Lỗi database: " . $stmt->error]);
        }
        $stmt->close();

    } elseif ($action === 'validate') {
        $code = trim($_POST['code'] ?? '');
        $email = trim($_POST['email'] ?? '');

        if (empty($code)) {
            echo json_encode(["success" => false, "message" => "Vui lòng nhập mã giảm giá"]);
            exit;
        }

        // Debug: ghi log
        error_log("[DEBUG] Validating coupon: code=$code, email=$email");

        // Kiểm tra mã tồn tại (không check is_used và expires_at ngay)
        $stmt = $conn->prepare("SELECT * FROM coupons WHERE code = ?");
        $stmt->bind_param("s", $code);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $coupon = $result->fetch_assoc();
            error_log("[DEBUG] Found coupon: " . print_r($coupon, true));

            // Kiểm tra is_used
            if ($coupon['is_used'] == 1) {
                echo json_encode([
                    "success" => true,
                    "valid" => false,
                    "message" => "Mã này đã được sử dụng"
                ]);
                $stmt->close();
                exit;
            }

            // Kiểm tra expires_at
            if (strtotime($coupon['expires_at']) <= time()) {
                echo json_encode([
                    "success" => true,
                    "valid" => false,
                    "message" => "Mã này đã hết hạn"
                ]);
                $stmt->close();
                exit;
            }

            // Kiểm tra email có khớp không
            $couponEmail = strtolower(trim($coupon['email']));
            $inputEmail = strtolower(trim($email));
            error_log("[DEBUG] Email check: couponEmail=$couponEmail, inputEmail=$inputEmail");

            if (!empty($email) && $couponEmail !== $inputEmail) {
                echo json_encode([
                    "success" => true,
                    "valid" => false,
                    "message" => "Mã giảm giá này không thuộc về tài khoản của bạn"
                ]);
            } else {
                echo json_encode([
                    "success" => true,
                    "valid" => true,
                    "discount_percent" => (int)$coupon['discount_percent'],
                    "message" => "Áp dụng thành công! Giảm " . $coupon['discount_percent'] . "%"
                ]);
            }
        } else {
            error_log("[DEBUG] Coupon not found: $code");
            echo json_encode([
                "success" => true,
                "valid" => false,
                "message" => "Mã không tồn tại"
            ]);
        }
        $stmt->close();

    } elseif ($action === 'get_default_discount') {
        $stmt = $conn->prepare("SELECT setting_value FROM settings WHERE setting_key = 'footer_discount_percent'");
        $stmt->execute();
        $result = $stmt->get_result();
        $discount = ($row = $result->fetch_assoc()) ? intval($row['setting_value']) : 10;
        echo json_encode(["success" => true, "discount_percent" => $discount]);
        $stmt->close();

    } elseif ($action === 'update_default_discount') {
        $discount = $_POST['discount'] ?? '';
        if (empty($discount) || $discount < 1 || $discount > 100) {
            echo json_encode(["success" => false, "message" => "Giá trị không hợp lệ"]);
            exit;
        }
        $stmt = $conn->prepare("UPDATE settings SET setting_value = ? WHERE setting_key = 'footer_discount_percent'");
        $stmt->bind_param("s", $discount);
        $success = $stmt->execute();
        echo json_encode(["success" => $success, "message" => $success ? "Đã cập nhật" : "Lỗi cập nhật"]);
        $stmt->close();

    } elseif ($action === 'use') {
        $code = $_POST['code'] ?? '';
        if (empty($code)) {
            echo json_encode(["success" => false, "message" => "Thiếu mã"]);
            exit;
        }
        $stmt = $conn->prepare("UPDATE coupons SET is_used = 1 WHERE code = ? AND is_used = 0");
        $stmt->bind_param("s", $code);
        $success = $stmt->execute();
        echo json_encode(["success" => $success]);
        $stmt->close();

    } elseif ($action === 'get_coupon_duration') {
        $hours = 0;
        $minutes = 30;
        $seconds = 0;
        $debug_rows = [];

        // Kiểm tra bảng tồn tại
        $checkTable = $conn->query("SHOW TABLES LIKE 'settings'");
        if ($checkTable->num_rows === 0) {
            echo json_encode(["success" => false, "message" => "Bảng settings không tồn tại", "db_error" => $conn->error]);
            exit;
        }

        $stmt = $conn->prepare("SELECT setting_key, setting_value FROM settings WHERE setting_key LIKE 'coupon_duration_%'");
        if (!$stmt) {
            echo json_encode(["success" => false, "message" => "Lỗi prepare statement", "db_error" => $conn->error]);
            exit;
        }

        $stmt->execute();
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()) {
            $row['setting_key'] = trim($row['setting_key']);
            $debug_rows[] = $row;
            if ($row['setting_key'] === 'coupon_duration_hours') {
                $hours = intval($row['setting_value']);
            } elseif ($row['setting_key'] === 'coupon_duration_minutes') {
                $minutes = intval($row['setting_value']);
            } elseif ($row['setting_key'] === 'coupon_duration_seconds') {
                $seconds = intval($row['setting_value']);
            }
        }
        echo json_encode([
            "success" => true,
            "hours" => $hours,
            "minutes" => $minutes,
            "seconds" => $seconds,
            "debug_rows" => $debug_rows
        ]);
        $stmt->close();

    } elseif ($action === 'update_coupon_duration') {
        $hours = $_POST['hours'] ?? '0';
        $minutes = $_POST['minutes'] ?? '0';
        $seconds = $_POST['seconds'] ?? '0';

        // Debug: log received values
        error_log("[DEBUG] update_coupon_duration received: hours=$hours, minutes=$minutes, seconds=$seconds");
        error_log("[DEBUG] POST data: " . print_r($_POST, true));

        // Validation: Không được phép cả 3 đều là 0, chỉ tối đa 2 giá trị được phép là 0
        $zeroCount = 0;
        if (intval($hours) === 0) $zeroCount++;
        if (intval($minutes) === 0) $zeroCount++;
        if (intval($seconds) === 0) $zeroCount++;

        if ($zeroCount >= 3) {
            echo json_encode(["success" => false, "message" => "Thời hạn không hợp lệ! Không được phép cả giờ, phút, giây đều bằng 0."]);
            exit;
        }

        // Đảm bảo giá trị không âm
        $hours = max(0, intval($hours));
        $minutes = max(0, intval($minutes));
        $seconds = max(0, intval($seconds));

        // Dùng UPDATE giống như update_default_discount
        $stmt1 = $conn->prepare("UPDATE settings SET setting_value = ? WHERE setting_key = 'coupon_duration_hours'");
        $stmt1->bind_param("s", $hours);
        $success1 = $stmt1->execute();
        $stmt1->close();

        $stmt2 = $conn->prepare("UPDATE settings SET setting_value = ? WHERE setting_key = 'coupon_duration_minutes'");
        $stmt2->bind_param("s", $minutes);
        $success2 = $stmt2->execute();
        $stmt2->close();

        $stmt3 = $conn->prepare("UPDATE settings SET setting_value = ? WHERE setting_key = 'coupon_duration_seconds'");
        $stmt3->bind_param("s", $seconds);
        $success3 = $stmt3->execute();
        $stmt3->close();

        $success = $success1 && $success2 && $success3;
        echo json_encode([
            "success" => $success,
            "message" => $success ? "Đã cập nhật thời hạn mã giảm giá" : "Lỗi cập nhật"
        ]);

    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}

$conn->close();
?>