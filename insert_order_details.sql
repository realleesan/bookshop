-- Script thêm dữ liệu mẫu cho bảng orderdetails
-- Chạy script này trong phpMyAdmin để thêm dữ liệu

INSERT INTO `orderdetails` (`id`, `madon`, `product_id`, `note`, `product_price`, `soluong`) VALUES
(1, 'DH4', 1, 'Sách hay', 100000, 1),
(2, 'DH4', 2, 'Tặng ai đó', 50000, 2),
(3, 'DH5', 3, 'Giao sớm', 150000, 1),
(4, 'DH5', 4, 'NULL', 80000, 3);
