<?php
// Test trực tiếp API coupon.php

echo "<h2>Test API Coupon Duration</h2>";

// Test 1: Get current duration
echo "<h3>1. Get Current Duration</h3>";
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'https://odin-unloaned-sinuately.ngrok-free.dev/websach/websach/api/coupon.php');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, 'action=get_coupon_duration');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response1 = curl_exec($ch);
$httpcode1 = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo "HTTP Code: $httpcode1<br>";
echo "Response:<pre>";
print_r(json_decode($response1, true));
echo "</pre>";
echo "Raw: $response1<br><hr>";

// Test 2: Update duration
echo "<h3>2. Update Duration (0h 0m 10s)</h3>";
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'https://odin-unloaned-sinuately.ngrok-free.dev/websach/websach/api/coupon.php');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, 'action=update_coupon_duration&hours=0&minutes=0&seconds=10');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response2 = curl_exec($ch);
$httpcode2 = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo "HTTP Code: $httpcode2<br>";
echo "Response:<pre>";
print_r(json_decode($response2, true));
echo "</pre>";
echo "Raw: $response2<br><hr>";

// Test 3: Get again to verify
echo "<h3>3. Verify Update</h3>";
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'https://odin-unloaned-sinuately.ngrok-free.dev/websach/websach/api/coupon.php');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, 'action=get_coupon_duration');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response3 = curl_exec($ch);
$httpcode3 = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo "HTTP Code: $httpcode3<br>";
echo "Response:<pre>";
print_r(json_decode($response3, true));
echo "</pre>";
echo "Raw: $response3<br><hr>";

// Check if update worked
$data3 = json_decode($response3, true);
if ($data3['seconds'] == 10 && $data3['minutes'] == 0) {
    echo "<h2 style='color: green;'>✅ SUCCESS: Update worked!</h2>";
} else {
    echo "<h2 style='color: red;'>❌ FAILED: Still showing old values</h2>";
}
