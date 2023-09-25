CREATE DATABASE QuanLyLaixe_CaoNguyenQuocLam;
go
use master
go
CREATE LOGIN admin_CaoNguyenQuocLam WITH PASSWORD = '100603', CHECK_POLICY = OFF;

USE QuanLyLaixe_CaoNguyenQuocLam;
GO
CREATE USER user_CaoNguyenQuocLam FOR LOGIN admin_CaoNguyenQuocLam;

USE QuanLyLaixe_CaoNguyenQuocLam;
GO
GRANT CREATE TABLE TO user_CaoNguyenQuocLam;
GRANT CREATE VIEW TO user_CaoNguyenQuocLamn;
GRANT ALTER TO user_CaoNguyenQuocLam;
GRANT SELECT, INSERT, UPDATE, DELETE TO user_CaoNguyenQuocLam;


//CAU 3:
CREATE TABLE LaiXe (
    MaLX VARCHAR(100) PRIMARY KEY,
    Ho VARCHAR(50),
    Ten VARCHAR(50),
    GioiTinh NVARCHAR(10),
    DiaChi NVARCHAR(100),
    SDT NUMERIC(10,0),
);
INSERT INTO LaiXe VALUES
('CN01', 'Nguyen Van','An', 'Nam','Nha Trang- Khánh Hòa',012345678),
('LT02', 'Tran Thi','Binh', 'Nu','Nha Trang- Khánh Hòa',012345678),
('SQ03', 'Cao Nguyen Quoc','Lam', 'Nam','Nha Trang- Khánh Hòa',012345678 );

CREATE TABLE Xe (
    MaXe VARCHAR(100) PRIMARY KEY,
	LoaiXe VARCHAR(100),
	TaiTrong INT,
    TGKD DATE,
    PhiVC INT,
);

INSERT INTO Xe VALUES
('79A-03219', 'Xe tải Kazma', 15,'2022-12-6',1000.000),
('79A-99999', 'Toyota Hilux', 10,'2022-12-6',2000.000),
('79A-88888', 'Mecserdes', 12,'2022-12-6',4000.000);

CREATE TABLE VanTai (
	MaLX VARCHAR(100),
	MaXe VARCHAR(100),
	NgayVC DATE  PRIMARY KEY,
	SoKM INT,
	TrongLuong INT,
	CONSTRAINT pk_LX FOREIGN KEY (MaLX) REFERENCES LaiXe (MaLX),
	CONSTRAINT pk_MX FOREIGN KEY (MaXe) REFERENCES Xe (MaXe),
);

INSERT INTO VanTai VALUES
('CN01', '79A-03219', '2022-12-5',100,15),
('LT02', '79A-99999', '2020-10-2',150,10),
('SQ03', '79A-88888', '2010-8-2',180,12);


//cau 4
CREATE SCHEMA ntu;
ALTER TABLE ntu.LaiXe SET SCHEMA ntu;

// cau 5
SELECT *
FROM LaiXe
WHERE GioiTinh = 'Nu';

// cau 6
SELECT LaiXe.Ten, SUM(VanTai.SoKm) AS TongSoKm
FROM LaiXe 
INNER JOIN VanTai ON LaiXe.MaLX = VanTai.MaLX
WHERE YEAR(VanTai.NgayVC) = 2022
GROUP BY LaiXe.Ten;

// cau 7
UPDATE XE
SET PhiVC = PhiVC * 1.1
WHERE TaiTrong > 10;

// cau 8
SELECT MaLX, Ho, Ten
FROM LaiXe
WHERE NOT EXISTS (
    SELECT 1
    FROM VanTai s
    Where YEAR(NgayVC) = '2022'
)

//cau 9
BACKUP DATABASE QuanLyKho_CaoNguyenQuocLam 
TO DISK = 'D:\BACKUP\QuanLyKho_CaoNguyenQuocLam_FULL_20220116_0001.bak';
GO
BACKUP DATABASE QuanLyKho_CaoNguyenQuocLam 
TO DISK = 'D:\BACKUP\QuanLyKho_CaoNguyenQuocLam_DIFF_20220118_0001.bak';
GO
RESTORE DATABASE QuanLyKho_CaoNguyenQuocLam 
FROM DISK = 'D:\BACKUP\QuanLyKho_CaoNguyenQuocLam_FULL_20220116_0001.bak'
WITH NORECOVERY;
GO
RESTORE DATABASE QuanLyKho_CaoNguyenQuocLam 
FROM DISK = 'D:\BACKUP\QuanLyKho_CaoNguyenQuocLam_DIFF_20220118_0001.bak'
WITH RECOVERY;


