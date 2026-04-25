-- Drop existing tables first (to fix tablespace issue)
DROP TABLE IF EXISTS `cart`;
DROP TABLE IF EXISTS `orderDetails`;
DROP TABLE IF EXISTS `order`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `users`;

-- Now import the rest of websach.sql
