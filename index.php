<?php

include 'php/main.php';
session_start();

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Shop</title>
    <link href='./assets/img/iconlogo.jpg' rel='icon' type='image/x-icon' />
    <link rel="stylesheet" href="./assets/css/main.css">
    <link rel="stylesheet" href="./assets/css/rating.css">
    <link rel="stylesheet" href="./assets/css/home-responsive.css">
    <link rel="stylesheet" href="./assets/css/admin-responsive.css">
    <link rel="stylesheet" href="./assets/css/toast-message.css">
    <link rel="stylesheet" href="./assets/css/gioithieu.css">
    <link rel="stylesheet" href="./assets/css/chat-widget.css">
    <link rel="stylesheet" href="./assets/font/font-awesome-pro-v6-6.2.0/css/all.min.css"/>
</head>
<body>
    <header>
        <div class="header-middle">
            <div class="container">
                <div class="header-middle-left">
                    <div class="header-logo">
                        <a href="">
                            <img src="./assets/img/iconlogos.jpg" alt="" class="header-logo-img">
                        </a>
                    </div>
                </div>
                <div class="header-middle-center">
                    <form action="" class="form-search">
                        <span class="search-btn"><i class="fa-light fa-magnifying-glass"></i></span>
                        <input type="text" class="form-search-input" placeholder="Tìm kiếm sách giáo khoa..."
                            oninput="searchProducts()">
                        <button class="filter-btn"><i class="fa-light fa-filter-list"></i><span>Lọc</span></button>
                    </form>
                </div>
                <div class="header-middle-right">
                    <ul class="header-middle-right-list">
                        <li class="header-middle-right-item dnone open" onclick="openSearchMb()">
                            <div class="cart-icon-menu">
                                <i class="fa-light fa-magnifying-glass"></i>
                            </div>
                        </li>
                        <li class="header-middle-right-item close" onclick="closeSearchMb()">
                            <div class="cart-icon-menu">
                                <i class="fa-light fa-circle-xmark"></i>
                            </div>
                        </li>
                        <li class="header-middle-right-item dropdown open">
                            <i class="fa-light fa-user"></i>
                            <div class="auth-container">
                                <span class="text-dndk">Đăng nhập / Đăng ký</span>
                                <span class="text-tk">Tài khoản <i class="fa-sharp fa-solid fa-caret-down"></i></span>
                            </div>
                            <ul class="header-middle-right-menu">
                                <li><a id="login" href="javascript:;"><i class="fa-light fa-right-to-bracket"></i> Đăng nhập</a></li>
                                <li><a id="signup" href="javascript:;"><i class="fa-light fa-user-plus"></i> Đăng ký</a></li>
                            </ul>
                        </li>
                        <li class="header-middle-right-item open" onclick="openCart()">
                            <div class="cart-icon-menu">
                                <i class="fa-light fa-basket-shopping"></i>
                                <span class="count-product-cart">0</span>
                            </div>
                            <span>Giỏ hàng</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </header>
    <nav  class="header-bottom">
        <div align="center" class="container">
            <ul class="menu-list">
                <pre>    </pre>
                <li class="menu-list-item"><a href="" class="menu-link">Trang chủ</a></li>
                <li class="menu-list-item" onclick="showCategory('Lớp 10')"><a href="javascript:;" class="menu-link">Lớp 10</a></li>
                <li class="menu-list-item" onclick="showCategory('Lớp 11')"><a href="javascript:;" class="menu-link">Lớp 11</a></li>
                <li class="menu-list-item" onclick="showCategory('Lớp 12')"><a href="javascript:;" class="menu-link">Lớp 12</a></li>
                <li class="menu-list-item" onclick="showCategory('Sách khác')"><a href="javascript:;" class="menu-link">Sách khác</a></li>
                <li class="menu-list-item" onclick="showGioiThieu()"><a href="javascript:;" class="menu-link">Giới thiệu</a></li>
                <li class="menu-list-item" onclick="showTraCuu()"><a href="javascript:;" class="menu-link">Tra cứu đơn hàng</a></li>
            </ul>
        </div>
    </nav>
    <div class="advanced-search">
        <div class="container">
            <div class="advanced-search-category">
                <span>Phân loại </span>
                <select name="" id="advanced-search-category-select" onchange="searchProducts()">
                    <option>Tất cả</option>
                    <option>Lớp 10</option>
                    <option>Lớp 11</option>
                    <option>Lớp 12</option>
                    <option>Sách khác</option>
                </select>
            </div>
            <div class="advanced-search-price">
                <span>Giá từ</span>
                <input type="number" value="0" placeholder="tối thiểu" id="min-price" onchange="searchProducts()">
                <span>đến</span>
                <input type="number" placeholder="tối đa" id="max-price" onchange="searchProducts()">
                <button id="advanced-search-price-btn"><i class="fa-light fa-magnifying-glass-dollar"></i></button>
            </div>
            <div class="advanced-search-control">
                <button id="sort-ascending" onclick="searchProducts(1)"><i class="fa-regular fa-arrow-up-short-wide"></i></button>
                <button id="sort-descending" onclick="searchProducts(2)"><i class="fa-regular fa-arrow-down-wide-short"></i></button>
                <button id="reset-search" onclick="searchProducts(0)"><i class="fa-light fa-arrow-rotate-right"></i></button>
                <button onclick="closeSearchAdvanced()"><i class="fa-light fa-xmark"></i></button>
            </div>
        </div>
    </div>
    <main class="main-wrapper">
        <div class="container" id="trangchu">
            <div class="home-slider">
                <img src="./assets/img/banner-1.jpg" alt="">
                <img src="./assets/img/banner.png" alt="">
                <!-- <img src="./assets/img/banner-3.png" alt="">
                <img src="./assets/img/banner-4.png" alt="">
                <img src="./assets/img/banner-5.png" alt=""> -->
                <button class="prev-slide">&#10094;</button>
                <button class="next-slide">&#10095;</button>
            </div>
            <div class="home-service" id="home-service">
                <div class="home-service-item">
                    <div class="home-service-item-icon">
                        <i class="fa-light fa-person-carry-box"></i>
                    </div>
                    <div class="home-service-item-content">
                        <h4 class="home-service-item-content-h">GIAO HÀNG NHANH</h4>
                        <p class="home-service-item-content-desc">Cho tất cả đơn hàng</p>
                    </div>
                </div>
                <div class="home-service-item">
                    <div class="home-service-item-icon">
                        <i class="fa-light fa-shield-heart"></i>
                    </div>
                    <div class="home-service-item-content">
                        <h4 class="home-service-item-content-h">SẢN PHẨM CHÍNH HÃNG</h4>
                        <p class="home-service-item-content-desc">Cam kết chất lượng</p>
                    </div>
                </div>
                <div class="home-service-item">
                    <div class="home-service-item-icon">
                        <i class="fa-light fa-headset"></i>
                    </div>
                    <div class="home-service-item-content">
                        <h4 class="home-service-item-content-h">HỖ TRỢ 24/7</h4>
                        <p class="home-service-item-content-desc">Tất cả ngày trong tuần</p>
                    </div>
                </div>
                <div class="home-service-item">
                    <div class="home-service-item-icon">
                        <i class="fa-light fa-circle-dollar"></i>
                    </div>
                    <div class="home-service-item-content">
                        <h4 class="home-service-item-content-h">HOÀN LẠI TIỀN</h4>
                        <p class="home-service-item-content-desc">Nếu không hài lòng</p>
                    </div>
                </div>
            </div>
            <div class="home-title-block" id="home-title">
                <h2 class="home-title">Khám phá sách giáo khoa của chúng tôi</h2>
            </div>
            <!-- Ranking Tabs -->
            <div class="ranking-tabs" id="ranking-tabs" style="display: none;">
                <button class="ranking-tab active" data-sort="sold_count" onclick="showRanking('sold')">Bán chạy</button>
                <button class="ranking-tab" data-sort="like_count" onclick="showRanking('like')">Ưa thích</button>
                <button class="ranking-tab" data-sort="search_count" onclick="showRanking('search')">Tìm kiếm nhiều</button>
            </div>
            <div class="home-products" id="home-products">
            </div>
            <div class="page-nav" id="page-products">
                <ul class="page-nav-list">
                </ul>
            </div>
        </div>
        <div class="container" id="account-user">
            <div class="main-account">
                <div class="main-account-header">
                    <h3>Thông tin tài khoản của bạn</h3>
                    <p>Quản lý thông tin để bảo mật tài khoản</p>
                </div>
                <div class="main-account-body">
                    <div class="main-account-body-col">
                        <form action="" class="info-user">
                            <div class="form-group">
                                <label for="infoname" class="form-label">Họ và tên</label>
                                <input class="form-control" type="text" name="infoname" id="infoname" placeholder="">
                            </div>
                            <div class="form-group">
                                <label for="infophone" class="form-label">Số điện thoại</label>
                                <input class="form-control" type="text" name="infophone" id="infophone" disabled="true"
                                    placeholder="">
                            </div>
                            <div class="form-group">
                                <label for="infoemail" class="form-label">Email</label>
                                <input class="form-control" type="email" name="infoemail" id="infoemail"
                                    placeholder="Thêm địa chỉ email của bạn">
                                <span class="inforemail-error form-message"></span>
                            </div>
                            <div class="form-group">
                                <label for="infoaddress" class="form-label">Địa chỉ</label>
                                <input class="form-control" type="text" name="infoaddress" id="infoaddress"
                                    placeholder="Thêm địa chỉ giao hàng của bạn">
                            </div>
                        </form>
                    </div>
                    <div class="main-account-body-col">
                        <form action="" class="change-password">
                            <div class="form-group">
                                <label class="form-label w60">Mật khẩu hiện tại</label>
                                <input class="form-control" type="password" name="" id="password-cur-info"
                                    placeholder="Nhập mật khẩu hiện tại">
                                <span class="password-cur-info-error form-message"></span>
                            </div>
                            <div class="form-group">
                                <label class="form-label w60">Mật khẩu mới </label>
                                <input class="form-control" type="password" name="" id="password-after-info"
                                    placeholder="Nhập mật khẩu mới">
                                <span class="password-after-info-error form-message"></span>
                            </div>
                            <div class="form-group">
                                <label class="form-label w60">Xác nhận mật khẩu mới</label>
                                <input class="form-control" type="password" name="" id="password-comfirm-info"
                                    placeholder="Nhập lại mật khẩu mới">
                                <span class="password-after-comfirm-error form-message"></span>
                            </div>
                        </form>
                    </div>
                    <div class="main-account-body-row">
                        <div>
                            <button id="save-info-user" onclick="changeInformation()"><i
                                    class="fa-regular fa-floppy-disk"></i> Lưu thay đổi</button>
                        </div>
                        <div>
                            <button id="save-password" onclick="changePassword()"><i class="fa-regular fa-key"></i> Đổi
                                mật khẩu</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="container" id="order-history">
            <div class="main-account">
                <div class="main-account-header">
                    <h3>Quản lý đơn hàng của bạn</h3>
                    <p>Xem chi tiết, trạng thái của những đơn hàng đã đặt.</p>
                </div>
                <div class="order-history-section">
                    <div class="table">
                        <table width="100%">
                            <thead>
                                <tr>
                                    <td>Mã đơn</td>
                                    <td>Tên người nhận</td>
                                    <td>Ngày đặt</td>
                                    <td>Tổng tiền</td>
                                    <td>Trạng thái</td>
                                    <td>Thao tác</td>
                                </tr>
                            </thead>
                            <tbody id="showOrder">
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <div class="modal product-detail">
        <button class="modal-close close-popup"><i class="fa-thin fa-xmark"></i></button>
        <div class="modal-container mdl-cnt" id="product-detail-content">
        </div>
    </div>
    <div class="modal detail-order">
        <div class="modal-container">
            <h3 class="modal-container-title">CHI TIẾT ĐƠN HÀNG</h3>
            <button class="modal-close"><i class="fa-regular fa-xmark"></i></button>
            <div class="modal-detail-order">
            </div>
            <div class="modal-detail-bottom">               
            </div>
            </form>
        </div>
    </div>
    <!-- Modal hủy đơn hàng -->
    <div class="modal cancel-order-modal">
        <div class="modal-container">
            <h3 class="modal-container-title">HỦY ĐƠN HÀNG</h3>
            <button class="modal-close cancel-order-close"><i class="fa-regular fa-xmark"></i></button>
            <div class="cancel-order-content">
                <p class="cancel-order-warning">Bạn có chắc chắn muốn hủy đơn hàng này không?</p>
                <p class="cancel-order-note">Lưu ý: Sau khi hủy, đơn hàng sẽ không thể khôi phục.</p>
                <div class="cancel-order-form">
                    <div class="form-group">
                        <label class="form-label">Nhập "tôi xác nhận hủy" để xác nhận</label>
                        <input type="text" class="form-input" id="cancel-confirm-text" placeholder="Nhập text xác nhận">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Nhập mật khẩu của bạn</label>
                        <input type="password" class="form-input" id="cancel-password" placeholder="Nhập mật khẩu">
                    </div>
                    <input type="hidden" id="cancel-order-id" value="">
                    <button class="btn-cancel-order" onclick="confirmCancelOrder()">Xác nhận hủy</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal rating-modal">
        <div class="modal-container">
            <h3 class="modal-container-title">ĐÁNH GIÁ SẢN PHẨM</h3>
            <button class="modal-close" onclick="closeRatingModal()"><i class="fa-regular fa-xmark"></i></button>
            <div class="rating-modal-content">
                <div class="rating-product-info">
                    <img id="rating-product-img" src="" alt="">
                    <h4 id="rating-product-title"></h4>
                </div>
                <div class="rating-stars">
                    <span class="rating-label">Chọn đánh giá:</span>
                    <div class="stars">
                        <i class="fa-regular fa-star" data-rating="1"></i>
                        <i class="fa-regular fa-star" data-rating="2"></i>
                        <i class="fa-regular fa-star" data-rating="3"></i>
                        <i class="fa-regular fa-star" data-rating="4"></i>
                        <i class="fa-regular fa-star" data-rating="5"></i>
                    </div>
                    <span id="rating-value-text">0/5 sao</span>
                </div>
                <div class="rating-comment">
                    <span class="rating-label">Bình luận:</span>
                    <textarea id="rating-comment" placeholder="Nhập đánh giá của bạn..." maxlength="300"></textarea>
                    <span class="char-count">0/300 ký tự</span>
                </div>
                <input type="hidden" id="rating-product-id" value="">
                <input type="hidden" id="rating-order-id" value="">
                <button class="btn-submit-rating" onclick="submitRating()">Gửi đánh giá</button>
            </div>
        </div>
    </div>
    <div class="modal detail-order-product">
        <div class="modal-container">
            <button class="modal-close"><i class="fa-regular fa-xmark"></i></button>
            <div class="table">
                <table width="100%">
                    <thead>
                        <tr>
                            <td>Mã đơn</td>
                            <td>Số lượng</td>
                            <td>Đơn giá</td>
                            <td>Ngày đặt</td>
                        </tr>
                    </thead>
                    <tbody id="show-product-order-detail">
                    </tbody>
                </table>
            </div>
            </form>
        </div>
    </div>
    <div class="modal signup-login">
        <div class="modal-container">
            <button class="form-close" onclick="closeModal()"><i class="fa-regular fa-xmark"></i></button>
            <div class="forms mdl-cnt">
                <div class="form-content sign-up">
                    <h3 class="form-title">
                        Đăng ký tài khoản
                    </h3>
                    <p class="form-description">Đăng ký thành viên để mua hàng và nhận những ưu đãi đặc biệt từ chúng
                        tôi </p>
                    <form action="" class="signup-form">
                        <div class="form-group">
                            <label for="fullname" class="form-label">Tên đầy đủ</label>
                            <input id="fullname" name="fullname" type="text" placeholder="Nhập họ và tên"
                                class="form-control">
                            <span class="form-message-name form-message"></span>
                        </div>
                        <div class="form-group">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input id="phone" name="phone" type="text" placeholder="Nhập số điện thoại"
                                class="form-control">
                            <span class="form-message-phone form-message"></span>
                        </div>
                        <div class="form-group">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input id="password" name="password" type="password" placeholder="Nhập mật khẩu"
                                class="form-control">
                            <span class="form-message-password form-message"></span>
                        </div>
                        <div class="form-group">
                            <label for="password_confirmation" class="form-label">Nhập lại mật khẩu</label>
                            <input id="password_confirmation" name="password_confirmation"
                                placeholder="Nhập lại mật khẩu" type="password" class="form-control">
                            <span class="form-message-password-confi form-message"></span>
                        </div>
                        <div class="form-group">
                            <input class="checkbox" name="checkbox" required="" type="checkbox" id="checkbox-signup">
                            <label for="checkbox-signup" class="form-checkbox">Tôi đồng ý với <a href="#"
                                    title="chính sách trang web" target="_blank">chính sách trang web</a></label>
                            <p class="form-message-checkbox form-message"></p>
                        </div>
                        <button class="form-submit" name="submit" id="signup-button">Đăng ký</button>
                    </form>
                    <p class="change-login">Bạn đã có tài khoản ? <a href="javascript:;" class="login-link">Đăng nhập
                            ngay</a></p>
                </div>
                <div class="form-content login">
                    <h3 class="form-title">Đăng nhập tài khoản</h3>
                    <p class="form-description">Đăng nhập thành viên để mua hàng và nhận những ưu đãi đặc biệt từ chúng
                        tôi</p>
                    <form action="" class="login-form">
                        <div class="form-group">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input id="phone-login" name="phone" type="text" placeholder="Nhập số điện thoại"
                                class="form-control">
                            <span class="form-message phonelog"></span>
                        </div>
                        <div class="form-group">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input id="password-login" name="password" type="password" placeholder="Nhập mật khẩu"
                                class="form-control">
                            <span class="form-message-check-login form-message"></span>
                        </div>
                        <button class="form-submit" id="login-button">Đăng nhập</button>
                    </form>
                    <p class="change-login">Bạn chưa có tài khoản ? <a href="javascript:;" class="signup-link">Đăng kí
                            ngay</a><br><a href="javascript:;" class="forgot-password-link" onclick="showForgotPassword()">Quên mật khẩu</a></p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Forgot Password Modal -->
    <div class="modal signup-login forgot-password-modal" id="forgot-password-modal" onclick="closeForgotPasswordModal(event)">
        <div class="modal-container" onclick="event.stopPropagation()">
            <button class="form-close" onclick="closeForgotPassword()"><i class="fa-regular fa-xmark"></i></button>
            <div class="forms mdl-cnt">
                <div class="form-content login">
                    <h3 class="form-title">QUÊN MẬT KHẨU</h3>
                    <p class="form-description">Nhập email của bạn để lấy lại mật khẩu</p>
                    <form action="" class="login-form">
                        <div class="form-group">
                            <label for="forgot-email" class="form-label">Email</label>
                            <input id="forgot-email" name="forgot-email" type="email" placeholder="Nhập email của bạn" class="form-control">
                            <span class="form-message-forgot form-message"></span>
                        </div>
                        <button type="button" class="form-submit" id="forgot-password-btn">Gửi yêu cầu</button>
                    </form>
                    <p class="change-login"><a href="javascript:;" onclick="showLoginFromForgot()"> Quay lại đăng nhập</a></p>
                </div>
            </div>
        </div>
    </div>
    
    <div class="modal-cart">
        <div class="cart-container">
            <div class="cart-header">
                <h3 class="cart-header-title"><i class="fa-regular fa-basket-shopping-simple"></i> Giỏ hàng</h3>
                <button class="cart-close" onclick="closeCart()"><i class="fa-sharp fa-solid fa-xmark"></i></button>
            </div>
            <div class="cart-body">
                <div class="gio-hang-trong">
                    <i class="fa-thin fa-cart-xmark"></i>
                    <p>Không có sản phẩm nào trong giỏ hàng của bạn</p>
                </div>
                <ul class="cart-list">
                </ul>
            </div>
            <div class="cart-footer">
                <div class="cart-total-price">
                    <p class="text-tt">Tổng tiền:</p>
                    <p class="text-price">0đ</p>
                </div>
                <div class="cart-footer-payment">
                    <button class="them-sach"><i class="fa-regular fa-plus"></i> Thêm sách</button>
                    <button class="thanh-toan disabled">Thanh toán</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal detail-order">
        <div class="modal-container mdl-cnt">
            <h3 class="modal-container-title">CHI TIẾT ĐƠN HÀNG</h3>
            <button class="form-close" onclick="closeModal()"><i class="fa-regular fa-xmark"></i></button>
            <div class="modal-detail-order">
            </div>
            <div class="modal-detail-bottom">
            </div>
        </div>
    </div>
    <div class="container" id="gioithieu" style="display: none; overflow: hidden; scroll-behavior: auto;">
        <div class="introduction-container">
            <section class="about-us">
                <h1 class="section-title">Chào Mừng Đến Với Thư Viện Sách Giáo Khoa THPT Trực Tuyến</h1>
                <p>Trang web của chúng tôi được thiết kế để cung cấp đầy đủ các sách giáo khoa và tài liệu học tập cho học sinh THPT, giúp các em dễ dàng tiếp cận kiến thức và chuẩn bị tốt cho các kỳ thi. Với sứ mệnh trở thành người bạn đồng hành tin cậy trong hành trình học tập, chúng tôi cam kết mang đến những tài liệu chất lượng và phù hợp nhất.</p>
            </section>
            <section class="book-categories">
                <h2 class="section-title">Danh Mục Sách Giáo Khoa</h2>
                <div class="categories-list">
                    <div class="category-item">
                        <h3>Toán</h3>
                        <p>Các sách giáo khoa và tài liệu bài tập giúp học sinh nắm vững kiến thức Toán học từ cơ bản đến nâng cao.</p>
                    </div>
                    <div class="category-item">
                        <h3>Ngữ Văn</h3>
                        <p>Tài liệu văn học đa dạng, bao gồm phân tích văn bản, tác phẩm văn học và bài giảng chi tiết.</p>
                    </div>
                    <div class="category-item">
                        <h3>Vật Lý</h3>
                        <p>Sách giáo khoa và tài liệu thực hành Vật lý giúp học sinh hiểu rõ các nguyên lý khoa học và ứng dụng thực tiễn.</p>
                    </div>
                    <div class="category-item">
                        <h3>Hóa Học</h3>
                        <p>Các tài liệu học tập từ cơ bản đến chuyên sâu, giúp học sinh khám phá thế giới hóa học phong phú và thú vị.</p>
                    </div>
                    <div class="category-item">
                        <h3>Sinh Học</h3>
                        <p>Sách giáo khoa và tài liệu bài tập giúp học sinh nắm bắt các kiến thức sinh học và kỹ năng thực hành.</p>
                    </div>
                </div>
            </section>

            <section class="features">
                <h2 class="section-title">Tính Năng Nổi Bật</h2>
                <ul class="features-list">
                    <li><strong>Tìm kiếm sách dễ dàng:</strong> Tìm kiếm nhanh chóng và chính xác với bộ lọc thông minh.</li>
                    <li><strong>Đánh giá và nhận xét từ người dùng:</strong> Xem đánh giá từ cộng đồng học sinh để lựa chọn sách phù hợp.</li>
                    <li><strong>Đọc sách trực tuyến:</strong> Đọc sách trực tuyến mọi lúc mọi nơi, không cần tải xuống.</li>
                    <li><strong>Tài liệu học tập bổ sung:</strong> Truy cập các bài giảng, đề thi, và tài liệu tham khảo hỗ trợ học tập.</li>
                </ul>
            </section>

            <section class="additional-resources">
                <h2 class="section-title">Tài Liệu Và Tài Nguyên Bổ Sung</h2>
                <p>Chúng tôi cung cấp không chỉ sách giáo khoa mà còn có rất nhiều tài liệu bổ trợ hữu ích như bài giảng, bài tập, đề thi và các tài liệu tham khảo giúp học sinh nâng cao kiến thức và kỹ năng học tập.</p>
            </section>

            <section class="how-to-use">
                <h2 class="section-title">Hướng Dẫn Sử Dụng</h2>
                <p>Để bắt đầu sử dụng, bạn có thể tìm kiếm sách mình cần bằng cách nhập tên sách hoặc môn học vào thanh tìm kiếm. Đừng quên tạo tài khoản để lưu trữ sách yêu thích và nhận các đề xuất phù hợp với nhu cầu học tập của bạn!</p>
            </section>

            <section class="legal-info">
                <h2 class="section-title">Thông Tin Pháp Lý Và Quyền Sử Dụng</h2>
                <p>Tất cả các tài liệu trên trang web này đều tuân thủ theo quy định về bản quyền và quyền sử dụng. Vui lòng không sao chép hoặc phân phối lại tài liệu khi chưa có sự cho phép từ chúng tôi. Mọi hành vi vi phạm sẽ bị xử lý theo pháp luật.</p>
            </section>

            <section class="special-offers">
                <h2 class="section-title">Ưu Đãi Và Chính Sách Đặc Biệt</h2>
                <p>Đăng ký thành viên ngay hôm nay để nhận được các ưu đãi đặc biệt và giảm giá dành riêng cho học sinh và giáo viên! Hãy tham gia cộng đồng học tập của chúng tôi và nhận những quyền lợi đặc biệt.</p>
            </section>
        </div>
    </div>
    <div class="container" id="tracuu" style="display: none; overflow: hidden; scroll-behavior: auto;">
        <div class="home-title-block" id="home-title">
            <h1 class="home-title">Tra cứu đơn hàng</h1><br>
        </div>
        <form class="form-tracuu">
            <input type="number" class="tracuudon" placeholder="Nhập SĐT đặt hàng...">
            <button class="filter-don">
                <span>Tra cứu</span>
                <i class="fa-solid fa-arrow-right"></i>
            </button>
        </form>
        <div class="container" align="center" >
            <div id="showOrdersdt"></div>
        </div>
    </div>
    <footer class="footer">
        <div class="container">
            <div class="footer-top">
                <div class="footer-top-content">
                    <div class="footer-top-img">
                        <img src="./assets/img/iconlogos.jpg" alt="">
                    </div>
                    <div class="footer-top-subbox">
                        <div class="footer-top-subs">
                            <h2 class="footer-top-subs-title">Đăng ký nhận mã giảm giá</h2>
                            <p class="footer-top-subs-text" id="footer-discount-text">Nhận mã giảm giá <span id="footer-discount-percent">10</span>% từ chúng tôi</p>
                        </div>
                        <form class="form-ground" id="subscribe-form">
                            <input type="email" id="subscribe-email" class="form-ground-input" placeholder="Nhập email của bạn">
                            <button type="button" class="form-ground-btn" id="subscribe-btn">
                                <span>ĐĂNG KÝ</span>
                                <i class="fa-solid fa-arrow-right"></i>
                            </button>
                        </form>
                        <span id="subscribe-message" class="form-message" style="color: red; font-size: 12px; display: block; margin-top: 5px;"></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="widget-area">
            <div class="container">
                <div class="widget-row">
                    <div class="widget-row-col-1">
                        <h3 class="widget-title">Về chúng tôi</h3>
                        <div class="widget-row-col-content">
                            <p>Book Shop là thương hiệu được thành lập vào năm 2026 với tiêu chí đặt chất lượng sản phẩm lên hàng đầu.</p>
                        </div>
                        <div class="widget-social">
                            <div class="widget-social-item">
                                <a href="">
                                    <i class="fab fa-facebook-f"></i>
                                </a>
                            </div>
                            <div class="widget-social-item">
                                <a href="">
                                    <i class="fab fa-twitter"></i>
                                </a>
                            </div>
                            <div class="widget-social-item">
                                <a href="">
                                    <i class="fab fa-linkedin-in"></i>
                                </a>
                            </div>
                            <div class="widget-social-item">
                                <a href="">
                                    <i class="fab fa-whatsapp"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="widget-row-col">
                        <h3 class="widget-title">Sách giáo khoa</h3>
                        <ul class="widget-contact">
                            <li class="widget-contact-item">
                                <a href="">
                                    <i class="fa-regular fa-arrow-right"></i>
                                    <span>Lớp 10</span>
                                </a>
                            </li>
                            <li class="widget-contact-item">
                                <a href="">
                                    <i class="fa-regular fa-arrow-right"></i>
                                    <span>Lớp 11</span>
                                </a>
                            </li>
                            <li class="widget-contact-item">
                                <a href="">
                                    <i class="fa-regular fa-arrow-right"></i>
                                    <span>Lớp 12</span>
                                </a>
                            </li>
                            <li class="widget-contact-item">
                                <a href="">
                                    <i class="fa-regular fa-arrow-right"></i>
                                    <span>Sách giáo khoa khác</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                    <div class="widget-row-col-1">
                        <h3 class="widget-title">Liên hệ</h3>
                        <div class="contact">
                            <div class="contact-item">
                                <div class="contact-item-icon">
                                    <i class="fa-regular fa-location-dot"></i>
                                </div>
                                <div class="contact-content">
                                    <span>Phường Từ Liêm, TP Hà Nội</span>
                                </div>
                            </div>
                            <div class="contact-item">
                                <div class="contact-item-icon">
                                    <i class="fa-regular fa-phone"></i>
                                </div>
                                <div class="contact-content contact-item-phone">
                                    <span>0123 456 789</span>
                                    <br>
                                    <span>0123 456 789</span>
                                </div>
                            </div>
                            <div class="contact-item">
                                <div class="contact-item-icon">
                                    <i class="fa-regular fa-envelope"></i>
                                </div>
                                <div class="contact-content conatct-item-email">
                                    <span>abcd@ut.edu.vn</span><br />
                                    <span>abcd@ut.edu.vn</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    <div class="copyright-wrap">
        <div class="container">
            <div class="copyright-content">
                <p>Copyright 2026 Book Shop. All Rights Reserved.</p>
            </div>
        </div>
    </div>
    <div class="back-to-top">
        <a href="#"><i class="fa-regular fa-arrow-up"></i></a>
    </div>
    <div class="checkout-page">
        <div class="checkout-header">
            <div class="checkout-return">
                <button onclick="closecheckout()"><i class="fa-regular fa-chevron-left"></i></button>
            </div>
            <h2 class="checkout-title">Thanh toán</h2>
        </div>
        <main class="checkout-section container">
            <div class="checkout-col-left">
                <div class="checkout-row">
                    <div class="checkout-col-title">
                        Thông tin đơn hàng
                    </div>
                    <div class="checkout-col-content">
                        <div class="content-group">
                            <p class="checkout-content-label">Hình thức giao nhận</p>
                            <div class="checkout-type-order">
                                <button class="type-order-btn active" id="giaotannoi">
                                    <i class="fa-duotone fa-moped"
                                        style="--fa-secondary-opacity: 1.0; --fa-primary-color: dodgerblue; --fa-secondary-color: #ffb100;"></i>
                                    Giao tận nơi
                                </button>
                                <button class="type-order-btn" id="tudenlay">
                                    <i class="fa-duotone fa-box-heart"
                                        style="--fa-secondary-opacity: 1.0; --fa-primary-color: pink; --fa-secondary-color: palevioletred;"></i>
                                    Tự đến lấy
                                </button>
                            </div>
                        </div>
                        <div class="content-group">
                            <p class="checkout-content-label">Ngày giao hàng</p>
                            <div class="date-order">
                            </div>
                        </div>
                        <div class="content-group chk-ship" id="giaotannoi-group">
                            <p class="checkout-content-label">Thời gian giao hàng</p>
                            <div class="delivery-time">
                                <input type="radio" name="giaongay" id="giaongay" class="radio">
                                <label for="giaongay">Giao ngay khi xong</label>
                            </div>
                            <div class="delivery-time">
                                <input type="radio" name="giaongay" id="deliverytime" class="radio">
                                <label for="deliverytime">Giao vào giờ</label>
                                <select class="choise-time">
                                    <option data-hours="08" value="08:00" selected="selected">08:00 - 09:00</option>

                                    <option data-hours="09" value="09:00">09:00 - 10:00</option>

                                    <option data-hours="10" value="10:00"> 10:00 - 11:00</option>

                                    <option data-hours="11" value="11:00"> 11:00 - 12:00</option>

                                    <option data-hours="12" value="12:00"> 12:00 - 13:00</option>

                                    <option data-hours="13" value="13:00"> 13:00 - 14:00</option>

                                    <option data-hours="14" value="14:00"> 14:00 - 15:00</option>

                                    <option data-hours="15" value="15:00"> 15:00 - 16:00</option>

                                    <option data-hours="16" value="16:00"> 16:00 - 17:00</option>

                                    <option data-hours="17" value="17:00"> 17:00 - 18:00</option>

                                    <option data-hours="18" value="18:00"> 18:00 - 19:00</option>

                                    <option data-hours="19" value="19:00"> 19:00 - 20:00</option>

                                    <option data-hours="20" value="20:00"> 20:00 - 21:00</option>

                                    <option data-hours="21" value="21:00"> 21:00 - 22:00</option>

                                </select>
                            </div>
                        </div>
                        <div class="content-group" id="tudenlay-group">
                            <p class="checkout-content-label">Lấy hàng tại chi nhánh</p>
                            <div class="delivery-time">
                                <input type="radio" name="chinhanh" id="chinhanh-1" class="radio">
                                <label for="chinhanh-1">Phường Từ Liêm, TP Hà Nội</label>
                            </div>
                            <div class="delivery-time">
                                <input type="radio" name="chinhanh" id="chinhanh-2" class="radio">
                                <label for="chinhanh-2">Quận Gò Vấp, Thành phố Hồ Chí Minh</label>
                            </div>
                        </div>
                        <div class="content-group">
                            <p class="checkout-content-label">Ghi chú đơn hàng</p>
                            <textarea type="text" class="note-order" placeholder="Nhập ghi chú"></textarea>
                        </div>
                    </div>
                </div>
                <div class="checkout-row">
                    <div class="checkout-col-title">
                        Thông tin người nhận
                    </div>
                    <div class="checkout-col-content">
                        <div class="content-group">
                            <form action="" class="info-nhan-hang">
                                <div class="form-group">
                                    <input id="tennguoinhan" name="tennguoinhan" type="text"
                                        placeholder="Tên người nhận" class="form-control">
                                    <span class="form-message"></span>
                                </div>
                                <div class="form-group">
                                    <input id="sdtnhan" name="sdtnhan" type="text" placeholder="Số điện thoại nhận hàng"
                                        class="form-control">
                                    <span class="form-message"></span>
                                </div>
                                <div class="form-group">
                                    <input id="diachinhan" name="diachinhan" type="text" placeholder="Địa chỉ nhận hàng"
                                        class="form-control chk-ship">
                                    <span class="form-message"></span>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="checkout-col-right">
                <p class="checkout-content-label">Đơn hàng</p>
                <div class="bill-total" id="list-order-checkout">
                </div>
                <div class="coupon-section">
                    <p class="checkout-content-label">Mã giảm giá</p>
                    <div class="coupon-input-group">
                        <input type="text" id="coupon-code" class="coupon-input" placeholder="Nhập mã giảm giá (6 số)" maxlength="6">
                        <button type="button" id="apply-coupon-btn" class="apply-coupon-btn">Áp dụng</button>
                    </div>
                    <div id="coupon-message" class="coupon-message"></div>
                    <div id="discount-display" class="discount-display" style="display: none;">
                        <span class="discount-label">Giảm giá:</span>
                        <span class="discount-value" id="discount-amount">0</span>
                    </div>
                </div>
                <div class="bill-payment">
                    <div class="total-bill-order">
                    </div>
                    <div class="policy-note">
                        Bằng việc bấm vào nút “Đặt hàng”, tôi đồng ý với
                        <a href="#" target="_blank">chính sách hoạt động</a>
                        của chúng tôi.
                    </div>
                </div>
                <div class="total-checkout">
                    <div class="text">Tổng tiền</div>
                    <div class="price-bill">
                        <div class="price-final" id="checkout-cart-price-final">0</div>
                    </div>
                </div>
                <button class="complete-checkout-btn">Đặt hàng</button>
            </div>
        </main>
    </div>
    <div id="toast"></div>
    <script src="./js/initialization.js?v=2"></script>
    <script src="./js/main.js?v=8"></script>
    <script src="./js/rating.js"></script>
    <script src="./js/checkout.js?v=2"></script>
    <script src="./js/checkorder.js"></script>
    <script src="./js/toast-message.js"></script>
    <script src="./js/chat-widget.js"></script>
    <script>
        createProduct();
        createAdminAccount();
        createOrders();
        createOrderDetails();
        // Lấy thông tin tài khoản đăng nhập
let currentUser = localStorage.getItem("currentuser") ? JSON.parse(localStorage.getItem("currentuser")) : null;

// Lấy danh sách đơn hàng từ localStorage
let orders = localStorage.getItem("order") ? JSON.parse(localStorage.getItem("order")) : [];

// Nếu có tài khoản đăng nhập, lọc danh sách đơn hàng theo tài khoản đó
if (currentUser) {
    orders = orders.filter(order => order.khachhang === currentUser.phone);
}
        showOrder(orders);
        
        // Load footer discount percentage and update footer text
        function loadFooterDiscount() {
            // First check localStorage
            let storedDiscount = localStorage.getItem('footer_discount_percent');
            if (storedDiscount) {
                document.getElementById('footer-discount-percent').textContent = storedDiscount;
            }
            // Then fetch from server to get latest value
            fetch('api/coupon.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=get_default_discount'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('footer-discount-percent').textContent = data.discount_percent;
                    localStorage.setItem('footer_discount_percent', data.discount_percent);
                }
            })
            .catch(error => {
                console.error('Error loading footer discount:', error);
            });
        }
        loadFooterDiscount();
    </script>
</body>
</html>