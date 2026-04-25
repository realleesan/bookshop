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
(11, 0, 'Sách Ôn luyện giãi mã 990+ Đánh giá Năng lực Đại học Quốc gia TP.HCM', './assets/img/products/2-sach-luyen-thi-danh-gia-nang-luc.jpg', 'Lớp 10', 120000, 'Sách Ôn luyện giãi mã 990+ Đánh giá Năng lực Đại học Quốc gia TP.HCM là tài liệu hỗ trợ thí sinh chuẩn bị cho kỳ thi đánh giá năng lực của Đại học Quốc gia TP.HCM. Cuốn sách bao gồm bài tập theo từng kỹ năng như ngữ pháp, từ vựng, và đọc hiểu, cùng với nhiều đề thi mô phỏng cấu trúc giống kỳ thi thực tế. Các đề thi đi kèm đáp án và hướng dẫn giải chi tiết giúp thí sinh làm quen với dạng câu hỏi và cải thiện kỹ năng. Sách cũng cung cấp chiến lược ôn tập và mẹo làm bài, giúp thí sinh chuẩn bị hiệu quả cho kỳ thi.'),
(12, 0, 'Sách Tăng tốc Luyện thi Đánh giá Năng lực Đại học Quốc gia TP.HCM', './assets/img/products/3-sach-luyen-thi-danh-gia-nang-luc.jpg', 'Sách khác', 150000, 'Sách Tăng tốc Luyện thi Đánh giá Năng lực Đại học Quốc gia TP.HCM là tài liệu hỗ trợ thí sinh nâng cao kỹ năng cho kỳ thi đánh giá năng lực của Đại học Quốc gia TP.HCM. Cuốn sách bao gồm bài tập thực hành theo từng kỹ năng như ngữ pháp, từ vựng, đọc hiểu và giải quyết vấn đề, cùng với nhiều đề thi mô phỏng có đáp án và hướng dẫn giải chi tiết. Ngoài ra, sách còn cung cấp các mẹo làm bài và chiến lược ôn tập hiệu quả, giúp thí sinh làm quen với cấu trúc và áp lực của kỳ thi, chuẩn bị tốt nhất cho kỳ thi đánh giá năng lực.'),
(13, 1, 'Sách Ôn luyện giãi mã 990+ ', './assets/img/products/2-sach-luyen-thi-danh-gia-nang-luc.jpg', 'Sách khác', 120000, 'Sách Ôn luyện giãi mã 990+ Đánh giá Năng lực Đại học Quốc gia TP.HCM là tài liệu hỗ trợ thí sinh chuẩn bị cho kỳ thi đánh giá năng lực của Đại học Quốc gia TP.HCM. Cuốn sách bao gồm bài tập theo từng kỹ năng như ngữ pháp, từ vựng, và đọc hiểu, cùng với nhiều đề thi mô phỏng cấu trúc giống kỳ thi thực tế. Các đề thi đi kèm đáp án và hướng dẫn giải chi tiết giúp thí sinh làm quen với dạng câu hỏi và cải thiện kỹ năng. Sách cũng cung cấp chiến lược ôn tập và mẹo làm bài, giúp thí sinh chuẩn bị hiệu quả cho kỳ thi.'),
(14, 0, 'Tăng tốc Luyện thi Đánh giá Năng lực', './assets/img/products/3-sach-luyen-thi-danh-gia-nang-luc.jpg', 'Sách khác', 200000, 'Sách Tăng tốc Luyện thi Đánh giá Năng lực Đại học Quốc gia TP.HCM là tài liệu hỗ trợ thí sinh nâng cao kỹ năng cho kỳ thi đánh giá năng lực của Đại học Quốc gia TP.HCM. Cuốn sách bao gồm bài tập thực hành theo từng kỹ năng như ngữ pháp, từ vựng, đọc hiểu và giải quyết vấn đề, cùng với nhiều đề thi mô phỏng có đáp án và hướng dẫn giải chi tiết. Ngoài ra, sách còn cung cấp các mẹo làm bài và chiến lược ôn tập hiệu quả, giúp thí sinh làm quen với cấu trúc và áp lực của kỳ thi, chuẩn bị tốt nhất cho kỳ thi đánh giá năng lực'),
(15, 1, 'Sách bài tập Địa lý 10', './assets/img/products/bai-tap-dia-li-10.jpg', 'Lớp 10', 70000, 'Sách bài tập Địa lý 10 Bao gồm các bài tập về địa lý tự nhiên, kinh tế và dân cư. Các bài tập được thiết kế từ cơ bản đến nâng cao, giúp học sinh rèn luyện kỹ năng giải bài tập và củng cố kiến thức đã học trong sách giáo khoa. Sách cung cấp nhiều bản đồ và hình ảnh minh họa, giúp học sinh dễ dàng hiểu và áp dụng kiến thức.'),
(16, 1, 'Sách bài tập Hình học 11', './assets/img/products/bai-tap-hinh-hoc-11.jpg', 'Lớp 11', 90000, 'Sách bài tập Hình học 11 Bao gồm các bài tập về hình học phẳng và không gian, các định lý và tính chất hình học. Các bài tập được sắp xếp theo mức độ khó tăng dần, giúp học sinh phát triển tư duy logic và kỹ năng giải quyết vấn đề. Sách cung cấp nhiều hình vẽ minh họa và lời giải chi tiết, giúp học sinh dễ dàng hiểu và áp dụng kiến thức.'),
(17, 1, 'Sách bài tập Hóa học 10', './assets/img/products/sach-giao-khoa-hoa-hoc-10.jpg', 'Lớp 10', 20000, 'Sách bài tập Hóa học 10 Gồm các bài tập về cấu tạo nguyên tử, bảng tuần hoàn các nguyên tố, và các loại phản ứng hóa học. Các bài tập được thiết kế để giúp học sinh nắm vững kiến thức hóa học cơ bản và phát triển kỹ năng giải bài tập. Mỗi bài tập đều có hướng dẫn chi tiết và lời giải mẫu, giúp học sinh dễ dàng theo dõi và tự học.'),
(18, 1, 'Tăng tốc Luyện thi  ĐGNL', './assets/img/products/3-sach-luyen-thi-danh-gia-nang-luc.jpg', 'Sách khác', 200000, 'Sách Tăng tốc Luyện thi Đánh giá Năng lực Đại học Quốc gia TP.HCM là tài liệu hỗ trợ thí sinh nâng cao kỹ năng cho kỳ thi đánh giá năng lực của Đại học Quốc gia TP.HCM. Cuốn sách bao gồm bài tập thực hành theo từng kỹ năng như ngữ pháp, từ vựng, đọc hiểu và giải quyết vấn đề, cùng với nhiều đề thi mô phỏng có đáp án và hướng dẫn giải chi tiết. Ngoài ra, sách còn cung cấp các mẹo làm bài và chiến lược ôn tập hiệu quả, giúp thí sinh làm quen với cấu trúc và áp lực của kỳ thi, chuẩn bị tốt nhất cho kỳ thi đánh giá năng lực'),
(19, 1, 'Sách bài tập Hóa học 12', './assets/img/products/bai-tap-hoa-hoc-12.jpg', 'Lớp 12', 300000, 'Sách bài tập Hóa học 12 Gồm các bài tập về cấu tạo nguyên tử, bảng tuần hoàn các nguyên tố, và các loại phản ứng hóa học. Các bài tập được thiết kế để giúp học sinh nắm vững kiến thức hóa học cơ bản và phát triển kỹ năng giải bài tập. Mỗi bài tập đều có hướng dẫn chi tiết và lời giải mẫu, giúp học sinh dễ dàng theo dõi và tự học.'),
(20, 1, 'Giải tích 12', './assets/img/products/sach-giao-khoa-giai-tich-12-co-ban.png', 'Lớp 12', 500000, 'Sách giáo khoa Toán học 12 do Nhà xuất bản Giáo dục Việt Nam phát hành, bao gồm hai phần chính: Đại số và Giải tích. Phần Đại số tập trung vào các chủ đề như hàm số, đạo hàm, tích phân, và các ứng dụng của chúng trong việc giải các bài toán thực tế. Phần Giải tích cung cấp kiến thức về các khái niệm cơ bản như giới hạn, đạo hàm, tích phân và các ứng dụng của chúng. Cuốn sách này không chỉ cung cấp các định nghĩa, định lý và công thức quan trọng mà còn bao gồm nhiều bài tập từ cơ bản đến nâng cao, giúp học sinh rèn luyện kỹ năng giải toán và chuẩn bị cho các kỳ thi quan trọng như kỳ thi tốt nghiệp trung học phổ thông và kỳ thi đại học.'),
(21, 1, 'Sách giáo khoa Đại số 10', './assets/img/products/sach-giao-khoa-dai-so-lop-10.jpg', 'Lớp 10', 12000, 'Sách giáo khoa Đại số 10 cơ bản (SGK Đại số 10 CB) gồm 175 trang, do nhà xuất bản Giáo dục Việt Nam phát hành. Đây là cuốn sách chính thống dành cho học sinh lớp 10, bao gồm các chủ đề quan trọng như phương trình, bất phương trình, và hàm số. Cuốn sách này không chỉ cung cấp kiến thức cơ bản mà còn giúp học sinh phát triển tư duy logic và kỹ năng giải quyết vấn đề. Các bài tập và ví dụ minh họa trong sách được thiết kế để học sinh có thể tự luyện tập và củng cố kiến thức.'),
(22, 1, 'Sách học sinh Tiếng Anh 12', './assets/img/products/sach-giao-khoa-tieng-anh-12-tap-2.jpg', 'Sách khác', 5000000, 'Sách học sinh Tiếng Anh 12 được biên soạn bởi Nhà xuất bản Giáo dục Việt Nam và áp dụng tại các trường trung học phổ thông. Sách cung cấp các bài học đa dạng về ngữ pháp, từ vựng, và các kỹ năng ngôn ngữ cơ bản như nghe, nói, đọc và viết. Mỗi đơn vị bài học tập trung vào các chủ đề gần gũi với đời sống học sinh và các vấn đề xã hội, giúp học sinh cải thiện khả năng giao tiếp trong các tình huống thực tế, các hoạt động tương tác, bài tập thực hành và các bài đọc hiểu nhằm phát triển toàn diện kỹ năng ngôn ngữ. Nhằm nâng cao chất lượng dạy và học tiếng Anh, đáp ứng nhu cầu học tập của học sinh và chuẩn bị cho các kỳ thi quan trọng.'),
(23, 1, 'Đạo số và giải tích 11', './assets/img/products/sach-giao-khoa-dai-so-va-giai-tich-11-co-ban.png', 'Lớp 11', 450000, ' Đại số và Giải tích 11 sách được biên soạn bởi Nhà xuất bản Giáo dục Việt Nam, là tài liệu giảng dạy và học tập chính thức cho học sinh lớp 11 tại các trường trung học phổ thông trên toàn quốc. Tập trung vào các chủ đề như tổ hợp, xác suất, dãy số, cấp số cộng, cấp số nhân, hàm số lượng giác và phương trình lượng giác. Cuốn sách cung cấp các định nghĩa, định lý và công thức quan trọng, kèm theo các bài tập từ cơ bản đến nâng cao.'),
(24, 1, 'Sách giáo khoa Công nghệ 10', './assets/img/products/sach-giao-khoa-cong-nghe-lop-10.jpg', 'Lớp 10', 45000, 'Sách giáo khoa Công nghệ 10 cơ bản (SGK Công nghệ 10 CB) gồm 150 trang, do nhà xuất bản Giáo dục Việt Nam phát hành. Cuốn sách này bao gồm các bài học về kỹ thuật và công nghệ, như các quy trình sản xuất, các loại máy móc và thiết bị, và các ứng dụng công nghệ trong đời sống. Học sinh sẽ được học cách vận hành và bảo trì các thiết bị công nghệ. Sách còn cung cấp nhiều hình ảnh minh họa và bài tập để học sinh có thể dễ dàng hiểu và áp dụng kiến thức.'),
(25, 1, 'Vật lý 11', './assets/img/products/Sach-giao-khoa-vat-ly-11.jpg', 'Lớp 11', 23000, 'Sách giáo khoa Vật lý 11 do Nhà xuất bản Giáo dục Việt Nam phát hành bao gồm các chủ đề như động lực học, nhiệt học, và điện học. Học sinh sẽ thực hiện các thí nghiệm và giải các bài tập để hiểu rõ hơn về các hiện tượng vật lý. Cuốn sách cung cấp các định nghĩa, định lý và công thức quan trọng, cùng với các bài tập từ cơ bản đến nâng cao và các ví dụ minh họa. Sách được sử dụng làm tài liệu giảng dạy cho giáo viên và học tập cho học sinh lớp 11, hỗ trợ học sinh trong việc ôn tập và chuẩn bị cho các kỳ thi quan trọng.\r\n'),
(26, 1, 'Sách bài tập Tiếng Anh 10', './assets/img/products/sach-bai-tap-tiang-anh-10-tap-1.jpg', 'Sách khác', 720000, 'Sách bài tập Tiếng Anh 10 được biên soạn bởi Nhà xuất bản Giáo dục Việt Nam, đi kèm với sách học sinh và cung cấp các bài tập thực hành phong phú để học sinh củng cố kiến thức và kỹ năng tiếng Anh. Các bài tập được thiết kế để giúp học sinh luyện tập từ vựng, ngữ pháp, và các kỹ năng giao tiếp, với các bài tập từ cơ bản đến nâng cao, cùng với hướng dẫn giải chi tiết. Cuốn sách cũng bao gồm các bài tập kiểm tra và đánh giá để giúp học sinh tự đánh giá và cải thiện kỹ năng của mình.'),
(27, 1, 'Giáo dục công dân 12', './assets/img/products/sach-giao-khoa-giao-duc-cong-dan-12.jpg', 'Lớp 12', 8000, 'Sách giáo khoa Giáo dục công dân 12 do Nhà xuất bản Giáo dục Việt Nam phát hành, tập trung vào các khái niệm về pháp luật, quyền và nghĩa vụ của công dân, và các vấn đề xã hội. Học sinh sẽ học về các quy định pháp luật, quyền con người, và trách nhiệm công dân. Cuốn sách cung cấp các bài tập và ví dụ minh họa để hỗ trợ việc học tập. Các bài học được thiết kế để giúp học sinh hiểu rõ hơn về các quy định pháp luật và phát triển kỹ năng tư duy phản biện và giải quyết vấn đề.'),
(28, 1, 'Sách giáo khoa Địa lý 10', './assets/img/products/sach-giao-khoa-dia-li-lop-10.jpg', 'Lớp 10', 21000, 'Sách giáo khoa Địa lý 10 cơ bản (SGK Địa lý 10 CB) gồm 180 trang, phát hành bởi nhà xuất bản Giáo dục Việt Nam. Cuốn sách này bao gồm các chủ đề về địa lý tự nhiên, kinh tế và dân cư. Học sinh sẽ được học về các hiện tượng tự nhiên, các nguồn tài nguyên và các hoạt động kinh tế. Sách còn cung cấp nhiều bản đồ và hình ảnh minh họa để học sinh có thể dễ dàng hiểu và áp dụng kiến thức.'),
(29, 1, 'Vật lý 12', './assets/img/products/sach-giao-khoa-vat-li-12.jpg', 'Lớp 12', 65000, 'Sách giáo khoa Vật lý 12 do Nhà xuất bản Giáo dục Việt Nam phát hành, bao gồm các chủ đề như cơ học, điện học, quang học, và vật lý hạt nhân. Học sinh sẽ thực hiện các thí nghiệm và giải các bài tập để hiểu rõ hơn về các hiện tượng vật lý. Cuốn sách cung cấp các định nghĩa, định lý và công thức quan trọng, cùng với các ví dụ minh họa và bài tập từ cơ bản đến nâng cao. Các bài học được thiết kế để giúp học sinh nắm vững kiến thức lý thuyết và áp dụng vào thực tế, chuẩn bị cho các kỳ thi quan trọng.'),
(30, 1, 'Sách bài tập Lịch sử 12 ', './assets/img/products/bai-tap-lich-su-12.jpg', 'Lớp 12', 5000, 'Sách bài tập Lịch sử 12 Gồm các bài tập về các sự kiện lịch sử từ thời kỳ cổ đại đến cận đại, với trọng tâm là lịch sử Việt Nam và thế giới. Các bài tập được thiết kế để giúp học sinh nắm vững kiến thức lịch sử và phát triển kỹ năng phân tích sự kiện lịch sử. Mỗi bài tập đều có hướng dẫn chi tiết và lời giải mẫu, giúp học sinh dễ dàng theo dõi và tự học.'),
(31, 1, 'Công nghệ 11', './assets/img/products/sach-giao-khoa-cong-nghe-lop-11.jpg', 'Lớp 11', 45000, 'Sách giáo khoa Công nghệ 11 cơ bản (SGK Công nghệ 11 CB) gồm 150 trang, do nhà xuất bản Giáo dục Việt Nam phát hành. Cuốn sách này bao gồm các bài học về kỹ thuật và công nghệ, như các quy trình sản xuất, các loại máy móc và thiết bị, và các ứng dụng công nghệ trong đời sống. Học sinh sẽ được học cách vận hành và bảo trì các thiết bị công nghệ. Sách còn cung cấp nhiều hình ảnh minh họa và bài tập để học sinh có thể dễ dàng hiểu và áp dụng kiến thức.'),
(32, 1, 'Sách bài tập Hình học 11', './assets/img/products/bai-tap-hinh-hoc-11.jpg', 'Lớp 11', 3000, 'Sách bài tập Hình học 11 Bao gồm các bài tập về hình học phẳng và không gian, các định lý và tính chất hình học. Các bài tập được sắp xếp theo mức độ khó tăng dần, giúp học sinh phát triển tư duy logic và kỹ năng giải quyết vấn đề. Sách cung cấp nhiều hình vẽ minh họa và lời giải chi tiết, giúp học sinh dễ dàng hiểu và áp dụng kiến thức.'),
(33, 1, 'Hóa học 11', './assets/img/products/sach-giao-khoa-hoa-hoc-11.jpg', 'Lớp 11', 89000, 'Sách giáo khoa Hóa học 11 do Nhà xuất bản Giáo dục Việt Nam phát hành tập trung vào các khái niệm về hóa học hữu cơ và vô cơ, bao gồm các phản ứng hóa học, cấu trúc phân tử, và các tính chất của chất. Cuốn sách cung cấp các định nghĩa, định lý và công thức quan trọng, cùng với các bài tập từ cơ bản đến nâng cao và các ví dụ minh họa. Sách được sử dụng làm tài liệu giảng dạy cho giáo viên và học tập cho học sinh lớp 11, hỗ trợ học sinh trong việc ôn tập và chuẩn bị cho các kỳ thi quan trọng.'),
(34, 1, '50 Đề MH 2023 Môn Vật lý', './assets/img/products/on-thi-thptqg-ly.jpg', 'Sách khác', 100000, 'Sách 50 Đề Minh Họa 2023 Môn Vật lý được biên soạn bởi Nhà xuất bản Thanh Niên, là tài liệu luyện thi chuyên sâu dành cho học sinh chuẩn bị kỳ thi Trung học Phổ thông Quốc gia năm 2023. Cuốn sách bao gồm 50 đề thi minh họa với cấu trúc và độ khó tương tự kỳ thi thực tế, giúp học sinh làm quen với dạng câu hỏi và yêu cầu của kỳ thi. Mỗi đề thi được kèm theo đáp án và hướng dẫn giải chi tiết, giúp học sinh hiểu rõ cách giải quyết các câu hỏi. Sách cũng cung cấp các mẹo ôn tập và chiến lược làm bài hiệu quả, hỗ trợ học sinh xây dựng kế hoạch ôn luyện hợp lý và nâng cao kỹ năng làm bài, từ đó chuẩn bị tốt nhất cho kỳ thi.'),
(35, 1, 'Sách bài tập Hóa học 12', './assets/img/products/bai-tap-hoa-hoc-12.jpg', 'Lớp 12', 6000, 'Sách bài tập Hóa học 12 Gồm các bài tập về cấu tạo nguyên tử, bảng tuần hoàn các nguyên tố, và các loại phản ứng hóa học. Các bài tập được thiết kế để giúp học sinh nắm vững kiến thức hóa học cơ bản và phát triển kỹ năng giải bài tập. Mỗi bài tập đều có hướng dẫn chi tiết và lời giải mẫu, giúp học sinh dễ dàng theo dõi và tự học.'),
(36, 1, 'Sách bài tập Tiếng Anh 11 ', './assets/img/products/Sach-giao-khoa-tieng-anh-lop-11-tap-1.jpg', 'Sách khác', 420000, 'Sách bài tập Tiếng Anh 11 bổ trợ cho sách học sinh với các bài tập phong phú nhằm củng cố kiến thức và kỹ năng tiếng Anh. Các bài tập bao gồm từ vựng, ngữ pháp, và các kỹ năng giao tiếp, với các bài tập từ cơ bản đến nâng cao, cùng với hướng dẫn giải chi tiết. Sách cũng cung cấp các bài tập kiểm tra và đánh giá để học sinh có thể tự kiểm tra và cải thiện kỹ năng của mình.'),
(37, 1, 'Sách giáo khoa Ngữ văn 10', './assets/img/products/sach-giao-khoa-Ngu-Van-10-Tap-1.jpg', 'Lớp 10', 25000, 'Sách giáo khoa Ngữ văn 10 cơ bản (SGK Ngữ văn 10 CB) gồm 180 trang, do nhà xuất bản Giáo dục Việt Nam phát hành. Cuốn sách này chứa đựng các tác phẩm văn học cổ điển và hiện đại, từ văn học Việt Nam đến văn học thế giới. Ngoài ra, sách còn bao gồm các bài học về ngữ pháp, kỹ năng viết và phân tích văn bản. Học sinh sẽ được tiếp cận với nhiều thể loại văn học khác nhau, từ thơ, truyện ngắn đến tiểu thuyết, giúp phát triển khả năng đọc hiểu và tư duy sáng tạo.'),
(38, 1, 'Sách bài tập Vật lý 10', './assets/img/products/Sach-bai-tap-vat-li-10-co-ban.jpg', 'Lớp 10', 63000, 'Sách bài tập Vật lý 10 Bao gồm các bài tập về cơ học, nhiệt học và các hiện tượng vật lý cơ bản. Các bài tập được thiết kế từ dễ đến khó, giúp học sinh rèn luyện kỹ năng giải bài tập và củng cố kiến thức đã học trong sách giáo khoa. Sách cung cấp nhiều thí nghiệm và bài tập thực hành, giúp học sinh tự kiểm chứng kiến thức và phát triển kỹ năng thực hành.'),
(39, 1, 'Sách giáo khoa Lịch sử 10', './assets/img/products/sach-giao-khoa-lich-su-lop-10.jpg', 'Lớp 10', 65000, 'Sách giáo khoa Lịch sử 10 cơ bản (SGK Lịch sử 10 CB) gồm 190 trang, do nhà xuất bản Giáo dục Việt Nam phát hành. Cuốn sách này bao gồm các sự kiện lịch sử quan trọng từ thời kỳ cổ đại đến cận đại, với trọng tâm là lịch sử Việt Nam và thế giới. Học sinh sẽ được học về các nền văn minh cổ đại, các cuộc chiến tranh và các sự kiện lịch sử quan trọng. Sách còn cung cấp nhiều tài liệu tham khảo và bài tập để học sinh có thể tự nghiên cứu và củng cố kiến thức.'),
(40, 1, 'Sách giáo khoa Tin học 10', './assets/img/products/Tin-hoc-10-500x554.jpg', 'Lớp 10', 12000, 'Sách giáo khoa Tin học 10 cơ bản (SGK Tin học 10 CB) gồm 130 trang, phát hành bởi nhà xuất bản Giáo dục Việt Nam. Cuốn sách này giới thiệu các khái niệm cơ bản về máy tính và lập trình, bao gồm các phần mềm ứng dụng và ngôn ngữ lập trình cơ bản. Học sinh sẽ được học cách sử dụng máy tính và viết các chương trình đơn giản. Sách còn cung cấp nhiều bài tập và dự án để học sinh có thể tự thực hành và phát triển kỹ năng tin học.'),
(41, 1, 'Sách giáo khoa GDCD 10', './assets/img/products/sach-giao-khoa-giao-duc-cong-dan-lop-10.jpg', 'Sách khác', 45000, 'Sách giáo khoa Giáo dục công dân 10 cơ bản (SGK GDCD 10 CB) gồm 140 trang, do nhà xuất bản Giáo dục Việt Nam phát hành. Cuốn sách này bao gồm các bài học về đạo đức, pháp luật và kỹ năng sống. Học sinh sẽ được học về các giá trị đạo đức, các quy định pháp luật và các kỹ năng cần thiết để trở thành công dân có trách nhiệm. Sách còn cung cấp nhiều tình huống thực tế và bài tập để học sinh có thể tự rèn luyện và áp dụng kiến thức.'),
(42, 1, 'Sách bài tập Ngữ văn 11', './assets/img/products/sach-bai-tap-ngu-van-lop-11-tap-1.jpg', 'Lớp 11', 60, 'Sách bài tập Ngữ văn 11 Gồm các bài tập về phân tích văn bản, viết đoạn văn, và các bài tập ngữ pháp. Các bài tập được thiết kế để giúp học sinh phát triển kỹ năng đọc hiểu và viết văn. Mỗi bài tập đều có hướng dẫn chi tiết và ví dụ minh họa, giúp học sinh dễ dàng theo dõi và tự học.'),
(43, 1, 'Sinh học 11', './assets/img/products/sach-giao-khoa-sinh-hoc-11.jpg', 'Lớp 11', 12336, 'Sách giáo khoa Sinh học 11 do Nhà xuất bản Giáo dục Việt Nam phát hành bao gồm các chủ đề về sinh học tế bào, di truyền học, và sinh thái học. Học sinh sẽ học về cấu trúc và chức năng của tế bào, các quy luật di truyền, và mối quan hệ giữa các sinh vật trong hệ sinh thái. Cuốn sách cung cấp các định nghĩa, định lý và công thức quan trọng, cùng với các bài tập từ cơ bản đến nâng cao và các ví dụ minh họa. Sách được sử dụng làm tài liệu giảng dạy cho giáo viên và học tập cho học sinh lớp 11, hỗ trợ học sinh trong việc ôn tập và chuẩn bị cho các kỳ thi quan trọng.'),
(44, 1, 'Ngữ văn 11', './assets/img/products/sach-giao-khoa-ngu-van-tap1-11.jpg', 'Lớp 11', 456610, 'Sách giáo khoa Ngữ văn 11 do Nhà xuất bản Giáo dục Việt Nam phát hành tập trung vào các tác phẩm văn học hiện đại Việt Nam và thế giới, bao gồm văn xuôi và thơ. Học sinh sẽ học về các tác phẩm này, phân tích văn bản và rèn luyện kỹ năng viết văn. Cuốn sách cung cấp các ví dụ minh họa giúp học sinh hiểu rõ hơn về tác phẩm. Sách được sử dụng làm tài liệu giảng dạy cho giáo viên và học tập cho học sinh lớp 11, hỗ trợ học sinh trong việc ôn tập và chuẩn bị cho các kỳ thi quan trọng.');

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
