<?php
// Test file for coupon duration functionality
?>
<!DOCTYPE html>
<html>
<head>
    <title>Test Coupon Duration API</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #333; border-bottom: 2px solid #4CAF50; padding-bottom: 10px; }
        h2 { color: #555; margin-top: 30px; }
        .test-section { margin: 20px 0; padding: 15px; background: #f9f9f9; border-radius: 4px; }
        .result { padding: 10px; margin: 10px 0; border-radius: 4px; font-family: monospace; white-space: pre-wrap; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        button { padding: 10px 20px; margin: 5px; cursor: pointer; background: #4CAF50; color: white; border: none; border-radius: 4px; }
        button:hover { background: #45a049; }
        input { padding: 8px; margin: 5px; width: 80px; text-align: center; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #4CAF50; color: white; }
        .current-values { font-size: 18px; color: #2196F3; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🧪 Test Coupon Duration API</h1>

        <div class="test-section">
            <h2>1. Kiểm tra giá trị hiện tại trong Database</h2>
            <button onclick="testGetDuration()">Lấy giá trị hiện tại</button>
            <div id="get-result" class="result info">Chưa chạy test...</div>
        </div>

        <div class="test-section">
            <h2>2. Cập nhật thời hạn mới</h2>
            <p>Nhập giá trị mới:</p>
            <label>Giờ: <input type="number" id="hours" value="0" min="0"></label>
            <label>Phút: <input type="number" id="minutes" value="0" min="0"></label>
            <label>Giây: <input type="number" id="seconds" value="10" min="0"></label>
            <br><br>
            <button onclick="testUpdateDuration()">Cập nhật thời hạn</button>
            <div id="update-result" class="result info">Chưa chạy test...</div>
        </div>

        <div class="test-section">
            <h2>3. Kiểm tra lại sau khi cập nhật</h2>
            <button onclick="testGetDurationAgain()">Lấy giá trị lại</button>
            <div id="get-again-result" class="result info">Chưa chạy test...</div>
        </div>

        <div class="test-section">
            <h2>4. Test tạo coupon mới</h2>
            <label>Email: <input type="email" id="test-email" value="test@example.com" style="width: 200px;"></label>
            <button onclick="testCreateCoupon()">Tạo mã giảm giá</button>
            <div id="create-result" class="result info">Chưa chạy test...</div>
        </div>

        <div class="test-section">
            <h2>📋 Database Status</h2>
            <button onclick="checkDatabase()">Kiểm tra bảng settings</button>
            <div id="db-result" class="result info">Chưa kiểm tra...</div>
        </div>
    </div>

    <script>
        // Sử dụng đường dẫn tuyệt đối để tránh ngrok redirect
        const API_URL = window.location.origin + '/websach/api/coupon.php';
        console.log('API_URL:', API_URL);

        function displayResult(elementId, data, isError = false) {
            const el = document.getElementById(elementId);
            el.className = 'result ' + (isError ? 'error' : 'success');
            el.textContent = JSON.stringify(data, null, 2);
        }

        function testGetDuration() {
            fetch(API_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=get_coupon_duration'
            })
            .then(r => r.text())
            .then(text => {
                try {
                    const data = JSON.parse(text);
                    displayResult('get-result', data);
                } catch (e) {
                    displayResult('get-result', { error: 'Parse error', raw: text }, true);
                }
            })
            .catch(err => displayResult('get-result', { error: err.message }, true));
        }

        function testUpdateDuration() {
            const hours = document.getElementById('hours').value;
            const minutes = document.getElementById('minutes').value;
            const seconds = document.getElementById('seconds').value;

            const body = `action=update_coupon_duration&hours=${hours}&minutes=${minutes}&seconds=${seconds}`;

            fetch(API_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body
            })
            .then(r => r.text())
            .then(text => {
                try {
                    const data = JSON.parse(text);
                    displayResult('update-result', data);
                } catch (e) {
                    displayResult('update-result', { error: 'Parse error', raw: text }, true);
                }
            })
            .catch(err => displayResult('update-result', { error: err.message }, true));
        }

        function testGetDurationAgain() {
            fetch(API_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=get_coupon_duration'
            })
            .then(r => r.text())
            .then(text => {
                try {
                    const data = JSON.parse(text);
                    displayResult('get-again-result', data);
                } catch (e) {
                    displayResult('get-again-result', { error: 'Parse error', raw: text }, true);
                }
            })
            .catch(err => displayResult('get-again-result', { error: err.message }, true));
        }

        function testCreateCoupon() {
            const email = document.getElementById('test-email').value;

            fetch(API_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `action=create&email=${encodeURIComponent(email)}`
            })
            .then(r => r.text())
            .then(text => {
                try {
                    const data = JSON.parse(text);
                    displayResult('create-result', data);
                } catch (e) {
                    displayResult('create-result', { error: 'Parse error', raw: text }, true);
                }
            })
            .catch(err => displayResult('create-result', { error: err.message }, true));
        }

        function checkDatabase() {
            // Direct PHP check
            fetch('test_coupon.php?action=check_db')
            .then(r => r.json())
            .then(data => displayResult('db-result', data))
            .catch(err => displayResult('db-result', { error: err.message }, true));
        }
    </script>

<?php
// Server-side database check
if (isset($_GET['action']) && $_GET['action'] === 'check_db') {
    header('Content-Type: application/json');

    $conn = new mysqli("localhost", "root", "", "websach");
    if ($conn->connect_error) {
        echo json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]);
        exit;
    }

    // Check settings table
    $result = $conn->query("SELECT id, setting_key, setting_value FROM settings WHERE setting_key LIKE 'coupon_duration_%'");
    $rows = [];
    while ($row = $result->fetch_assoc()) {
        $rows[] = $row;
    }

    // Get all settings for reference
    $all = $conn->query("SELECT id, setting_key, setting_value FROM settings");
    $allRows = [];
    while ($row = $all->fetch_assoc()) {
        $allRows[] = $row;
    }

    echo json_encode([
        "success" => true,
        "coupon_duration_settings" => $rows,
        "all_settings" => $allRows
    ]);
    exit;
}
?>

</body>
</html>
