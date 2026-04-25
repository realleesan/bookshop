-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th9 09, 2024 lúc 11:10 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `websach`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart`
--

CREATE TABLE `cart` (
  `idcart` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `note` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order`
--

CREATE TABLE `order` (
  `id` varchar(255) NOT NULL,
  `khachhang` varchar(255) NOT NULL,
  `hinhthucgiao` varchar(255) NOT NULL,
  `ngaygiaohang` varchar(255) NOT NULL,
  `thoigiangiao` varchar(255) NOT NULL,
  `ghichu` text DEFAULT NULL,
  `tenguoinhan` varchar(255) NOT NULL,
  `sdtnhan` varchar(20) NOT NULL,
  `diachinhan` varchar(255) NOT NULL,
  `thoigiandat` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  `tongtien` int(225) NOT NULL,
  `trangthai` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `order`
--

INSERT INTO `order` (`id`, `khachhang`, `hinhthucgiao`, `ngaygiaohang`, `thoigiangiao`, `ghichu`, `tenguoinhan`, `sdtnhan`, `diachinhan`, `thoigiandat`, `tongtien`, `trangthai`) VALUES
('DH1', '0123456789', 'Tự đến lấy', 'Wed Aug 28 2024 14:08:06 GMT+0700 (Giờ Đông Dương)', '', '', 'Thiên', '0123456789', 'Quận Gò Vấp, Thành phố Hồ Chí Minh', '2024-08-27T07:08:28.046Z', 1110000, 1),
('DH2', '098321', 'Giao tận nơi', 'Mon Sep 09 2024 16:04:51 GMT+0700 (Giờ Đông Dương)', '08:00', '', 'Châu', '04321', 'Gò Vấp', '2024-09-09T09:05:15.212Z', 150000, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orderdetails`
--

CREATE TABLE `orderdetails` (
  `id` int(11) NOT NULL,
  `madon` varchar(255) NOT NULL,
  `product_id` int(11) NOT NULL,
  `note` varchar(255) NOT NULL,
  `product_price` int(11) NOT NULL,
  `soluong` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `orderdetails`
--

INSERT INTO `orderdetails` (`id`, `madon`, `product_id`, `note`, `product_price`, `soluong`) VALUES
(53, 'DH1', 13, 'Không có ghi chú', 120000, 1),
(54, 'DH1', 14, 'Không có ghi chú', 200000, 1),
(55, 'DH1', 12, 'Không có ghi chú', 150000, 4),
(56, 'DH1', 11, 'Không có ghi chú', 120000, 1),
(57, 'DH1', 15, 'Không có ghi chú', 70000, 1),
(58, 'DH2', 12, 'Không có ghi chú', 150000, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `title` varchar(255) NOT NULL,
  `img` varchar(255) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `price` int(225) NOT NULL,
  `describes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `status`, `title`, `img`, `category`, `price`, `describes`) VALUES

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `fullname` varchar(255) NOT NULL,
  `phone` text NOT NULL,
  `password` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `join_date` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  `userType` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `fullname`, `phone`, `password`, `address`, `email`, `status`, `join_date`, `userType`) VALUES
(1, 'Đỗ Nguyễn Thiên', '0123456789', '111111', 'Quận 12, Tp Hồ Chí Minh', 'dntht29@gmail.com', 1, '2024-08-20 13:08:37', 1),
(25, 'Nguyễn Ngọc Minh Châu', '095421', '111111', '', '', 1, '2024-09-09T09:04:38.667Z', 0);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`idcart`);

--
-- Chỉ mục cho bảng `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD PRIMARY KEY (`id`),
  ADD KEY `madon` (`madon`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `cart`
--
ALTER TABLE `cart`
  MODIFY `idcart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT cho bảng `orderdetails`
--
ALTER TABLE `orderdetails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`madon`) REFERENCES `order` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
