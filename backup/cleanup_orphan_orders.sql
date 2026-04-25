-- Script dọn dẹp dữ liệu orphan
-- Run trong phpMyAdmin

-- 1. Xóa các đơn hàng KHÔNG có chi tiết (orderdetails)
DELETE FROM orderdetails WHERE madon NOT IN (SELECT id FROM `order`);

-- 2. Xóa các đơn hàng của người dùng đã bị xóa
DELETE FROM orderdetails WHERE madon IN (
    SELECT o.id FROM `order` o 
    LEFT JOIN users u ON o.khachhang = u.phone 
    WHERE u.phone IS NULL
);

DELETE FROM `order` WHERE khachhang NOT IN (SELECT phone FROM users);

-- Kiểm tra kết quả
SELECT 'order' AS table_name, COUNT(*) AS total FROM `order`
UNION ALL
SELECT 'orderdetails', COUNT(*) FROM orderdetails
UNION ALL
SELECT 'users', COUNT(*) FROM users;