
-- Xóa sản phẩm khỏi bảng SanPhamDangBan -> Xóa các bản ghi tương ứng trong bảng DanhGiaSanPham, ChiTietHoaDon và ChiTietGioHang, Thay đổi số lượng tồn kho
DELIMITER $$
create or alter  PROCEDURE DeleteProduct(IN product_id INT)
BEGIN
    DECLARE product_quantity INT;
    
    -- Lấy số lượng tồn kho của sản phẩm
    SELECT SoLuongTrongCuaHang INTO product_quantity
    FROM SanPhamDangBan
    WHERE MaSanPham = product_id;
    
    -- Xóa bản ghi khỏi bảng DanhGiaSanPham
    DELETE FROM DanhGiaSanPham
    WHERE MaSanPham = product_id;
    
    -- Xóa bản ghi khỏi bảng ChiTietGioHang
    DELETE FROM ChiTietGioHang
    WHERE MaSanPham = product_id;
   
   -- Xoa bản ghi khỏi bảng ChiTietHoaDon 
    DELETE FROM ChiTietHoaDon
    WHERE MaSanPham = product_id;
    
    -- Xóa bản ghi khỏi bảng SanPhamDangBan
    DELETE FROM SanPhamDangBan
    WHERE MaSanPham = product_id;
    
    -- Thay đổi số lượng tồn kho trong bảng SanPhamTonKho
    UPDATE SanPhamTonKho
    SET SoLuong = SoLuong + product_quantity
    WHERE MaSanPham = product_id;
END$$
DELIMITER ;

-- CALL DeleteProduct(1);
-- 
-- DROP PROCEDURE IF EXISTS AddProduct;

-- Thêm Sản Phẩm = >  Cập nhật số lượng tồn kho  trong bảng SanPhamTonKho ( nếu mã sản phẩm đã có trong SanPhamTonKho thì sẽ tăng lên số lượng nếu chưa sẽ thêm mới)
DELIMITER $$
create  PROCEDURE AddProduct(
    IN p_MaSanPham INT,
    IN p_TenSanPham NVARCHAR(100),
    IN p_MaDanhMuc INT,
    IN p_HinhSanPham NVARCHAR(255),
    IN p_NgayNhap DATE,
    IN p_SoLuong INT,
    IN p_TinhTrang NVARCHAR(50)
)
BEGIN
    DECLARE product_exists INT DEFAULT 0;
    DECLARE result NVARCHAR(100);
    
    -- Kiểm tra xem mã sản phẩm đã tồn tại hay chưa
    SELECT COUNT(*) INTO product_exists
    FROM SanPhamTonKho
    WHERE MaSanPham = p_MaSanPham;
    
    IF product_exists > 0 THEN
        -- Nếu mã sản phẩm đã tồn tại, tăng số lượng
        UPDATE SanPhamTonKho
        SET SoLuong = SoLuong + p_SoLuong
        WHERE MaSanPham = p_MaSanPham;
        set result = N'Đã Cập Nhật Số Lượng Tồn Kho';
    ELSE
        -- Nếu mã sản phẩm chưa tồn tại, thêm mới
        INSERT INTO SanPhamTonKho (MaSanPham, TenSanPham, MaDanhMuc, HinhSanPham, NgayNhap, SoLuong, TinhTrang)
        VALUES (p_MaSanPham, p_TenSanPham, p_MaDanhMuc, p_HinhSanPham, p_NgayNhap, p_SoLuong, p_TinhTrang);
        set result = N'Đã Thêm Vào Sản Phẩm Mới';
    END IF;
    SELECT result;
END$$
DELIMITER ;

-- CALL AddProduct(1, 'Sản phẩm A', 1, 'hinhanh.jpg', '2023-05-27', 1, 'Mới');

-- Thay đổi số lượng bán 

DELIMITER $$
CREATE PROCEDURE UpdateProductQuantity(
    IN p_MaSanPham INT,
    IN p_SoLuongThayDoi INT
)
BEGIN
    DECLARE current_stock INT;
    DECLARE current_selling INT;
    DECLARE total_quantity INT;
    DECLARE result NVARCHAR(100);

    -- Lấy số lượng tồn kho hiện tại
    SELECT SoLuong INTO current_stock
    FROM SanPhamTonKho
    WHERE MaSanPham = p_MaSanPham;

    -- Lấy số lượng đang bán hiện tại
    SELECT SoLuongTrongCuaHang INTO current_selling
    FROM SanPhamDangBan
    WHERE MaSanPham = p_MaSanPham;

    SET total_quantity = current_stock + current_selling;

    -- Kiểm tra điều kiện số lượng thay đổi
    IF p_SoLuongThayDoi > total_quantity THEN
        SET result = N'Không phù hợp';
    ELSEIF p_SoLuongThayDoi < 0 THEN
        SET result = N'Không phù hợp';
    ELSE
        -- Cập nhật số lượng tồn kho
        UPDATE SanPhamTonKho
        SET SoLuong = SoLuong - (p_SoLuongThayDoi - current_selling)
        WHERE MaSanPham = p_MaSanPham;

        -- Cập nhật số lượng đang bán
        UPDATE SanPhamDangBan
        SET SoLuongTrongCuaHang = p_SoLuongThayDoi,
            SoLuongDaBan = SoLuongDaBan + (current_selling - p_SoLuongThayDoi)
        WHERE MaSanPham = p_MaSanPham;

        SET result = 'Thay đổi thành công';
    END IF;

    SELECT result;
END$$
DELIMITER ;

-- CALL UpdateProductQuantity(1, 20);

DELIMITER $$
CREATE TRIGGER delete_product_from_categories
BEFORE DELETE ON DanhMucSanPham
FOR EACH ROW
BEGIN
    -- Xóa bản ghi trong bảng SanPhamTonKho
    DELETE FROM SanPhamTonKho
    WHERE MaDanhMuc = OLD.MaDanhMuc;

    -- Lấy danh sách MaSanPham từ bảng SanPhamDangBan
    DROP TEMPORARY TABLE IF EXISTS temp_product_ids;
    CREATE TEMPORARY TABLE temp_product_ids (
        MaSanPham INT
    );
    INSERT INTO temp_product_ids (MaSanPham)
    SELECT MaSanPham
    FROM SanPhamDangBan
    WHERE MaDanhMuc = OLD.MaDanhMuc;

    -- Xóa bản ghi trong bảng SanPhamDangBan
    DELETE FROM SanPhamDangBan
    WHERE MaDanhMuc = OLD.MaDanhMuc;

    -- Xóa bản ghi trong bảng DanhGiaSanPham
    DELETE FROM DanhGiaSanPham
    WHERE MaSanPham IN (SELECT MaSanPham FROM temp_product_ids);

    -- Xóa bản ghi trong bảng ChiTietGioHang
    DELETE FROM ChiTietGioHang
    WHERE MaSanPham IN (SELECT MaSanPham FROM temp_product_ids);

    -- Xóa bản ghi trong bảng ChiTietHoaDon
    DELETE FROM ChiTietHoaDon
    WHERE MaSanPham IN (SELECT MaSanPham FROM temp_product_ids);

    -- Xóa bảng tạm
    DROP TEMPORARY TABLE IF EXISTS temp_product_ids;
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER update_product_info
AFTER UPDATE ON SanPhamDangBan
FOR EACH ROW
BEGIN
    UPDATE SanPhamTonKho
    SET TenSanPham = NEW.TenSanPham,
        HinhSanPham = NEW.HinhSanPham
    WHERE MaSanPham = NEW.MaSanPham;
END$$
DELIMITER ;

SELECT MaSanPham, sum(SoLuong)
FROM ChiTietHoaDon
group by MaSanPham


DELIMITER $$
CREATE PROCEDURE CheckoutOrder(
    IN p_MaHoaDon INT,
    IN p_TinhTrang NVARCHAR(50)
)
BEGIN
    DECLARE product_id INT;
    DECLARE quantity INT;
    DECLARE remaining_quantity INT;
    declare SumCheck INT;

    -- Lấy danh sách sản phẩm và số lượng từ hóa đơn
    DROP TEMPORARY TABLE IF EXISTS temp_order_details;
    CREATE TEMPORARY TABLE temp_order_details (
        MaSanPham INT,
        SoLuong INT
    );

    INSERT INTO temp_order_details (MaSanPham, SoLuong)
    SELECT MaSanPham,  SoLuong
    
    FROM ChiTietHoaDon
    WHERE MaHoaDon = p_MaHoaDon;

    -- Cập nhật tình trạng đơn hàng
    UPDATE DonHang
    SET TinhTrang = p_TinhTrang
    WHERE MaHoaDon = p_MaHoaDon;

    -- Cập nhật số lượng tồn kho
    WHILE EXISTS (SELECT 1 FROM temp_order_details) DO
        SELECT MaSanPham, SoLuong INTO product_id, quantity
        FROM temp_order_details
        LIMIT 1;
		
        -- Trừ số lượng tồn kho trong bảng SanPhamTonKho
        UPDATE SanPhamTonKho
        SET SoLuong = GREATEST(0, SoLuong - quantity)
        WHERE MaSanPham = product_id;
		
        -- Lấy số lượng còn lại sau khi trừ từ bảng SanPhamTonKho
        SELECT GREATEST(0, quantity - SoLuong) INTO remaining_quantity
        FROM SanPhamTonKho
        WHERE MaSanPham = product_id;

        -- Trừ số lượng trong bảng SanPhamDangBan
        UPDATE SanPhamDangBan
        SET SoLuongTrongCuaHang = SoLuongTrongCuaHang - quantity,
            SoLuongDaBan = SoLuongDaBan + quantity - remaining_quantity
        WHERE MaSanPham = product_id;

        DELETE FROM temp_order_details
        WHERE MaSanPham = product_id;
    END WHILE;

    -- Xóa bảng tạm
    DROP TEMPORARY TABLE IF EXISTS temp_order_details;
END$$
DELIMITER ;
-- CALL CheckoutOrder(1, 'Đã thanh toán');



-- Hủy hóa đơn => => Xóa HoaDon => xóa DonHang( nếu tình trạng là "Đã thanh toán" thì không thể rollback và trả về "Không thể hủy", nếu không phải thì tiến hành xóa luôn DonHang và ChiTietHoaDon
DELIMITER $$
CREATE PROCEDURE HuyHoaDon(IN hoadon_id INT)
BEGIN
    DECLARE status_donhang VARCHAR(50);
    
    -- Kiểm tra tình trạng của DonHang
    SELECT TinhTrang INTO status_donhang
    FROM DonHang
    WHERE MaHoaDon = hoadon_id;
    
    IF status_donhang = 'Đã thanh toán' THEN
        SELECT 'Không thể hủy' AS 'Thông báo';
    ELSE
        -- Xóa ChiTietHoaDon
        DELETE FROM ChiTietHoaDon
        WHERE MaHoaDon = hoadon_id;
        
        -- Xóa DonHang
        DELETE FROM DonHang
        WHERE MaHoaDon = hoadon_id;
        -- Xóa HoaDon
       
        DELETE FROM HoaDon
        WHERE MaHoaDon = hoadon_id;
        
        SELECT 'Hủy hóa đơn thành công' AS 'Thông báo';
    END IF;
END$$
DELIMITER ;

-- CALL HuyHoaDon(2); -- Thay 1 bằng MaHoaDon cần hủy

-- drop trigger trig_insert_hoadon


DELIMITER $$
CREATE TRIGGER trig_insert_khachhang
AFTER INSERT ON KhachHang
FOR EACH ROW
BEGIN
    DECLARE random_manhanvien INT;
	-- Tạo giỏ hàng mới
	
    INSERT INTO GioHang (MaKhachHang)
    VALUES (NEW.MaKhachHang);

    -- Tạo hóa đơn mới
    INSERT INTO HoaDon (MaKhachHang)
    VALUES (NEW.MaKhachHang);

    -- Gán nhân viên ngẫu nhiên cho hóa đơn mới
    SELECT MaNhanVien INTO random_manhanvien
    FROM NhanVien
    ORDER BY RAND()
    LIMIT 1;

    UPDATE HoaDon
    SET MaNhanVien = random_manhanvien
    WHERE MaKhachHang = NEW.MaKhachHang
    ORDER BY MaHoaDon DESC
    LIMIT 1;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE CapNhatGioHang(
    IN p_MaKhachHang INT,
    IN p_MaSanPham INT,
    IN p_SoLuong INT
)
BEGIN
    DECLARE v_MaGioHang INT;
    DECLARE v_GiaNiemYet DECIMAL(18, 2);

    -- Lấy MaGioHang của khách hàng
    SELECT MaGioHang INTO v_MaGioHang
    FROM GioHang 
    WHERE MaKhachHang = p_MaKhachHang;

    -- Lấy GiaNiemYet của sản phẩm
    SELECT GiaNiemYet INTO v_GiaNiemYet
    FROM SanPhamDangBan
    WHERE MaSanPham = p_MaSanPham;

    -- Chuyển từ ChiTietGioHang sang ChiTietHoaDon
    INSERT INTO ChiTietHoaDon (MaHoaDon, MaSanPham, SoLuong, TongGia)
    SELECT MaHoaDon, p_MaSanPham, p_SoLuong, p_SoLuong * v_GiaNiemYet
    FROM HoaDon
    WHERE MaKhachHang = p_MaKhachHang
    ORDER BY MaHoaDon DESC
    LIMIT 1;

    -- Cập nhật ChiTietGioHang
    IF p_SoLuong = 0 THEN
        DELETE FROM ChiTietGioHang
        WHERE MaGioHang = v_MaGioHang
          AND MaSanPham = p_MaSanPham;
    ELSE
        UPDATE ChiTietGioHang
        SET SoLuong = SoLuong - p_SoLuong
        WHERE MaGioHang = v_MaGioHang
          AND MaSanPham = p_MaSanPham;
    END IF;
END$$
DELIMITER ;

-- CALL CapNhatGioHang(1, 2, 3);