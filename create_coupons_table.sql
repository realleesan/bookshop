-- Create coupons table for discount code system
CREATE TABLE IF NOT EXISTS `coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(6) NOT NULL,
  `discount_percent` int(11) NOT NULL DEFAULT 10,
  `email` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
