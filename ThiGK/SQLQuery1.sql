Create database BanHangABC_CaoNguyenQuocLam
go
CREATE TABLE KhachHang(
	MaKH		VARCHAR(50) PRIMARY KEY,
	HoKH		VARCHAR(100),
	TenKH		VARCHAR(20),
	GioiTinh	VARCHAR(10),
	DiaChi		VARCHAR(100),
	DienThoai	NUMERIC(10,0),
);
GO
INSERT INTO KhachHang VALUES
('K001','Cao Nguyen', 'Quoc Lam','Nam', '2 Nguyen Đinh Chieu - Nha Trang, Khanh Hoa','0911992209'),
('K002','Nguyen', ' Khiet Dan','Nu', '2 Van Don -Nha Trang - Khanh Hoa','0911900000'),
('K003','Le', ' Minh Thanh','Nam', '2 Quang Trung -Nha Trang - Khanh Hoa','0966575778');
Go

CREATE TABLE HangHoa(
	MaHH		VARCHAR(50) PRIMARY KEY,
	TenHH		VARCHAR(120),
	NhaCC		VARCHAR(50),
	SoLuongKho	INT,
	DonGia		INT,
);
GO
INSERT INTO HangHoa VALUES
('TV001','Ti vi sony bravia 43 inches', 'FBT', 100 ,10000000 ),
('MG002','May giat Samsung XT48', 'Nguyen Kim', 500, 20000000 ),
('TL003','Tu lanh ToShiBa', 'FBT', 105, 30000000 );

go
CREATE TABLE HoaDonBan(
	SoHD 		VARCHAR(50) PRIMARY KEY,
	NgayBan		DATE,
	MaKH 		VARCHAR(50),
	TinhTrang	BIT,
	CONSTRAINT FK_KH FOREIGN KEY (MaKH) REFERENCES KhachHang (MaKH)
);
GO
INSERT INTO HoaDonBan VALUES
('HD0001','2020/03/20', 'K001',0 ),
('HD0002','2019/03/20', 'K002',1),
('HD0003','2017/03/20', 'K003',1 );
go
CREATE TABLE CTHDB(
	SoHD 		VARCHAR(50),
	MaHH 		VARCHAR(50),
	SoLuongBan	INT,
	DonGiaBan	INT,
	PRIMARY KEY (SoHD, MaHH),
	CONSTRAINT FK_HD FOREIGN KEY (SoHD) REFERENCES HoaDonBan (SoHD),
	CONSTRAINT FK_HH FOREIGN KEY (MaHH) REFERENCES HangHoa (MaHH)
);
GO
INSERT INTO CTHDB VALUES
('HD0001','TV001', 3000, 1000000 ),
('HD0002','MG002', 2000, 2000000),
('HD0003','TL003', 100, 3000000 );
//3
SELECT * 
FROM HangHoa 
WHERE  NhaCC = 'Nguyen Kim' AND SoLuongKho > 100;
//4
SELECT c.HoKH,c.TenKH, c.DiaChi, c.DienThoai , od.SoHD
FROM KhachHang c
JOIN HoaDonBan o ON c.MaKH  = o.MaKH 
JOIN HoaDonBan  od ON o.SoHD  = od.SoHD 
WHERE od.TinhTrang = 0 AND YEAR(o.NgayBan) = '2022'
(Tinh Trang = 0 - Chưa thanh toán)



//5
SELECT p.TenHH, s.NhaCC, SUM(o.SoLuongBan  * o.DonGiaBan) AS DoanhThu
FROM HangHoa p
JOIN HangHoa s ON p.NhaCC = s.NhaCC
JOIN CTHDB o ON p.MaHH  = o.MaHH 
JOIN HoaDonBan  ord ON ord.SoHD = o.SoHD
WHERE YEAR(ord.NgayBan) = 2022
GROUP BY p.TenHH, s.NhaCC
HAVING SUM(o.SoLuongBan) > 1000;
//6
UPDATE HangHoa 
SET DonGia  = DonGia  * 0.9
WHERE TenHH = 'Ti vi';

