-- Add columns for shipping fee and discount to order table
ALTER TABLE `order` ADD COLUMN `phiVanChuyen` INT(11) DEFAULT 0;
ALTER TABLE `order` ADD COLUMN `giamGia` INT(11) DEFAULT 0;
