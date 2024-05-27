-- SanPhamTonKho Table
CREATE TABLE SanPhamTonKho (
   MaSanPham INT AUTO_INCREMENT PRIMARY KEY,
   TenSanPham NVARCHAR(100),
   MaDanhMuc INT,
   HinhSanPham NVARCHAR(255),
   NgayNhap DATE,
   SoLuong INT,
   TinhTrang NVARCHAR(50)
);

-- SanPhamDangBan Table
CREATE TABLE SanPhamDangBan (
   MaSanPham INT AUTO_INCREMENT PRIMARY KEY,
   TenSanPham NVARCHAR(100),
   HinhSanPham NVARCHAR(255),
   MaDanhMuc INT,
   MoTaSanPham NVARCHAR(4000),
   SoLuongTrongCuaHang INT,
   SoLuongDaBan INT,
   GiaNiemYet DECIMAL(18, 2),
   MaKhuyenMai INT,
   DoanhThu DECIMAL(18, 2)
);

ALTER TABLE SanPhamDangBan
ADD FOREIGN KEY (MaSanPham) REFERENCES SanPhamTonKho(MaSanPham);

-- DanhGiaSanPham Table
CREATE TABLE DanhGiaSanPham (
   MaSanPham INT,
   MaNguoiDanhGia INT,
   NoiDungDanhGia NVARCHAR(4000),
   NgayDanhGia DATE,
   PRIMARY KEY (MaSanPham, MaNguoiDanhGia)
);

ALTER TABLE DanhGiaSanPham
ADD FOREIGN KEY (MaSanPham) REFERENCES SanPhamDangBan(MaSanPham);

-- KhuyenMai Table
CREATE TABLE KhuyenMai (
   MaKhuyenMai INT AUTO_INCREMENT PRIMARY KEY,
   TenKhuyenMai NVARCHAR(100),
   GiaTriKhuyenMai DECIMAL(18, 2),
   TinhTrang NVARCHAR(50),
   LoaiKhuyenMai NVARCHAR(50)
);

-- HoaDon Table
CREATE TABLE HoaDon (
   MaHoaDon INT AUTO_INCREMENT PRIMARY KEY,
   TongGiaTriHoaDon DECIMAL(18, 2),
   NgayXuat DATE,
   MaKhachHang INT,
   MaKhuyenMai INT,
   MaNhanVien INT
);

ALTER TABLE HoaDon
ADD FOREIGN KEY (MaKhuyenMai) REFERENCES KhuyenMai(MaKhuyenMai);

-- ChiTietHoaDon Table
CREATE TABLE ChiTietHoaDon (
   MaHoaDon INT,
   MaSanPham INT,
   SoLuong INT,
   TongGia DECIMAL(18, 2),
   PRIMARY KEY (MaHoaDon, MaSanPham)
);

ALTER TABLE ChiTietHoaDon
ADD FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon);

ALTER TABLE ChiTietHoaDon
ADD FOREIGN KEY (MaSanPham) REFERENCES SanPhamDangBan(MaSanPham);

-- DonHang Table
CREATE TABLE DonHang (
   MaHoaDon INT AUTO_INCREMENT PRIMARY KEY,
   MaKhachHang INT,
   SDTKhachHang NVARCHAR(15),
   DiaChiKhachHang NVARCHAR(255),
   TinhTrang NVARCHAR(50)
);

ALTER TABLE DonHang
ADD FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon);

-- ChienLuocTiepThi Table
CREATE TABLE ChienLuocTiepThi (
   MaChienLuoc INT AUTO_INCREMENT PRIMARY KEY,
   MaDanhMuc INT,
   TenChienLuoc NVARCHAR(100),
   NoiDungChienLuoc NVARCHAR(4000),
   MaNguoiBienSoan INT,
   NgayLap DATE
);

-- TaiKhoan Table
CREATE TABLE TaiKhoan (
   MaTaiKhoan INT AUTO_INCREMENT PRIMARY KEY,
   TenTaiKhoan NVARCHAR(50),
   MatKhau NVARCHAR(255),
   NgayLap DATE,
   LoaiTaiKhoan NVARCHAR(50)
);

-- KhachHang Table
CREATE TABLE KhachHang (
   MaKhachHang INT AUTO_INCREMENT PRIMARY KEY,
   MaTaiKhoan INT,
   HinhDaiDien NVARCHAR(255),
   GioHang INT UNIQUE,
   TenKhachHang NVARCHAR(100),
   NgaySinh DATE,
   DiaChi NVARCHAR(255),
   SoDienThoai NVARCHAR(15),
   DiemTichLuy INT,
   TongGiaTriHoaDon DECIMAL(18, 2)
);

ALTER TABLE KhachHang
ADD FOREIGN KEY (MaTaiKhoan) REFERENCES TaiKhoan(MaTaiKhoan);

-- GioHang Table
CREATE TABLE GioHang (
   MaGioHang INT AUTO_INCREMENT PRIMARY KEY,
   MaKhachHang INT UNIQUE
);

ALTER TABLE GioHang
ADD FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang);

-- ChiTietGioHang Table
CREATE TABLE ChiTietGioHang (
   MaGioHang INT,
   MaSanPham INT,
   SoLuong INT,
   PRIMARY KEY (MaGioHang, MaSanPham)
);

ALTER TABLE ChiTietGioHang
ADD FOREIGN KEY (MaGioHang) REFERENCES GioHang(MaGioHang);

ALTER TABLE ChiTietGioHang
ADD FOREIGN KEY (MaSanPham) REFERENCES SanPhamDangBan(MaSanPham);

-- NhanVien Table
CREATE TABLE NhanVien (
   MaNhanVien INT AUTO_INCREMENT PRIMARY KEY,
   TenNhanVien NVARCHAR(100),
   HinhDaiDien NVARCHAR(255),
   VaiTro NVARCHAR(50),
   HeSoLuong DECIMAL(5, 2),
   NgaySinh DATE,
   NgayVaoLam DATE
);

ALTER TABLE HoaDon
ADD FOREIGN KEY(MaNhanVien) REFERENCES NhanVien(MaNhanVien)

ALTER TABLE HoaDon
ADD FOREIGN KEY(MaNhanVien) REFERENCES NhanVien(MaNhanVien)

ALTER TABLE HoaDon
ADD FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang);

-- DanhMucSanPham Table
CREATE TABLE DanhMucSanPham (
   MaDanhMuc INT AUTO_INCREMENT PRIMARY KEY,
   TenDanhMuc NVARCHAR(100),
   HinhDanhMuc NVARCHAR(255),
   LoaiDanhMuc NVARCHAR(50),
   MoTaDanhMuc NVARCHAR(4000),
   MaKhuyenMai INT,
   DoanhThu DECIMAL(18, 2)
);

ALTER TABLE SanPhamDangBan
ADD FOREIGN KEY (MaDanhMuc) REFERENCES DanhMucSanPham(MaDanhMuc);

ALTER TABLE SanPhamTonKho
ADD FOREIGN KEY (MaDanhMuc) REFERENCES DanhMucSanPham(MaDanhMuc);

ALTER TABLE ChienLuocTiepThi
ADD FOREIGN KEY (MaDanhMuc) REFERENCES DanhMucSanPham(MaDanhMuc);

-- Chèn dữ liệu cho bảng KhuyenMai
INSERT INTO KhuyenMai (TenKhuyenMai, GiaTriKhuyenMai, TinhTrang, LoaiKhuyenMai)
VALUES
   (N'Giảm giá 10%', 0.1, N'Đang áp dụng', N'Giảm giá'),
   (N'Mua 1 tặng 1', 0.5, N'Đang áp dụng', N'Khuyến mãi'),
   (N'Tích lũy điểm đổi quà', NULL, N'Đang áp dụng', N'Tích điểm');
   
INSERT INTO TaiKhoan (TenTaiKhoan, MatKhau, NgayLap, LoaiTaiKhoan)
VALUES
   (N'admin', N'matkhaunguoilon', '2023-01-01', N'Admin'),
   (N'user1', N'matkhauuser1', '2023-02-15', N'Khách hàng'),
   (N'user2', N'matkhauuser2', '2023-03-20', N'Khách hàng');
   
INSERT INTO KhachHang (MaTaiKhoan, HinhDaiDien, GioHang, TenKhachHang, NgaySinh, DiaChi, SoDienThoai, DiemTichLuy, TongGiaTriHoaDon)
VALUES
   (1, N'hinhdaidien_admin.jpg', 1, N'Nguyễn Văn A', '1990-05-15', N'123 Đường ABC, Quận 1, TP.HCM', N'0912345678', 100, 1000000),
   (2, N'hinhdaidien_user1.jpg', 2, N'Trần Thị B', '1985-09-22', N'456 Đường XYZ, Quận 2, TP.HCM', N'0987654321', 50, 500000),
   (3, N'hinhdaidien_user2.jpg', 3, N'Lê Văn C', '1992-11-05', N'789 Đường PQR, Quận 3, TP.HCM', N'0912345679', 75, 750000);
  
INSERT INTO DanhMucSanPham (TenDanhMuc, HinhDanhMuc, LoaiDanhMuc, MoTaDanhMuc, MaKhuyenMai, DoanhThu)
VALUES
    (N'Trang Sức', N'trang-suc.jpg', N'Trang Sức', N'Các sản phẩm trang sức cao cấp', NULL, 0),
    (N'Dây Chuyền', N'day-chuyen.jpg', N'Trang Sức', N'Các sản phẩm dây chuyền', NULL, 0),
    (N'Vòng Tay', N'vong-tay.jpg', N'Trang Sức', N'Các sản phẩm vòng tay', NULL, 0),
    (N'Nhẫn', N'nhan.jpg', N'Trang Sức', N'Các sản phẩm nhẫn', NULL, 0),
    (N'Lắc Tay', N'lac-tay.jpg', N'Trang Sức', N'Các sản phẩm lắc tay', NULL, 0),
    (N'Bông Tai', N'bong-tai.jpg', N'Trang Sức', N'Các sản phẩm bông tai', NULL, 0);


INSERT INTO SanPhamTonKho (TenSanPham, MaDanhMuc, HinhSanPham, NgayNhap, SoLuong, TinhTrang)
VALUES
    (N'Dây Chuyền Vàng 18K Đính Đá CZ', 2, N'day-chuyen-vang-18k-dinh-da-cz.jpg', '2023-04-01', 30, N'Mới'),
    (N'Vòng Tay Vàng 14K', 3, N'vong-tay-vang-14k.jpg', '2023-04-10', 25, N'Mới'),
    (N'Nhẫn Cưới Vàng 18K Đính Đá CZ', 4, N'nhan-cuoi-vang-18k-dinh-da-cz.jpg', '2023-04-15', 20, N'Mới'),
    (N'Nhẫn Cưới Vàng 18K', 4, N'nhan-cuoi-vang-18k.jpg', '2023-04-20', 15, N'Mới'),
    (N'Nhẫn Cưới Vàng 14K Đính Đá CZ', 4, N'nhan-cuoi-vang-14k-dinh-da-cz.jpg', '2023-04-25', 25, N'Mới'),
    (N'Nhẫn Cưới Vàng 24K Đính Đá CZ', 4, N'nhan-cuoi-vang-24k-dinh-da-cz.jpg', '2023-05-01', 15, N'Mới'),
    (N'Nhẫn Cưới Bạch Kim Đính Đá CZ', 4, N'nhan-cuoi-bach-kim-dinh-da-cz.jpg', '2023-05-05', 20, N'Mới'),
    (N'Nhẫn Đính Đá Sapphire', 4, N'nhan-dinh-da-sapphire.jpg', '2023-05-10', 12, N'Mới'),
    (N'Dây Chuyền Vàng 24K', 2, N'day-chuyen-vang-24k.jpg', '2023-05-25', 18, N'Mới'),
    (N'Dây Chuyền Vàng 18K Đính Đá Ruby', 2, N'day-chuyen-vang-18k-dinh-da-ruby.jpg', '2023-05-28', 15, N'Mới'),
    (N'Dây Chuyền Bạch Kim', 2, N'day-chuyen-bach-kim.jpg', '2023-06-01', 20, N'Mới'),
    (N'Dây Chuyền Vàng Trắng 14K', 2, N'day-chuyen-vang-trang-14k.jpg', '2023-06-05', 12, N'Mới'),
    (N'Dây Chuyền Vàng 18K Đính Đá Emerald', 2, N'day-chuyen-vang-18k-dinh-da-emerald.jpg', '2023-06-10', 10, N'Mới'),
    (N'Lắc Tay Bạc Đính Đá PNJSilver Fantasia', 5, N'lac-tay-bac-dinh-da-pnjsilver-fantasia.jpg', '2024-05-18', 30, N'Mới'),
    (N'Lắc Tay Bạc Ý PNJSilver', 5, N'lac-tay-bac-y-pnjsilver.jpg', '2024-05-18', 25, N'Mới'),
    (N'Vòng Tay Bạc PNJSilver Friendzone Breaker Hình Chữ Love', 3, N'vong-tay-bac-pnjsilver-friendzone-breaker-hinh-chu-love.jpg', '2024-05-18', 20, N'Mới'),
    (N'Lắc Tay Trẻ Em Bạc PNJSilver Juice Me Up', 5, N'lac-tay-tre-em-bac-pnjsilver-juice-me-up.jpg', '2024-05-18', 15, N'Mới'),
    (N'Vòng Tay Bạc Đính Đá PNJSilver XMXMK', 3, N'vong-tay-bac-dinh-da-pnjsilver-xmxmk.jpg', '2024-05-18', 10, N'Mới'),
    (N'Bông tai Vàng Trắng 14K đính Ngọc trai Freshwater PNJ PFXMW000415', 6, N'bong-tai-vang-trang-14k-dinh-ngoc-trai-freshwater-pnj-pfxmw000415.jpg', '2023-06-20', 30, N'Mới'),
    (N'Bông tai Bạc đính Ngọc trai STYLE By PNJ Edgy PMMXW000003', 6, N'bong-tai-bac-dinh-ngoc-trai-style-by-pnj-edgy-pmmxw000003.jpg', '2023-06-21', 25, N'Mới'),
    (N'Bông tai Vàng Trắng 14K đính Ngọc trai Freshwater PNJ PFXMW000311', 6, N'bong-tai-vang-trang-14k-dinh-ngoc-trai-freshwater-pnj-pfxmw000311.jpg', '2023-06-22', 20, N'Mới'),
    (N'Bông tai Bạc đính đá CZ PNJSilver Fantasy XMZMW000052', 6, N'bong-tai-bac-dinh-da-cz-pnjsilver-fantasy-xmzmw000052.jpg', '2023-06-23', 30, N'Mới'),
    (N'Bông tai Vàng Trắng 14K đính đá ECZ Swarovski PNJ XMXMY000120', 6, N'bong-tai-vang-trang-14k-dinh-da-ecz-swarovski-pnj-xmxmy000120.jpg', '2023-06-24', 25, N'Mới');

INSERT INTO SanPhamDangBan (MaSanPham, TenSanPham, HinhSanPham, MaDanhMuc, MoTaSanPham, SoLuongTrongCuaHang, SoLuongDaBan, GiaNiemYet, MaKhuyenMai, DoanhThu)
VALUES
    (1, N'Dây Chuyền Vàng 18K Đính Đá CZ', N'day-chuyen-vang-18k-dinh-da-cz.jpg', 2, N'Dây chuyền vàng 18K đính đá CZ lấp lánh, thiết kế sang trọng và quý phái.', 25, 5, 5000000, 1, 25000000),
    (2, N'Vòng Tay Vàng 14K', N'vong-tay-vang-14k.jpg', 3, N'Vòng tay vàng 14K trơn đẹp, kiểu dáng đơn giản nhưng tinh tế.', 20, 5, 3000000, 2, 15000000),
    (3, N'Nhẫn Cưới Vàng 18K Đính Đá CZ', N'nhan-cuoi-vang-18k-dinh-da-cz.jpg', 4, N'Nhẫn cưới vàng 18K đính đá CZ, thiết kế tinh tế và sang trọng.', 18, 2, 8900000, NULL, 17800000),
    (4, N'Nhẫn Cưới Vàng 18K', N'nhan-cuoi-vang-18k.jpg', 4, N'Nhẫn cưới vàng 18K trơn đẹp, kiểu dáng hiện đại và thanh lịch.', 12, 3, 7200000, 1, 19440000),
    (5, N'Nhẫn Cưới Vàng 14K Đính Đá CZ', N'nhan-cuoi-vang-14k-dinh-da-cz.jpg', 4, N'Nhẫn cưới vàng 14K đính đá CZ, sự kết hợp hoàn hảo giữa sang trọng và đẳng cấp.', 22, 3, 6500000, NULL, 19500000),
    (9, N'Dây Chuyền Vàng 24K', N'day-chuyen-vang-24k.jpg', 2, N'Dây chuyền vàng 24K trơn đẹp, thiết kế sang trọng và quý phái.', 16, 2, 15000000, 1, 30000000),
    (10, N'Dây Chuyền Vàng 18K Đính Đá Ruby', N'day-chuyen-vang-18k-dinh-da-ruby.jpg', 2, N'Dây chuyền vàng 18K đính đá Ruby quý hiếm, sự lựa chọn hoàn hảo cho những dịp đặc biệt.', 13, 2, 20000000, NULL, 40000000),
    (11, N'Dây Chuyền Bạch Kim', N'day-chuyen-bach-kim.jpg', 2, N'Dây chuyền bạch kim trơn đẹp, thiết kế trang nhã và sang trọng.', 18, 2, 12000000, 2, 24000000),
    (12, N'Dây Chuyền Vàng Trắng 14K', N'day-chuyen-vang-trang-14k.jpg', 2, N'Dây chuyền vàng trắng 14K đơn giản nhưng tinh tế, phù hợp với mọi phong cách.', 10, 2, 10000000, NULL, 20000000),
    (13, N'Dây Chuyền Vàng 18K Đính Đá Emerald', N'day-chuyen-vang-18k-dinh-da-emerald.jpg', 2, N'Dây chuyền vàng 18K đính đá Emerald xanh ngọc, sự kết hợp hoàn hảo giữa vàng và đá quý.', 8, 2, 25000000, 3, 50000000),
    (14, N'Lắc Tay Bạc Đính Đá PNJSilver Fantasia', N'lac-tay-bac-dinh-da-pnjsilver-fantasia.jpg', 5, N'Lắc tay bạc đính đá PNJSilver Fantasia thiết kế tinh tế và sang trọng.', 25, 5, 535000, 1, 2675000),
    (15, N'Lắc Tay Bạc Ý PNJSilver', N'lac-tay-bac-y-pnjsilver.jpg', 5, N'Lắc tay bạc Ý PNJSilver với thiết kế đơn giản nhưng rất tinh tế.', 20, 5, 1455000, 2, 7275000),
    (16, N'Vòng Tay Bạc PNJSilver Friendzone Breaker Hình Chữ Love', N'vong-tay-bac-pnjsilver-friendzone-breaker-hinh-chu-love.jpg', 3, N'Vòng tay bạc PNJSilver Friendzone Breaker với thiết kế hình chữ Love đặc biệt.', 18, 2, 733000, NULL, 1466000),
    (17, N'Lắc Tay Trẻ Em Bạc PNJSilver Juice Me Up', N'lac-tay-tre-em-bac-pnjsilver-juice-me-up.jpg', 5, N'Lắc tay trẻ em bạc PNJSilver Juice Me Up dễ thương và an toàn cho bé.', 13, 2, 499000, 1, 998000),
    (18, N'Vòng Tay Bạc Đính Đá PNJSilver XMXMK', N'vong-tay-bac-dinh-da-pnjsilver-xmxmk.jpg', 3, N'Vòng tay bạc đính đá PNJSilver XMXMK lấp lánh, thiết kế sang trọng.', 8, 2, 1475000, 3, 2950000),
    (19, N'Bông tai Vàng Trắng 14K đính Ngọc trai Freshwater PNJ PFXMW000415', N'bong-tai-vang-trang-14k-dinh-ngoc-trai-freshwater-pnj-pfxmw000415.jpg', 6, N'Bông tai vàng trắng 14K đính ngọc trai Freshwater, thiết kế sang trọng và tinh tế.', 30, 0, 4500000, 1, 0),
    (20, N'Bông tai Bạc đính Ngọc trai STYLE By PNJ Edgy PMMXW000003', N'bong-tai-bac-dinh-ngoc-trai-style-by-pnj-edgy-pmmxw000003.jpg', 6, N'Bông tai bạc đính ngọc trai STYLE By PNJ Edgy, phong cách trẻ trung và hiện đại.', 25, 0, 1200000, 2, 0),
    (21, N'Bông tai Vàng Trắng 14K đính Ngọc trai Freshwater PNJ PFXMW000311', N'bong-tai-vang-trang-14k-dinh-ngoc-trai-freshwater-pnj-pfxmw000311.jpg', 6, N'Bông tai vàng trắng 14K đính ngọc trai Freshwater, sự lựa chọn hoàn hảo cho quý cô thanh lịch.', 20, 0, 5000000, 3, 0),
    (22, N'Bông tai Bạc đính đá CZ PNJSilver Fantasy XMZMW000052', N'bong-tai-bac-dinh-da-cz-pnjsilver-fantasy-xmzmw000052.jpg', 6, N'Bông tai bạc đính đá CZ PNJSilver Fantasy, thiết kế độc đáo và cuốn hút.', 30, 0, 800000, NULL, 0),
    (23, N'Bông tai Vàng Trắng 14K đính đá ECZ Swarovski PNJ XMXMY000120', N'bong-tai-vang-trang-14k-dinh-da-ecz-swarovski-pnj-xmxmy000120.jpg', 6, N'Bông tai vàng trắng 14K đính đá ECZ Swarovski, mang đến vẻ đẹp lấp lánh và sang trọng.', 25, 0, 3000000, 1, 0);

   
INSERT INTO DanhGiaSanPham (MaSanPham, MaNguoiDanhGia, NoiDungDanhGia, NgayDanhGia)
VALUES
    (1, 2, N'Dây chuyền đẹp, vàng 18K sáng bóng và đá CZ lấp lánh.', '2023-05-01'),
    (2, 3, N'Vòng tay vàng 14K đơn giản nhưng rất tinh tế và sang trọng.', '2023-05-05'),
    (3, 1, N'Nhẫn cưới đẹp, thiết kế tinh xảo và sang trọng.', '2023-05-10'),
    (11, 2, N'Dây chuyền vàng 24K trơn đẹp, sáng bóng và sang trọng.', '2023-05-28'),
    (12, 3, N'Dây chuyền đính đá Ruby quý hiếm, thiết kế tinh xảo và đẳng cấp.', '2023-06-01'),
    (13, 1, N'Dây chuyền bạch kim trơn đẹp, trang nhã và thanh lịch.', '2023-06-05'),
    (14, 2, N'Dây chuyền vàng trắng 14K đơn giản nhưng rất tinh tế.', '2023-06-08'),
    (15, 3, N'Dây chuyền đính đá Emerald xanh ngọc, sự kết hợp hoàn hảo giữa vàng và đá quý.', '2023-06-12');

INSERT INTO HoaDon (TongGiaTriHoaDon, NgayXuat, MaKhachHang, MaKhuyenMai, MaNhanVien)
VALUES
    (1000000, '2023-05-01', 1, 1, 1),
    (500000, '2023-05-10', 2, 2, 2),
    (750000, '2023-05-15', 3, 1, 2),
    (2000000, '2023-05-20', 1, null, 3),
    (1500000, '2023-05-25', 2, 3, 3),
    (3000000, '2023-06-01', 3, 1, 1),
    (5000000, '2023-06-05', 1, 2, 3),
    (1200000, '2023-06-10', 2, null, 4),
    (1000000, '2023-06-15', 3, 3, 4),
    (2500000, '2023-06-20', 1, 1, 1);

INSERT INTO ChiTietHoaDon (MaHoaDon, MaSanPham, SoLuong, TongGia)
VALUES
    (1, 1, 1, 5000000),
    (1, 2, 1, 3000000),
    (2, 3, 1, 8900000),
    (3, 4, 2, 14400000),
    (4, 5, 1, 6500000),
    (5, 9, 1, 15000000),
    (6, 10, 1, 20000000),
    (7, 11, 1, 12000000),
    (8, 12, 1, 10000000),
    (9, 13, 1, 25000000),
    (10, 14, 1, 535000);
   
INSERT INTO NhanVien (TenNhanVien, HinhDaiDien, VaiTro, HeSoLuong, NgaySinh, NgayVaoLam)
VALUES
    (N'Nguyễn Văn B', N'nhanvien_nguyen_van_b.jpg', N'Quản lý', 3.5, '1980-08-15', '2020-01-01'),
    (N'Trần Thị C', N'nhanvien_tran_thi_c.jpg', N'Bán hàng', 2.0, '1990-05-20', '2021-03-10'),
    (N'Lê Văn D', N'nhanvien_le_van_d.jpg', N'Thủ kho', 2.8, '1985-07-25', '2022-05-15'),
    (N'Phạm Thị E', N'nhanvien_pham_thi_e.jpg', N'Nhân viên kỹ thuật', 2.5, '1992-11-30', '2023-02-20');

INSERT INTO GioHang (MaKhachHang)
VALUES
    (1),
    (2),
    (3);
   
INSERT INTO ChiTietGioHang (MaGioHang, MaSanPham, SoLuong)
VALUES
    (1, 1, 2),
    (1, 3, 1),
    (2, 2, 1),
    (2, 5, 3),
    (3, 4, 2),
    (3, 5, 1);

INSERT INTO DonHang (MaHoaDon, MaKhachHang, SDTKhachHang, DiaChiKhachHang, TinhTrang)
VALUES
    (1, 1, N'0912345678', N'123 Đường ABC, Quận 1, TP.HCM', N'Hoàn thành'),
    (2, 2, N'0987654321', N'456 Đường XYZ, Quận 2, TP.HCM', N'Đang xử lý'),
    (3, 3, N'0912345679', N'789 Đường PQR, Quận 3, TP.HCM', N'Đã hủy'),
    (4, 1, N'0912345678', N'123 Đường ABC, Quận 1, TP.HCM', N'Hoàn thành'),
    (5, 2, N'0987654321', N'456 Đường XYZ, Quận 2, TP.HCM', N'Đang xử lý'),
    (6, 3, N'0912345679', N'789 Đường PQR, Quận 3, TP.HCM', N'Hoàn thành'),
    (7, 1, N'0912345678', N'123 Đường ABC, Quận 1, TP.HCM', N'Đang xử lý'),
    (8, 2, N'0987654321', N'456 Đường XYZ, Quận 2, TP.HCM', N'Hoàn thành'),
    (9, 3, N'0912345679', N'789 Đường PQR, Quận 3, TP.HCM', N'Đã hủy'),
    (10, 1, N'0912345678', N'123 Đường ABC, Quận 1, TP.HCM', N'Hoàn thành');

INSERT INTO ChienLuocTiepThi (MaDanhMuc, TenChienLuoc, NoiDungChienLuoc, MaNguoiBienSoan, NgayLap)
VALUES
    (1, N'Chiến lược quảng cáo trang sức', N'Tăng cường quảng cáo trên mạng xã hội và Google.', 1, '2023-01-10'),
    (2, N'Chiến lược khuyến mãi dây chuyền', N'Triển khai chương trình giảm giá cho các sản phẩm dây chuyền.', 1, '2023-02-15'),
    (3, N'Chiến lược tăng doanh số vòng tay', N'Tặng quà kèm khi mua vòng tay.', 2, '2023-03-20');

