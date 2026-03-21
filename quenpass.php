<?php
$thongbao = "";

if (isset($_POST['btn1'])) {
    $email = trim(strip_tags($_POST['email'])); // Tiếp nhận email và loại bỏ HTML tags

    // Kiểm tra định dạng email
    if (filter_var($email, FILTER_VALIDATE_EMAIL) === false) {
        $thongbao .= "Email không đúng <br>";
    }

    // Kiểm tra email có phải là thành viên không
    require_once 'php/config.php';
    $sql = "SELECT password FROM users WHERE email = '{$email}'";
    $kq = $conn->query($sql);
    $row = $kq->fetch_row();  // Retrieve the row with the password

    if (!$row) {
        $thongbao .= "Email này không phải là thành viên <br>";
    } else {
        $pass_hien_tai = $row[0]; // Get the existing password

        // Include PHPMailer files
        require_once 'PHPMailer-master/src/PHPMailer.php';
        require_once 'PHPMailer-master/src/SMTP.php';
        require_once 'PHPMailer-master/src/Exception.php';

        $mail = new PHPMailer\PHPMailer\PHPMailer(true);
        try {
            $mail->SMTPDebug = 0; //chế độ full debug, khi mọi thứ ok thì chỉnh lại 0
            $mail->isSMTP(); // Set mailer to use SMTP
            $mail->Host = 'smtp.gmail.com'; // Server gửi thư
            $mail->SMTPAuth = true;
            $mail->Username = 'dnthien29@gmail.com'; // ví dụ: abc@gmail.com
            $mail->Password = 'hzgq qlof itie bbyz'; // Mật khẩu ứng dụng tạo từ Google
            $mail->SMTPSecure = 'ssl'; //TLS hoặc `ssl`
            $mail->Port = 465; // 587 hoặc 465
            $mail->CharSet = "UTF-8";
            $mail->smtpConnect([
                "ssl" => [
                    "verify_peer" => false,
                    "verify_peer_name" => false,
                    "allow_self_signed" => true
                ]
            ]);

            //Khai báo người gửi và người nhận mail
            $mail->setFrom('dnthien29@gmail.com', 'Ban quản trị Website BOOK SHOP (UTH)');
            $mail->addAddress("{$email}", 'Quý khách');
            $mail->isHTML(true); // nội dung của email có mã HTML
            $mail->Subject = 'Mật khẩu hiện tại của bạn';
            $mail->Body = "Đây là mật khẩu hiện tại của bạn: <b>{$pass_hien_tai}</b>";
            $mail->send();
            $thongbao .= "Đã gửi password đến mail thành công<br>";
        } catch (Exception $e) {
            $thongbao .= "Lỗi khi gửi thư: " . $mail->ErrorInfo;
        }
    }
}
?>

<?php if ($thongbao != "") { ?>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" rel="stylesheet">
<div class="col-8 m-auto">
    <div class="alert alert-danger mt-5 text-center">
        <?= $thongbao ?>
        <button class="btn btn-primary" onclick="history.back()">Trở lại</button>
        <a href="http://localhost/websach/" class="btn btn-info">Trang chủ</a>
    </div>
</div>
<?php exit(); } ?>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" rel="stylesheet">
<form action="" method="post" class="col-5 m-auto bg-secondary p-2 text-white">
    <div class="form-group">
        <h4 class="border-bottom pb-2">QUÊN MẬT KHẨU</h4>
        <label for="email">Nhập email</label>
        <input class="form-control" name="email" type="email">
    </div>
    <div class="form-group">
        <button type="submit" name="btn1" class="btn btn-primary">Gửi yêu cầu</button>
    </div>
</form>
