-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th4 04, 2026 lúc 04:11 PM
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

--
-- Đang đổ dữ liệu cho bảng `cart`
--

INSERT INTO `cart` (`idcart`, `user_id`, `product_id`, `quantity`, `note`) VALUES
(48, 47, 20, 1, 'Không có ghi chú');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chat_conversations`
--

CREATE TABLE `chat_conversations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `last_message_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `unread_count` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chat_conversations`
--

INSERT INTO `chat_conversations` (`id`, `user_id`, `last_message_at`, `unread_count`) VALUES
(29, 47, '2026-04-01 16:28:10', 0),
(32, 48, '2026-04-02 16:43:54', 0),
(37, 46, '2026-04-02 16:47:39', 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chat_messages`
--

CREATE TABLE `chat_messages` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `sender_type` enum('user','admin') NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chat_messages`
--

INSERT INTO `chat_messages` (`id`, `user_id`, `message`, `sender_type`, `is_read`, `created_at`) VALUES
(29, 47, 'mmmmmmmm', 'user', 1, '2026-04-01 16:27:45'),
(30, 47, 'hello', 'admin', 0, '2026-04-01 16:28:00'),
(31, 47, 'bạn cần shop giúp gì ạ', 'admin', 0, '2026-04-01 16:28:10'),
(32, 48, 'hihi', 'user', 1, '2026-04-02 16:41:14'),
(33, 48, 'em đang cần j ạ', 'admin', 0, '2026-04-02 16:41:50'),
(34, 48, 'dạ e cần tiền ạ', 'user', 1, '2026-04-02 16:42:45'),
(35, 48, ':))', 'admin', 0, '2026-04-02 16:43:23'),
(36, 48, 'e cần bnhieu', 'admin', 0, '2026-04-02 16:43:37'),
(37, 46, 'e ơi, sách nhà e sao lại cũ thế, anh nhận hàng thấy rách cả trang bìa, shop e làm ăn kiểu gì đấy, a thất vọng về shop lăm 😡😡😡😡', 'user', 1, '2026-04-02 16:43:42'),
(38, 48, 'cầm 5 tỷ và tránh xa con trai t ra', 'user', 1, '2026-04-02 16:43:54'),
(39, 46, 'shop ko thèm phản hồi luôn mà', 'user', 1, '2026-04-02 16:44:11'),
(40, 46, 'e có thể chụp cho shop sp dc k ạ', 'admin', 0, '2026-04-02 16:44:17'),
(41, 46, 'đồ ko cs trách nhiệm', 'user', 1, '2026-04-02 16:44:19'),
(42, 46, 'e cứ từ từ, làm j phải nóng vội v e', 'admin', 0, '2026-04-02 16:44:35'),
(43, 46, 'dùng máy tính chụp = mắt à', 'user', 1, '2026-04-02 16:44:49'),
(44, 46, 'ko thèm rep luôn, shop làm ăn quá chán', 'user', 1, '2026-04-02 16:47:19'),
(45, 46, 'làm ăn đàng hoàng đi shop', 'user', 1, '2026-04-02 16:47:39');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupons`
--

CREATE TABLE `coupons` (
  `id` int(11) NOT NULL,
  `code` varchar(6) NOT NULL,
  `discount_percent` int(11) NOT NULL DEFAULT 10,
  `email` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `coupons`
--

INSERT INTO `coupons` (`id`, `code`, `discount_percent`, `email`, `created_at`, `expires_at`, `is_used`) VALUES
(9, '309317', 33, 'realleesan@gmail.com', '2026-04-01 10:44:25', '2026-05-01 05:44:25', 1),
(10, '942690', 33, 'trangthubui918@gmail.com', '2026-04-01 13:10:06', '2026-05-01 08:10:06', 0),
(11, '502315', 33, 'trangthubui918@gmail.com', '2026-04-01 13:10:24', '2026-05-01 08:10:24', 1),
(12, '717691', 33, 'trangthubui918@gmail.com', '2026-04-01 13:38:11', '2026-05-01 08:38:11', 1),
(13, '783980', 33, 'chuthimytam9a1920@gmail.com', '2026-04-02 23:14:22', '2026-05-02 18:14:22', 0),
(14, '364404', 33, 'chuthimytam9a1920@gmail.com', '2026-04-02 23:15:58', '2026-05-02 18:15:58', 0),
(15, '289477', 33, 'chuthimytam9a1920@gmail.com', '2026-04-02 23:16:39', '2026-05-02 18:16:39', 1);

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
  `thoigiandat` timestamp NOT NULL DEFAULT current_timestamp(),
  `tongtien` int(225) NOT NULL,
  `trangthai` int(11) NOT NULL,
  `phiVanChuyen` int(11) DEFAULT 0,
  `giamGia` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `order`
--

INSERT INTO `order` (`id`, `khachhang`, `hinhthucgiao`, `ngaygiaohang`, `thoigiangiao`, `ghichu`, `tenguoinhan`, `sdtnhan`, `diachinhan`, `thoigiandat`, `tongtien`, `trangthai`, `phiVanChuyen`, `giamGia`) VALUES
('DH1', '0123456789', 'Giao tận nơi', 'Thu Apr 02 2026 13:08:05 GMT+0700 (Giờ Đông Dương)', 'Giao ngay khi xong', '', 'Tmu', '0997492765', 'Trường đại học thương mại', '2026-03-31 23:10:08', 70000, 2, 30000, 0),
('DH10', '0364736820', 'Giao tận nơi', 'Thu Apr 02 2026 23:16:51 GMT+0700 (Giờ Đông Dương)', 'Giao ngay khi xong', '', 'suzy', '1111111111', 'hà nội', '2026-04-02 09:17:25', 62310, 0, 30000, 30690),
('DH11', '0337596806', 'Giao tận nơi', 'Thu Apr 02 2026 23:51:54 GMT+0700 (Indochina Time)', 'Giao ngay khi xong', '', 'Bùi Thu Trang', '0337596806', '123 Hồ Tùng Mậu', '2026-04-02 09:52:04', 230000, 0, 30000, 0),
('DH12', '0337596806', 'Giao tận nơi', 'Fri Apr 03 2026 23:52:31 GMT+0700 (Indochina Time)', 'Giao ngay khi xong', '', 'Bùi Thu Trang', '0337596806', '123 Hồ Tùng Mậu', '2026-04-02 09:52:41', 230000, 0, 30000, 0),
('DH13', '0337596806', 'Giao tận nơi', 'Thu Apr 02 2026 23:57:12 GMT+0700 (Indochina Time)', 'Giao ngay khi xong', '', 'Bùi Thu Trang', '0337596806', '123 Hồ Tùng Mậu', '2026-04-02 09:57:20', 60000, 0, 30000, 0),
('DH2', '0337596806', 'Giao tận nơi', 'Thu Apr 02 2026 13:15:34 GMT+0700 (Indochina Time)', 'Giao ngay khi xong', '', 'Bùi Thu Trang', '0337596806', '123 Hồ Tùng Mậu', '2026-03-31 23:16:02', 55000, 2, 30000, 0),
('DH3', '0337596806', 'Giao tận nơi', 'Thu Apr 02 2026 13:38:37 GMT+0700 (Indochina Time)', 'Giao ngay khi xong', '', 'Bùi Thu Trang', '0337596806', '123 Hồ Tùng Mậu', '2026-03-31 23:38:59', 355100, 3, 30000, 174900),
('DH4', '0987654321', 'Giao tận nơi', 'Wed Apr 01 2026 23:21:25 GMT+0700 (Giờ Đông Dương)', 'Giao ngay khi xong', '', 'NTQT', '0909090909', '090909', '2026-04-01 09:24:49', 100000, 2, 30000, 0),
('DH5', '0123456789', 'Giao tận nơi', 'Thu Apr 02 2026 14:31:51 GMT+0700 (Giờ Đông Dương)', 'Giao ngay khi xong', '', 'Tâm', '0364736820', 'Hưng Yên', '2026-04-02 00:32:30', 150000, 2, 30000, 0),
('DH6', '0364736820', 'Giao tận nơi', 'Thu Apr 02 2026 14:35:06 GMT+0700 (Giờ Đông Dương)', 'Giao ngay khi xong', '', 'Tâm', '0364736820', 'Hưng Yên', '2026-04-02 00:35:21', 150000, 2, 30000, 0),
('DH7', '0364736820', 'Giao tận nơi', 'Thu Apr 02 2026 14:49:27 GMT+0700 (Giờ Đông Dương)', 'Giao ngay khi xong', '', 'Tân', '0364736820', 'Hưnh yên', '2026-04-02 00:50:05', 60000, 2, 30000, 0),
('DH8', '0364736820', 'Giao tận nơi', 'Thu Apr 02 2026 22:59:27 GMT+0700 (Giờ Đông Dương)', '21:00', 'giao cẩn  thận đấy shop', 'lee soo huyn', '0123456789', 'sô 1 ngõ 63 Mỹ Khê ,Đà Nẵng,Việt Nam', '2026-04-02 09:02:39', 30060, 2, 30000, 0),
('DH9', '0364736820', 'Giao tận nơi', 'Thu Apr 02 2026 23:16:17 GMT+0700 (Giờ Đông Dương)', 'Giao ngay khi xong', '', 'SUZY', '0364736820', 'Hà Nội', '2026-04-02 09:16:31', 486610, 0, 30000, 0);

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
(207, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(208, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(209, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(210, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(211, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(212, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(213, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(214, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(215, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(216, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(217, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(218, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(219, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(220, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(221, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(222, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(223, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(224, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(225, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(226, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(227, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(228, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(229, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(230, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(231, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(232, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(233, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(234, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(235, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(236, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(237, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(238, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(239, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(240, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(241, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(242, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(243, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(244, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(245, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(246, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(247, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(248, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(249, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(250, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(251, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(252, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(253, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(254, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(255, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(256, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(257, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(258, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(259, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(260, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(261, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(262, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(263, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(264, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(265, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(266, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(267, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(268, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(269, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(270, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(271, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(272, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(273, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(274, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(275, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(276, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(277, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(278, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(279, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(280, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(281, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(282, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(283, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(284, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(285, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(286, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(287, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(288, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(289, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(290, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(291, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(292, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(293, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(294, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(295, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(296, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(297, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(298, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(299, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(300, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(301, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(302, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(303, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(304, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(305, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(306, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(307, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(308, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(309, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(310, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(311, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(312, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(313, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(314, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(315, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(316, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(317, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(318, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(319, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(320, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(321, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(322, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(323, 'DH8', 42, 'Không có ghi chú', 60, 1),
(324, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(325, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(326, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(327, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(328, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(329, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(330, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(331, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(332, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(333, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(334, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(335, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(336, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(337, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(338, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(339, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(340, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(341, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(342, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(343, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(344, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(345, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(346, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(347, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(348, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(349, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(350, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(351, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(352, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(353, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(354, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(355, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(356, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(357, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(358, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(359, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(360, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(361, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(362, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(363, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(364, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(365, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(366, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(367, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(368, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(369, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(370, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(371, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(372, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(373, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(374, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(375, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(376, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(377, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(378, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(379, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(380, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(381, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(382, 'DH8', 42, 'Không có ghi chú', 60, 1),
(383, 'DH9', 44, 'Không có ghi chú', 456610, 1),
(384, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(385, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(386, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(387, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(388, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(389, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(390, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(391, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(392, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(393, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(394, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(395, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(396, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(397, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(398, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(399, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(400, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(401, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(402, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(403, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(404, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(405, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(406, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(407, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(408, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(409, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(410, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(411, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(412, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(413, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(414, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(415, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(416, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(417, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(418, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(419, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(420, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(421, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(422, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(423, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(424, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(425, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(426, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(427, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(428, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(429, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(430, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(431, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(432, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(433, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(434, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(435, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(436, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(437, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(438, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(439, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(440, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(441, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(442, 'DH8', 42, 'Không có ghi chú', 60, 1),
(443, 'DH9', 44, 'Không có ghi chú', 456610, 1),
(444, 'DH10', 38, 'Không có ghi chú', 63000, 1),
(445, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(446, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(447, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(448, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(449, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(450, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(451, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(452, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(453, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(454, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(455, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(456, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(457, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(458, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(459, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(460, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(461, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(462, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(463, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(464, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(465, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(466, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(467, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(468, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(469, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(470, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(471, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(472, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(473, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(474, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(475, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(476, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(477, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(478, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(479, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(480, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(481, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(482, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(483, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(484, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(485, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(486, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(487, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(488, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(489, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(490, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(491, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(492, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(493, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(494, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(495, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(496, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(497, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(498, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(499, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(500, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(501, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(502, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(503, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(504, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(505, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(506, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(507, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(508, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(509, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(510, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(511, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(512, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(513, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(514, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(515, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(516, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(517, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(518, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(519, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(520, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(521, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(522, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(523, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(524, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(525, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(526, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(527, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(528, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(529, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(530, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(531, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(532, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(533, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(534, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(535, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(536, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(537, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(538, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(539, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(540, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(541, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(542, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(543, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(544, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(545, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(546, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(547, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(548, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(549, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(550, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(551, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(552, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(553, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(554, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(555, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(556, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(557, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(558, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(559, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(560, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(561, 'DH8', 42, 'Không có ghi chú', 60, 1),
(562, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(563, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(564, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(565, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(566, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(567, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(568, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(569, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(570, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(571, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(572, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(573, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(574, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(575, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(576, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(577, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(578, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(579, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(580, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(581, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(582, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(583, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(584, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(585, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(586, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(587, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(588, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(589, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(590, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(591, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(592, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(593, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(594, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(595, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(596, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(597, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(598, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(599, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(600, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(601, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(602, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(603, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(604, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(605, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(606, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(607, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(608, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(609, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(610, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(611, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(612, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(613, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(614, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(615, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(616, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(617, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(618, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(619, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(620, 'DH8', 42, 'Không có ghi chú', 60, 1),
(621, 'DH9', 44, 'Không có ghi chú', 456610, 1),
(622, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(623, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(624, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(625, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(626, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(627, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(628, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(629, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(630, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(631, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(632, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(633, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(634, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(635, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(636, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(637, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(638, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(639, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(640, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(641, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(642, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(643, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(644, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(645, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(646, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(647, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(648, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(649, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(650, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(651, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(652, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(653, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(654, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(655, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(656, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(657, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(658, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(659, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(660, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(661, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(662, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(663, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(664, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(665, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(666, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(667, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(668, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(669, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(670, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(671, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(672, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(673, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(674, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(675, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(676, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(677, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(678, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(679, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(680, 'DH8', 42, 'Không có ghi chú', 60, 1),
(681, 'DH9', 44, 'Không có ghi chú', 456610, 1),
(682, 'DH10', 38, 'Không có ghi chú', 63000, 1),
(683, 'DH11', 18, 'Không có ghi chú', 200000, 1),
(684, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(685, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(686, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(687, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(688, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(689, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(690, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(691, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(692, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(693, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(694, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(695, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(696, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(697, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(698, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(699, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(700, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(701, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(702, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(703, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(704, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(705, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(706, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(707, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(708, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(709, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(710, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(711, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(712, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(713, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(714, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(715, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(716, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(717, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(718, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(719, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(720, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(721, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(722, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(723, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(724, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(725, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(726, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(727, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(728, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(729, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(730, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(731, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(732, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(733, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(734, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(735, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(736, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(737, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(738, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(739, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(740, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(741, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(742, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(743, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(744, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(745, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(746, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(747, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(748, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(749, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(750, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(751, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(752, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(753, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(754, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(755, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(756, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(757, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(758, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(759, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(760, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(761, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(762, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(763, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(764, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(765, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(766, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(767, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(768, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(769, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(770, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(771, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(772, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(773, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(774, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(775, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(776, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(777, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(778, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(779, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(780, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(781, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(782, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(783, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(784, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(785, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(786, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(787, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(788, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(789, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(790, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(791, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(792, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(793, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(794, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(795, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(796, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(797, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(798, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(799, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(800, 'DH8', 42, 'Không có ghi chú', 60, 1),
(801, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(802, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(803, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(804, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(805, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(806, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(807, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(808, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(809, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(810, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(811, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(812, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(813, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(814, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(815, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(816, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(817, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(818, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(819, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(820, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(821, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(822, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(823, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(824, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(825, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(826, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(827, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(828, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(829, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(830, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(831, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(832, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(833, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(834, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(835, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(836, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(837, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(838, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(839, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(840, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(841, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(842, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(843, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(844, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(845, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(846, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(847, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(848, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(849, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(850, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(851, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(852, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(853, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(854, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(855, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(856, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(857, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(858, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(859, 'DH8', 42, 'Không có ghi chú', 60, 1),
(860, 'DH9', 44, 'Không có ghi chú', 456610, 1),
(861, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(862, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(863, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(864, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(865, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(866, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(867, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(868, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(869, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(870, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(871, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(872, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(873, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(874, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(875, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(876, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(877, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(878, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(879, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(880, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(881, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(882, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(883, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(884, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(885, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(886, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(887, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(888, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(889, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(890, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(891, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(892, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(893, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(894, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(895, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(896, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(897, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(898, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(899, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(900, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(901, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(902, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(903, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(904, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(905, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(906, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(907, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(908, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(909, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(910, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(911, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(912, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(913, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(914, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(915, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(916, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(917, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(918, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(919, 'DH8', 42, 'Không có ghi chú', 60, 1),
(920, 'DH9', 44, 'Không có ghi chú', 456610, 1),
(921, 'DH10', 38, 'Không có ghi chú', 63000, 1),
(922, 'DH11', 18, 'Không có ghi chú', 200000, 1),
(923, 'DH12', 18, 'Không có ghi chú', 200000, 1),
(924, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(925, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(926, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(927, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(928, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(929, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(930, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(931, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(932, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(933, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(934, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(935, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(936, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(937, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(938, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(939, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(940, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(941, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(942, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(943, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(944, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(945, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(946, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(947, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(948, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(949, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(950, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(951, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(952, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(953, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(954, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(955, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(956, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(957, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(958, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(959, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(960, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(961, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(962, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(963, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(964, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(965, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(966, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(967, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(968, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(969, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(970, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(971, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(972, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(973, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(974, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(975, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(976, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(977, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(978, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(979, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(980, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(981, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(982, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(983, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(984, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(985, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(986, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(987, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(988, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(989, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(990, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(991, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(992, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(993, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(994, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(995, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(996, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(997, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(998, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(999, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1000, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1001, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1002, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1003, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1004, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1005, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1006, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1007, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(1008, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(1009, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1010, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1011, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1012, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1013, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1014, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1015, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1016, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1017, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1018, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1019, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1020, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1021, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(1022, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(1023, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(1024, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1025, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1026, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1027, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1028, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1029, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1030, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1031, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1032, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1033, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1034, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1035, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1036, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(1037, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(1038, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(1039, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(1040, 'DH8', 42, 'Không có ghi chú', 60, 1),
(1041, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1042, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1043, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1044, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1045, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1046, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1047, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1048, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1049, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1050, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1051, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1052, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1053, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(1054, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1055, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1056, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1057, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1058, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1059, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1060, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1061, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1062, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1063, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1064, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1065, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1066, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(1067, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(1068, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1069, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1070, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1071, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1072, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1073, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1074, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1075, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1076, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1077, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1078, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1079, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1080, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(1081, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(1082, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(1083, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1084, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1085, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1086, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1087, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1088, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1089, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1090, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1091, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1092, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1093, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1094, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1095, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(1096, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(1097, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(1098, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(1099, 'DH8', 42, 'Không có ghi chú', 60, 1),
(1100, 'DH9', 44, 'Không có ghi chú', 456610, 1),
(1101, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1102, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1103, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1104, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1105, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1106, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1107, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1108, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1109, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1110, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1111, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1112, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1113, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(1114, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1115, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1116, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1117, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1118, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1119, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1120, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1121, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1122, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1123, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1124, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1125, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1126, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(1127, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(1128, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1129, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1130, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1131, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1132, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1133, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1134, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1135, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1136, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1137, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1138, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1139, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1140, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(1141, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(1142, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(1143, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1144, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1145, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1146, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1147, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1148, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1149, 'DH1', 17, 'Không có ghi chú', 20000, 2),
(1150, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1151, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1152, 'DH1', 19, 'Không có ghi chú', 30000, 1),
(1153, 'DH2', 23, 'Không có ghi chú', 25000, 1),
(1154, 'DH3', 20, 'Không có ghi chú', 500000, 1),
(1155, 'DH4', 15, 'Không có ghi chú', 70000, 1),
(1156, 'DH5', 13, 'Không có ghi chú', 120000, 1),
(1157, 'DH6', 13, 'Không có ghi chú', 120000, 1),
(1158, 'DH7', 19, 'Không có ghi chú', 30000, 1),
(1159, 'DH8', 42, 'Không có ghi chú', 60, 1),
(1160, 'DH9', 44, 'Không có ghi chú', 456610, 1),
(1161, 'DH10', 38, 'Không có ghi chú', 63000, 1),
(1162, 'DH11', 18, 'Không có ghi chú', 200000, 1),
(1163, 'DH12', 18, 'Không có ghi chú', 200000, 1),
(1164, 'DH13', 19, 'Không có ghi chú', 30000, 1);

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
  `describes` text DEFAULT NULL,
  `search_count` int(11) DEFAULT 0,
  `like_count` int(11) DEFAULT 0,
  `sold_count` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `status`, `title`, `img`, `category`, `price`, `describes`, `search_count`, `like_count`, `sold_count`) VALUES
(11, 0, 'Sách Ôn luyện giãi mã 990+ Đánh giá Năng lực Đại học Quốc gia TP.HCM', './assets/img/products/2-sach-luyen-thi-danh-gia-nang-luc.jpg', 'Lớp 10', 120000, 'Sách Ôn luyện giãi mã 990+ Đánh giá Năng lực Đại học Quốc gia TP.HCM là tài liệu hỗ trợ thí sinh chuẩn bị cho kỳ thi đánh giá năng lực của Đại học Quốc gia TP.HCM. Cuốn sách bao gồm bài tập theo từng kỹ năng như ngữ pháp, từ vựng, và đọc hiểu, cùng với nhiều đề thi mô phỏng cấu trúc giống kỳ thi thực tế. Các đề thi đi kèm đáp án và hướng dẫn giải chi tiết giúp thí sinh làm quen với dạng câu hỏi và cải thiện kỹ năng. Sách cũng cung cấp chiến lược ôn tập và mẹo làm bài, giúp thí sinh chuẩn bị hiệu quả cho kỳ thi.', 0, 0, 12),
(43, 1, 'Sinh học 11', './assets/img/products/sach-giao-khoa-sinh-hoc-11.jpg', 'Lớp 11', 12336, 'Sách giáo khoa Sinh học 11 do Nhà xuất bản Giáo dục Việt Nam phát hành bao gồm các chủ đề về sinh học tế bào, di truyền học, và sinh thái học. Học sinh sẽ học về cấu trúc và chức năng của tế bào, các quy luật di truyền, và mối quan hệ giữa các sinh vật trong hệ sinh thái. Cuốn sách cung cấp các định nghĩa, định lý và công thức quan trọng, cùng với các bài tập từ cơ bản đến nâng cao và các ví dụ minh họa. Sách được sử dụng làm tài liệu giảng dạy cho giáo viên và học tập cho học sinh lớp 11, hỗ trợ học sinh trong việc ôn tập và chuẩn bị cho các kỳ thi quan trọng.', 0, 0, 0),
(44, 1, 'Ngữ văn 11', './assets/img/products/sach-giao-khoa-ngu-van-tap1-11.jpg', 'Lớp 11', 456610, 'Sách giáo khoa Ngữ văn 11 do Nhà xuất bản Giáo dục Việt Nam phát hành tập trung vào các tác phẩm văn học hiện đại Việt Nam và thế giới, bao gồm văn xuôi và thơ. Học sinh sẽ học về các tác phẩm này, phân tích văn bản và rèn luyện kỹ năng viết văn. Cuốn sách cung cấp các ví dụ minh họa giúp học sinh hiểu rõ hơn về tác phẩm. Sách được sử dụng làm tài liệu giảng dạy cho giáo viên và học tập cho học sinh lớp 11, hỗ trợ học sinh trong việc ôn tập và chuẩn bị cho các kỳ thi quan trọng.', 0, 0, 8);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_fullname` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `ratings`
--

INSERT INTO `ratings` (`id`, `product_id`, `user_id`, `order_id`, `rating`, `comment`, `created_at`, `updated_at`, `user_fullname`) VALUES
(13, 13, 364736820, 6, 5, 'Sách tốt', '2026-04-02 14:52:03', '2026-04-02 14:52:03', 'Chu tâm'),
(14, 42, 364736820, 8, 5, 'sách hay , mong đỗ lớp 11', '2026-04-02 23:04:42', '2026-04-02 23:04:42', 'Chu tâm');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(50) NOT NULL,
  `setting_value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `settings`
--

INSERT INTO `settings` (`id`, `setting_key`, `setting_value`) VALUES
(1, 'footer_discount_percent', '33');

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
  `join_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `userType` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `fullname`, `phone`, `password`, `address`, `email`, `status`, `join_date`, `userType`) VALUES
(1, 'admin', '0123456789', '111111', 'Phường Từ Liêm, TP. Hà Nội', 'realleesan@gmail.com', 1, '2024-08-20 13:08:37', 1),
(41, 'LE VU BAO NHAT', '0987456123', '123456', '', 'nna@gmail.com', 0, '2026-03-21 06:29:10', 0),
(46, 'Bùi Thu Trang', '0337596806', 'buithutrang', 'trangthubui918@gmail.com', 'trangthubui918@gmail.com', 1, '2026-03-31 23:08:35', 0),
(47, 'NTQT', '0987654321', '0987654321', '', '', 0, '2026-04-01 09:21:01', 0),
(48, 'Chu tâm', '0364736820', '11111111', '', 'chuthimytam9a1920@gmail.com', 1, '2026-04-02 00:33:36', 0),
(49, 'Y', '0997775544', '22222222', '', '', 1, '2026-04-02 00:39:32', 0),
(50, 'QT', '0912121626', '1212121212', '', '', 1, '2026-04-02 08:55:56', 0);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`idcart`);

--
-- Chỉ mục cho bảng `chat_conversations`
--
ALTER TABLE `chat_conversations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_id` (`user_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_last_message` (`last_message_at`);

--
-- Chỉ mục cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Chỉ mục cho bảng `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

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
-- Chỉ mục cho bảng `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_order_product` (`order_id`,`product_id`),
  ADD KEY `idx_product_id` (`product_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_order_id` (`order_id`);

--
-- Chỉ mục cho bảng `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

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
  MODIFY `idcart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT cho bảng `chat_conversations`
--
ALTER TABLE `chat_conversations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT cho bảng `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `orderdetails`
--
ALTER TABLE `orderdetails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1165;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT cho bảng `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=358;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

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
