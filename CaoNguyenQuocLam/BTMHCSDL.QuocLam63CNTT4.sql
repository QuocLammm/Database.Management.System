use QuanLyDeAn
go
--------- create table------
create table NHANVIEN(
	MANV varchar(9) not null,
	HONV nvarchar(15),
	TENLOT nvarchar(30),
	TENNV nvarchar(30),
	NGAYSINH SMALLDATETIME,
	DCHI nvarchar(150),
	PHAI NVARCHAR(3),
	LUONG NUMERIC(18,0),
	MA_NQL VARCHAR(9),
	PHG VARCHAR(2),
	primary key (MANV),
	FOREIGN KEY (MA_NQL) REFERENCES NHANVIEN(MANV)
)
ALTER TABLE NHANVIEN ADD
FOREIGN KEY (PHG) REFERENCES PHONGBAN(MAPHG)
Go
------create table Phongban----
use QuanLyDeAn
go
CREATE TABLE PHONGBAN(
	MAPHG VARCHAR(2) NOT NULL PRIMARY KEY,
	TENPHG NVARCHAR(20),
	TRPHG VARCHAR(9),
	NG_NHANCHUC SMALLDATETIME,
	FOREIGN KEY (TRPHG) REFERENCES NHANVIEN(MANV)
)
go
-------create table Dean-----
CREATE TABLE DEAN(
	MADA VARCHAR(2) NOT NULL PRIMARY KEY,
	TENDA NVARCHAR(50),
	DDIEM_DA VARCHAR(20),
	PHONG VARCHAR(2),
)
go
---------create table Phân công --------
CREATE TABLE PHANCONG(
	MA_NVIEN VARCHAR(9) NOT NULL,
	SODA VARCHAR(2) NOT NULL,
	THOIGIAN NUMERIC(18,0),
	PRIMARY KEY(MA_NVIEN,SODA),
	FOREIGN KEY (MA_NVIEN) REFERENCES NHANVIEN(MANV),
	FOREIGN KEY (SODA) REFERENCES DEAN(MADA)
)
go
---------create table Thân nhân----------
CREATE TABLE THANNHAN(
	MA_NVIEN VARCHAR(9) NOT NULL,
	TENTN VARCHAR(20) NOT NULL,
	NGAYSINH SMALLDATETIME,
	PHAI NVARCHAR(3),
	QUANHE VARCHAR(15)
	PRIMARY KEY(MA_NVIEN,TENTN),
	FOREIGN KEY (MA_NVIEN) REFERENCES NHANVIEN(MANV)
)
go
-----------create table địa điểm phòng---
CREATE TABLE DIADIEM_PHG(
	MAPHG VARCHAR(2) NOT NULL,
	DIADIEM VARCHAR(20) NOT NULL,
	PRIMARY KEY(MAPHG,DIADIEM),
	FOREIGN KEY (MAPHG) REFERENCES PHONGBAN(MAPHG)
)
-----------------------------------------------------------------------------------------------
----Tạo User-defined datatype trong CSDL QuanLyDeAn--
use QuanLyDeAn
go
EXEC sp_addtype ISBN, 'char(25)';
EXEC sp_addtype Sodienthoai, 'char(13)',NULL;
EXEC sp_addtype Shortstring , 'varchar(15)';
----Xem liệt kê User-defined datatype----
SELECT domain_name, data_type, character_maximum_length
FROM information_schema.domains
ORDER BY domain_name;
----Cho User-defined datatype được dùng trên tất cả CSDL----
use master
go
create schema datatype
go
CREATE TYPE datatype.ISBN FROM char(25) NOT NULL;
CREATE TYPE datatype.Sodienthoai FROM char(13) NULL;
CREATE TYPE datatype.Shortstring FROM varchar(15) NOT NULL;
go
SELECT sys.types.name, sys.types.schema_id, sys.schemas.name
FROM sys.types JOIN sys.schemas
ON sys.types.schema_id = sys.schemas.schema_id
WHERE sys.types.name = 'Shortstring';
go
---------------------------------------------------
USE QuanLyDeAn
GO
CREATE TABLE Nhanvien_Backup (
    MaNV INT PRIMARY KEY CHECK (MaNV >= 1 AND MaNV <= 1000),
    HoTen Shortstring NOT NULL,
    NgaySinh DATE,
    Phai nvarchar(3),
    DienThoai Sodienthoai UNIQUE,
    ThanhPho Shortstring DEFAULT 'Hồ Chí Minh'
);
--Ràng buộc chỉ có Nam|Nữ--
ALTER TABLE Nhanvien_Backup
ADD CONSTRAINT chk_Phail CHECK (Phai IN ('Nam', 'Nữ'));
--Ngày Sinh--
ALTER TABLE Nhanvien_Backup
ADD CONSTRAINT ngaysinh_check CHECK (NgaySinh <= DATEADD(YEAR, -18, GETDATE()))
--Tạo Rule--
go
CREATE RULE rule_luong
AS @Luong > 0;
go
EXEC sp_bindrule 'rule_luong', 'Nhanvien.Luong'
go
use QuanLyDeAn
go
ALTER TABLE DIADIEM_PHG
ADD CONSTRAINT diadiem_default DEFAULT 'Tp.Hồ Chí Minh' FOR DIADIEM
--------------------- Backup | restore ----------------------------------
BACKUP DATABASE QuanLyDeAn
TO DISK = 'E:\Quanlydean.bak'
WITH FORMAT, INIT, SKIP;
--restore--
USE master;
ALTER DATABASE QuanLyDeAn SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE QuanLyDeAn
FROM DISK = 'E:\Quanlydean.bak'
WITH REPLACE, RECOVERY;
ALTER DATABASE QuanLyDeAn SET MULTI_USER;
--------------------------------------------------------------------------
--Hiệu chỉnh cột trong bảng--
use QuanLyDeAn
go
ALTER TABLE PHONGBAN
ALTER COLUMN TENPHG nvarchar(20)
go
INSERT INTO PHONGBAN(MAPHG, TENPHG, TRPHG, NG_NHANCHUC)
VALUES (2, N'Nhân sự', 10, '2003/12/12')
insert into PHONGBAN 
values(6,N'Kế Toán',20,'2005/10/23'),
(7,N'Kỹ Thuật',30,'2006/12/05')
select * from PHONGBAN
go
-- Thêm mã nhân viên từ 10 -> 50--
DECLARE @start INT = 1;
DECLARE @end INT = 80;
WHILE (@start <= @end)
BEGIN
	INSERT INTO NHANVIEN (MANV) VALUES (@start);
	SET @start = @start + 1;
END
select MANV from NHANVIEN
-- Thêm 50 dòng vào PHANCONG--
use QuanLyDeAn
go
INSERT INTO PHANCONG (MA_NVien, SODA, THOIGIAN)
VALUES 
('10', '8', 10),
('10', '9', 20),
('10', '11', 30),
('10', '12', 40),
('10', '13', 50),
('10', '14', 60),
('10', '15', 70),
('11', '8', 80),
('11', '9', 90),
('11', '11', 100),
('11', '12', 110),
('11', '13', 120),
('11', '14', 130),
('11', '15', 140),
('12', '8', 150),
('12', '9', 160),
('12', '11', 170),
('12', '12', 180),
('12', '13', 190),
('12', '14', 200),
('12', '15', 210),
('13', '8', 220),
('13', '9', 230),
('13', '11', 240),
('13', '12', 250),
('13', '13', 260),
('13', '14', 270),
('13', '15', 280),
('14', '8', 290),
('14', '9', 300),
('14', '11', 310),
('14', '12', 320),
('14', '13', 330),
('14', '14', 340),
('14', '15', 350),
('15', '8', 360),
('15', '9', 370),
('15', '11', 380);
---------------------------------------Customer của CSDL AdventureWorks. ---------------------
use QuanLyDeAn
go
INSERT INTO nhanvien (manv, HONV, tenlot, tennv)
SELECT 
    CustomerID AS manv, 
    FirstName AS honv, 
    MiddleName AS tenlot, 
    LastName AS tennv 
FROM 
    AdventureWorks2022.Sales.Customer 
    INNER JOIN AdventureWorks2022.Person.Person
    ON Customer.CustomerID = Person.BusinessEntityID
WHERE 
    CustomerID BETWEEN 102 AND 200;
--------------------- Phần 2: UPDATE -----------------------
UPDATE NHANVIEN
SET DCHI = 'Tp.Hồ Chí Minh'
WHERE DCHI IS NULL;

-----------------Cập nhật PHG-------
update NHANVIEN
set PHG = 2
where MANV between 1 and 10
update NHANVIEN
set PHG = 6
where MANV between 11 and 40
update NHANVIEN
set PHG = 7
where MANV between 41 and 80
update NHANVIEN
set PHG = 5
where MANV between 102 and 200
select MANV,PHG from NHANVIEN

----------------Cập nhật ngày sinh------------
UPDATE NHANVIEN
SET NGAYSINH = '1985-01-01'
WHERE NGAYSINH is null

-----------Cập nhật Lương-------
UPDATE NHANVIEN
SET LUONG = 100000
WHERE PHG = 3;

UPDATE NHANVIEN
SET LUONG = 65000
WHERE PHG = 6;

UPDATE NHANVIEN
SET LUONG = 85000
WHERE PHG = 7;

UPDATE NHANVIEN
SET LUONG = 70000
WHERE PHG = 2;

select PHG from NHANVIEN
select LUONG from NHANVIEN

-------------Cập nhật mã người quản lý---------
UPDATE NHANVIEN
SET MA_NQL = (
  SELECT MA_NQL
  FROM PHONGBAN
  WHERE PHONGBAN.MAPHG = Nhanvien.PHG
)
WHERE EXISTS (
  SELECT *
  FROM PhongBan
  WHERE PhongBan.MAPHG = Nhanvien.PHG
);

-----------------Phần 3: Câu lệnh SELECT------------
-----3.1 TRUY VẤN CƠ BẢN---
--1--
SELECT * FROM NhanVien WHERE NHANVIEN.PHG = 5;
--2--
SELECT * FROM NhanVien WHERE NHANVIEN.LUONG > 25000
--3--
SELECT * FROM NhanVien WHERE Phg = 2 AND Luong >= 70000
--4--
SELECT HONV, TENLOT, TENNV FROM Nhanvien WHERE DCHI = N'Tp.Ho Chí Minh'
--5--
SELECT HONV, TENLOT, TENNV  FROM Nhanvien WHERE HONV LIKE 'N%'
--6--
SELECT NGAYSINH, DCHI
	   FROM NHANVIEN
	   WHERE HONV = 'Lê' AND TENLOT = 'Minh' AND TENNV = 'Tính'
--7--
SELECT *
	   FROM NHANVIEN
	   WHERE YEAR(NGAYSINH) BETWEEN 1955 AND 1975;
--8--
SELECT HONV, TENLOT, TENNV, NGAYSINH FROM NHANVIEN
--9--
SELECT HONV + ' ' + TENLOT + ' ' + TENNV AS 'Họ và tên', 
       	   DATEDIFF(day, NGAYSINH, GETDATE()) / 365 AS 'Tuổi'
	   FROM NHANVIEN

-----3.2:Truy vấn sử dụng kết nối:--------
--0--
SELECT TENPHG, TRPHG FROM PHONGBAN;
--1--
SELECT PhongBan.TENPHG,PHONGBAN.TRPHG, NHANVIEN.MA_NQL, NhanVien.HONV + ' ' + NhanVien.TENLOT + ' ' + NhanVien.TENNV AS TEN_TP
	FROM PhongBan
	JOIN NhanVien ON PhongBan.MAPHG = NhanVien.PHG
	WHERE NhanVien.MA_NQL = PHONGBAN.TRPHG
--2--chưa sửa dl
SELECT TENNV, DCHI
	FROM NHANVIEN
	JOIN PHONGBAN ON NHANVIEN.PHG = PHONGBAN.TENPHG
	WHERE TENPHG = 'Kỹ Thuật'
--3--
USE QuanLyDeAn
GO
SELECT Dean.TENDA, PHONGBAN.TENPHG, NHANVIEN.HONV, NHANVIEN.TENLOT, NHANVIEN.TENNV, PHONGBAN.NG_NHANCHUC
	FROM DEAN
	JOIN PHONGBAN ON DEAN.MADA = PHONGBAN.MAPHG
	JOIN NHANVIEN ON PHONGBAN.MAPHG= NHANVIEN.MANV
	WHERE DEAN.DDIEM_DA = N'Nha Trang'
--4--
SELECT NHANVIEN.TENNV, THANNHAN.TENTN
	FROM NHANVIEN
	JOIN THANNHAN ON NHANVIEN.MANV = THANNHAN.MA_NVIEN
	WHERE NHANVIEN.PHAI = N'Nữ'
--5--
SELECT nhanvien.TENNV AS HoTenNhanVien, nql.TENNV AS HoTenNguoiQuanLy
	FROM Nhanvien nhanvien
	JOIN Nhanvien nql ON nhanvien.MA_NQL = nql.MANV;
--6--
SELECT nv.HONV +' '+ nv.TENLOT + ' ' + nv.TENNV AS 'Ho Ten Nhan Vien', 
       pb.TENPHG AS 'Ten Phong', 
       nql.TENNV AS 'Ten Quan Ly' 
	FROM Nhanvien nv 
	JOIN Phongban pb ON nv.PHG = pb.MAPHG 
	JOIN Nhanvien nql ON nv.MA_NQL = nql.MANV 
--7--???
SELECT NV.TENNV, NV.MA_NQL, PB.TENPHG AS TENPHG_QUANLY
	FROM Nhanvien NV
	INNER JOIN Phongban PB ON NV.PHG = PB.MAPHG --ok--
	INNER JOIN Phancong PC ON NV.MANV = PC.MA_NVIEN --ok--
	INNER JOIN Dean D ON PC.SODA = D.MADA --ok--
	WHERE PB.MAPHG = '5' AND D.TENDA = N'Xây dựng nhà máy chế biến thủy sản'
--8--???
SELECT D.TENDA
FROM Dean D
INNER JOIN Phancong PC ON D.MADA = PC.SODA
INNER JOIN Nhanvien NV ON PC.MA_NVIEN = NV.MANV
WHERE HONV =N'Trần' AND TENLOT = N'Anh' AND TENNV = N'Tuấn'

-----------------------3.2 GOM NHÓM ----------------
--19--oki
use QuanLyDeAn
go
SELECT COUNT(*) AS 'SL Đề án'
FROM DEAN;

--20--oki
SELECT COUNT(*) AS SoLuongDeanNghiencuu
FROM Dean d
JOIN Phongban p ON d.phong = p.MAPHG
WHERE p.TENPHG =N'Nghiên cứu';

--21--
use QuanLyDeAn
go
SELECT AVG(LUONG) AS Lương_trung_bình
FROM Nhanvien
WHERE PHAI = N'Nam'

--22--
use QuanLyDeAn
go
SELECT COUNT(*) as so_than_nhan
FROM ThanNhan
WHERE MA_NVIEN = (
  SELECT MANV
  FROM Nhanvien
  WHERE HONV = N'Lê' AND TENLOT = N'Thanh' AND TENNV = N'Sang'
)

--23--
use QuanLyDeAn
go
SELECT Dean.TENDA, SUM(Phancong.THOIGIAN) AS TongGioLamViec
FROM Dean 
INNER JOIN Phancong ON Dean.MADA = Phancong.SODA
GROUP BY Dean.TENDA;

--24--
use QuanLyDeAn
go
SELECT Dean.TENDA, COUNT(*) AS SoNhanVien
FROM Dean JOIN Phancong ON Dean.MADA = Phancong.SODA
GROUP BY Dean.TENDA

--25--
SELECT NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS 'Ho ten', COUNT(TN.MA_NVIEN) AS 'So luong than nhan'
FROM Nhanvien NV
LEFT JOIN ThanNhan TN ON NV.MANV = TN.MA_NVIEN
GROUP BY NV.MANV, NV.HONV, NV.TENLOT, NV.TENNV

--26--
SELECT NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS 'Tên nhân viên', COUNT(PC.MA_NVIEN) AS 'Số lượng đề án'
FROM Nhanvien NV
LEFT JOIN Phancong PC ON NV.MANV = PC.MA_NVIEN
GROUP BY NV.MANV, NV.HONV, NV.TENLOT, NV.TENNV

--27--
SELECT NV.TENNV, COUNT(*) AS SoLuongNhanVienQuanLy
FROM Nhanvien NV
WHERE 
	EXISTS (
	SELECT * 
	FROM Nhanvien 
	WHERE MANV = NV.MA_NQL
	)
GROUP BY NV.TENNV 

--28--
SELECT Phongban.TENPHG, AVG(Nhanvien.LUONG) AS LƯƠNG_TRUNG_BÌNH
FROM Phongban
INNER JOIN Nhanvien ON Phongban.MAPHG = Nhanvien.PHG
GROUP BY Phongban.TENPHG;

--29--
SELECT TENPHG, COUNT(*) AS SO_LUONG_NHAN_VIEN
FROM Nhanvien JOIN Phongban ON Nhanvien.PHG = Phongban.MAPHG
GROUP BY TENPHG
HAVING AVG(LUONG) > 30000;

--30--
SELECT Phongban.TENPHG, COUNT(Dean.MADA) AS 'So_luong_de_an'
FROM Phongban
INNER JOIN Dean ON Phongban.MAPHG = Dean.phong
GROUP BY Phongban.TENPHG;

--31--
SELECT pb.TENPHG, nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV AS TRUONGPHONG, COUNT(d.MADA) AS SO_LUONG_DE_AN
FROM Phongban pb
JOIN Nhanvien nv ON nv.PHG = pb.MAPHG
JOIN Dean d ON d.phong = pb.MAPHG
GROUP BY pb.TENPHG, nv.HONV, nv.TENLOT, nv.TENNV

--32-- oki
SELECT pb.TENPHG, COUNT(DISTINCT d.MADA) AS So_luong_de_an
FROM Phongban pb
INNER JOIN Dean d ON pb.MAPHG = d.phong
INNER JOIN Nhanvien nv ON pb.MAPHG = nv.PHG
INNER JOIN Phancong pc ON nv.MANV = pc.MA_NVIEN
GROUP BY pb.TENPHG
HAVING AVG(nv.LUONG) > 50000

--33-- oke
SELECT Dean.DDIEM_DA, COUNT(*) AS SoDeAn 
FROM Dean 
GROUP BY Dean.DDIEM_DA

--em đan nhờ sửa---đã được--
select dd.DIADIEM ,COUNT(da.MADA) as sodean
from DEAN da
join PHANCONG pc on pc.SODA = da.MADA
join NHANVIEN nv on nv.MANV = pc.MA_NVIEN
join PHONGBAN pb on pb.MAPHG = nv.PHG
join DIADIEM_PHG dd on dd.MAPHG = pb.MAPHG
group by dd.DIADIEM

--34--oki
SELECT Dean.TENDA, COUNT(Phancong.soda) AS SoLuongCongViec
FROM Dean JOIN Phancong ON Dean.MADA = Phancong.SODA
GROUP BY Dean.TENDA


--35--oki
SELECT phancong.soda, COUNT(*) AS soluong
FROM phancong
WHERE phancong.soda IN (
    SELECT dean.MADA
    FROM dean
    WHERE dean.MADA = 20
)
GROUP BY phancong.soda;
--------------------------------3.3 TRUY VẤN LỒNG + GOM NHÓM ------------------------------
--36-- oke

SELECT MADA
FROM Dean
WHERE MADA IN (SELECT MANV FROM Nhanvien WHERE HONV = N'Lê')
UNION
SELECT MADA
FROM Dean
WHERE phong IN (SELECT MAPHG FROM Phongban WHERE TRPHG = N'Lê')

--37-- ok
SELECT HONV, TENLOT, TENNV
FROM Nhanvien
WHERE MANV IN (
  SELECT MA_NVIEN
  FROM ThanNhan
  GROUP BY MA_NVIEN
  HAVING COUNT(*) > 2
)

--38--
SELECT N.HONV, N.TENLOT, N.TENNV
FROM Nhanvien N
LEFT JOIN ThanNhan TN ON N.MANV = TN.MA_NVIEN
WHERE TN.MA_NVIEN IS NULL;
--*Sử dụng NOT EXISTS:
SELECT N.HONV, N.TENLOT, N.TENNV
FROM Nhanvien N
WHERE NOT EXISTS (
    SELECT 1
    FROM ThanNhan TN
    WHERE TN.MA_NVIEN = N.MANV
);

--39-- oki
SELECT NV.HONV AS HONV, NV.TENLOT, NV.TENNV
FROM Nhanvien NV
INNER JOIN ThanNhan TN ON NV.MANV = TN.MA_NVIEN
WHERE NV.PHG IN (
    SELECT PHG FROM Nhanvien WHERE PHG = NV.PHG AND MA_NQL IS NULL
)
GROUP BY NV.HONV, NV.TENLOT, NV.TENNV
HAVING COUNT(TN.MA_NVIEN) >= 1;

--40-- oki
SELECT DISTINCT HONV, TENLOT, TENNV
FROM Nhanvien
LEFT JOIN Phongban ON Nhanvien.PHG = Phongban.MAPHG
WHERE Phongban.TRPHG = '20' AND NOT EXISTS (
  SELECT *
  FROM ThanNhan
  WHERE ThanNhan.MA_NVIEN = Nhanvien.MANV
)

--41--oki
SELECT HONV, TENLOT, TENNV
FROM Nhanvien
WHERE LUONG > (
  SELECT AVG(LUONG)
  FROM Nhanvien JOIN Phongban ON Nhanvien.PHG = Phongban.MAPHG
  WHERE Phongban.TENPHG = N'Nhân sự'
);

--42-- dl sai

SELECT PH.TENPHG, NV.HONV, NV.TENLOT, NV.TENNV
FROM PHONGBAN PH
JOIN NHANVIEN NV ON PH.MAPHG = NV.PHG
GROUP BY PH.TENPHG, NV.HONV, NV.TENLOT, NV.TENNV
HAVING COUNT(NV.MANV) = (
  SELECT MAX(nhanvien_count)
  FROM (
    SELECT COUNT(*) AS nhanvien_count
    FROM NHANVIEN
    GROUP BY PHG
  ) AS counts
)


--43--
--------Not in--------
SELECT MADA
FROM Dean
WHERE MADA NOT IN (
  SELECT MADA
  FROM Phancong
  WHERE ma_nvien = 60
);
-----------left join:---------
SELECT d.MADA
FROM Dean d
LEFT JOIN Phancong p ON d.MADA = p.MA_NVIEN AND p.ma_nvien = 60
WHERE p.ma_nvien IS NULL;

--44--
SELECT MANV, CONCAT(HONV, ' ', TENLOT, ' ', TENNV) AS HovaTen, DCHI
FROM Nhanvien
INNER JOIN Phancong ON Nhanvien.MANV = Phancong.MA_NVIEN
INNER JOIN Dean ON Phancong.SODA = Dean.MADA
INNER JOIN Phongban ON Nhanvien.PHG = Phongban.MAPHG
WHERE Dean.DDIEM_DA = N'Nha Trang' AND Phongban.TRPHG <> 40

--45--
SELECT Nhanvien.HONV, Nhanvien.TENLOT, Nhanvien.TENNV, Nhanvien.DCHI
FROM Nhanvien
INNER JOIN Phancong ON Nhanvien.MANV = Phancong.MA_NVIEN --ok--
INNER JOIN Dean ON Phancong.SODA = Dean.MADA --ok--
INNER JOIN Phongban ON Nhanvien.PHG = Phongban.MAPHG AND Phongban.TRPHG <> 10
WHERE Dean.DDIEM_DA = 'Nha Trang'


--46--oki
SELECT 
    nv.NGAYSINH,
    AVG(YEAR(GETDATE()) - YEAR(nv.NGAYSINH)) AS 'TrungBinhTuoi'
FROM 
    NHANVIEN nv
GROUP BY 
    ROLLUP(nv.NGAYSINH) --compute == rollup--
HAVING 
    nv.NGAYSINH IS NOT NULL
ORDER BY 
    nv.NGAYSINH

--47-- Vì compute by đã bị xóa khỏi bản SQL từ 2019 nên không thể dùng được
SELECT
    pb.tenphg AS PhongBan,
    da.tenda AS TenDeAn,
    AVG(pn.tongluong) AS LuongTrungBinh
FROM
    Phongban pb
INNER JOIN
    Nhanvien nv ON pb.maphg = nv.PHG
INNER JOIN
    Phancong pc ON nv.manv = pc.ma_nvien
INNER JOIN
    DEAN da ON pc.soda = da.mada
LEFT JOIN
    (
    SELECT
        pc.soda,
        pc.ma_nvien,
        SUM(nv.luong * pc.thoigian) AS tongluong
    FROM
        Phancong pc
    INNER JOIN
        Nhanvien nv ON pc.ma_nvien = nv.manv
    GROUP BY
        pc.soda,
        pc.ma_nvien
    ) pn ON da.mada = pn.soda AND nv.manv = pn.ma_nvien
GROUP BY
    pb.tenphg,
    da.tenda


---------------------PHÉP CHIA----------------------
--48-- okki
SELECT
    nv.manv AS MaNV,
    nv.phai AS Phai,
    CONCAT(nv.honv, ' ', nv.tenlot, ' ', nv.tennv) AS HoTen
FROM
    Nhanvien nv
WHERE
    nv.manv NOT IN (
        SELECT DISTINCT
            pc.ma_nvien
        FROM
            Phancong pc
        LEFT JOIN
            DEAN da ON pc.soda = da.mada
        WHERE
            da.mada IS NULL
    )

--49--??/?
SELECT
    nv.manv AS MaNV,
    nv.phai AS Phai,
    CONCAT(nv.honv, ' ', nv.tenlot, ' ', nv.tennv) AS HoTen
FROM
    Nhanvien nv
WHERE
    EXISTS (
        SELECT
            soda
        FROM
            DEAN da
        INNER JOIN
            Phancong pc ON da.mada = pc.soda
        WHERE
            pc.ma_nvien = nv.manv
            AND da.PHONG = 5
        GROUP BY
            soda
        HAVING
            COUNT(DISTINCT pc.ma_nvien) = (
                SELECT
                    COUNT(DISTINCT ma_nvien)
                FROM
                    Phancong
                WHERE
                    soda = da.mada
            )
    )

--50--okiii
SELECT NV.MANV, NV.PHAI, NV.HONV, NV.TENLOT, NV.TENNV
FROM NHANVIEN NV
WHERE NOT EXISTS (
  SELECT *
  FROM PHANCONG PC
  WHERE PC.MA_NVIEN = NV.MANV
    AND NOT EXISTS (
      SELECT *
      FROM NHANVIEN LM
      JOIN PHANCONG LM_PC ON LM.MANV = LM_PC.MA_NVIEN
      WHERE LM.HONV = N'Lê' AND LM.TENLOT = N'Minh' AND LM.TENNV = N'Tính'
        AND LM_PC.SODA = PC.SODA
    )
)

--51--oki
SELECT NV.MANV, NV.HONV, NV.TENLOT, NV.TENNV
FROM NHANVIEN NV
WHERE NOT EXISTS (
  SELECT *
  FROM PHANCONG PC
  JOIN DEAN D ON PC.SODA = D.MADA
  JOIN DIADIEM_PHG DP ON D.PHONG = DP.MAPHG
  WHERE NV.MANV = PC.MA_NVIEN AND DP.DIADIEM <> N'Tp. Ho Chí Minh'
)

--52-- oki
SELECT PB.TENPHG
FROM PHONGBAN PB
WHERE NOT EXISTS (
  SELECT D.MADA
  FROM DEAN D
  WHERE NOT EXISTS (
    SELECT DP.MAPHG
    FROM DIADIEM_PHG DP
    WHERE DP.MAPHG = D.PHONG AND DP.DIADIEM = N'Ha Noi'
  ) AND PB.MAPHG = D.PHONG
)

--???????
SELECT PB.TENPHG
FROM PHONGBAN PB
WHERE NOT EXISTS (
  SELECT D.MADA
  FROM DEAN D
  WHERE NOT EXISTS (
    SELECT DP.MAPHG
    FROM DIADIEM_PHG DP
    WHERE DP.DIADIEM = N'Ha Noi' AND D.PHONG = DP.MAPHG
  )
  AND NOT EXISTS (
    SELECT PC.SODA
    FROM PHANCONG PC
    WHERE D.MADA = PC.SODA
  )
)

-------------------------------------UNION/INTERSECT-----------------------------------
--53--
--INTERSECT(phép giao)------- đúng
SELECT PB.TENPHG
FROM PHONGBAN PB
JOIN DEAN D ON PB.MAPHG = D.PHONG
JOIN DIADIEM_PHG DP ON D.PHONG = DP.MAPHG
WHERE DP.DIADIEM = N'Ha Noi'
INTERSECT
SELECT PB.TENPHG
FROM PHONGBAN PB
JOIN DEAN D ON PB.MAPHG = D.PHONG
JOIN DIADIEM_PHG DP ON D.PHONG = DP.MAPHG
WHERE DP.DIADIEM = N'TP HCM'
--UNION ( phép hợp )-- đúng
SELECT PB.TENPHG
FROM PHONGBAN PB
JOIN DEAN D ON PB.MAPHG = D.PHONG
JOIN DIADIEM_PHG DP ON D.PHONG = DP.MAPHG
WHERE DP.DIADIEM = N'Ha Noi'
UNION
SELECT PB.TENPHG
FROM PHONGBAN PB
JOIN DEAN D ON PB.MAPHG = D.PHONG
JOIN DIADIEM_PHG DP ON D.PHONG = DP.MAPHG
WHERE DP.DIADIEM = N'TP HCM'
GROUP BY PB.TENPHG
HAVING COUNT(DISTINCT DP.DIADIEM) = 2

--54----
--INTERSECT(phép giao)------???????
SELECT PB.TENPHG
FROM PHONGBAN PB
JOIN DEAN D ON PB.MAPHG = D.PHONG
JOIN DIADIEM_PHG DP ON D.PHONG = DP.MAPHG
WHERE DP.DIADIEM = N'Ha Noi'
INTERSECT
SELECT PB.TENPHG
FROM PHONGBAN PB
JOIN DEAN D ON PB.MAPHG = D.PHONG
JOIN DIADIEM_PHG DP ON D.PHONG = DP.MAPHG
WHERE DP.DIADIEM = N'TP HCM'

--UNION ( phép hợp )-- đúng
SELECT PB.TENPHG
FROM PHONGBAN PB
JOIN DEAN D ON PB.MAPHG = D.PHONG
JOIN DIADIEM_PHG DP ON D.PHONG = DP.MAPHG
WHERE DP.DIADIEM = N'Ha Noi'
UNION
SELECT PB.TENPHG
FROM PHONGBAN PB
JOIN DEAN D ON PB.MAPHG = D.PHONG
JOIN DIADIEM_PHG DP ON D.PHONG = DP.MAPHG
WHERE DP.DIADIEM = N'TP HCM'

--------------------------------------------------------------Phần 4: CÂU LỆNH DELETE --------------------------------













----------------------Phần 2: VIEW--------------------
--1--Lệnh truy vấn-- oke
SELECT NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS HoTen, PC.SODA, D.TENDA
FROM NHANVIEN NV
JOIN DEAN D ON NV.MANV = D.MADA
JOIN PHANCONG PC ON NV.MANV = PC.MA_NVIEN


--2--
alter VIEW NV_DA AS
SELECT NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS HoTen, PC.SODA, D.TENDA
FROM NHANVIEN NV
JOIN DEAN D ON NV.MANV = D.MADA
JOIN PHANCONG PC ON NV.MANV = PC.MA_NVIEN
--xem kết quả
SELECT * FROM NV_DA
---Kết quả giống nhau vì View NV_DA được tạo bằng một truy vấn, và nội dung của view được cố định khi view được tạo.

--3--
--thêm vào bảng PHANCONG
INSERT INTO PHANCONG (MA_NVIEN, SODA, THOIGIAN)
VALUES (10, 5, 50);-- thêm thành công
--kết quả sẽ thay đổi ,view NV_DA là một "cửa sổ" để truy cập dữ liệu từ các bảng gốc (NHANVIEN và PHANCONG) dựa trên một truy vấn cụ thể.
--Khi bạn thêm một dòng mới vào bảng PHANCONG, view NV_DA sẽ phản ánh thay đổi này và kết quả từ SELECT * FROM NV_DA sẽ bao gồm cả dòng mới được thêm vào.

--4--
UPDATE NV_DA
SET  TenDa = N'Quản lý các dự án CNTT thông tin'
WHERE TENDA = 'Resort nghỉ dưỡng'--Câu lệnh SELECT * FROM NV_DA sẽ hiển thị tất cả các dòng từ view NV_DA, trong đó cột TENDA đã được cập nhật nếu câu lệnh UPDATE được thực hiện thành công.
--Câu lệnh SELECT * FROM DEAN sẽ hiển thị tất cả các dòng từ bảng DEAN, không liên quan trực tiếp đến việc cập nhật TENDA trong bảng NV_DA.

----5--oke----------
-- Viết truy vấn--
SELECT NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS HoTen, D.TENDA, SUM(PHANCONG.SODA * NV.LUONG) AS TongLuong
FROM NHANVIEN NV
JOIN PHANCONG ON NV.MANV = PHANCONG.MA_NVIEN
JOIN DEAN D ON PHANCONG.SODA = D.MADA
JOIN DEAN D2 ON D.PHONG = D2.PHONG
JOIN PHONGBAN P ON D2.PHONG = P.MAPHG
GROUP BY NV.HONV, NV.TENLOT, NV.TENNV, D.TENDA
ORDER BY TongLuong ASC

--a--
CREATE VIEW View5a AS
SELECT NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS HoTen, PC.SODA, SUM(PC.SODA * NV.LUONG) AS TongLuong
FROM NHANVIEN NV
JOIN PHANCONG PC ON NV.MANV = PC.MA_NVIEN
GROUP BY NV.HONV, NV.TENLOT, NV.TENNV, PC.SODA
ORDER BY TongLuong ASC
--Trong trường hợp này, bạn sẽ gặp lỗi khi tạo View do câu lệnh ORDER BY không được phép trong một View. 
--Một View chỉ có thể chứa câu lệnh SELECT, FROM, WHERE và GROUP BY.

--b--Để hiệu chỉnh và tạo được View, ta loại bỏ câu lệnh ORDER BY
CREATE VIEW View5b AS
SELECT NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS HoTen, PC.SODA, SUM(PC.SODA * NV.LUONG) AS TongLuong
FROM NHANVIEN NV
JOIN PHANCONG PC ON NV.MANV = PC.MA_NVIEN
GROUP BY NV.HONV, NV.TENLOT, NV.TENNV, PC.SODA
-- Xem kết quả view vừa tạo được
SELECT * FROM View5b;

--6--
CREATE VIEW View6 AS
SELECT *
FROM DEAN
WHERE DDIEM_DA= 'TP HCM';
--a--
ALTER VIEW View6 WITH ENCRYPTION AS
SELECT *
FROM DEAN
WHERE DDIEM_DA = 'TP HCM';
--xem lại mã lệnh bằng lệnh sp_helptext View6;nhưng đã bị mã hóa không hiển thị trực tiếp thông tin

--b--oke
alter VIEW View6b WITH SCHEMABINDING AS
SELECT *
FROM DEAN
WHERE DDIEM_DA = 'TP HCM';

--c--oke
alter VIEW View6 AS
SELECT *
FROM DEAN
WHERE DDIEM_DA = 'TP HCM'
WITH CHECK OPTION;
--thêm cần thay đổi DDiem_Da = TP HCM
INSERT INTO View6
VALUES ('99', 'Xây dung đuong cao toc LT-DN', 'TP HCM', '5');
--không thể thêm được dữ liệu thông qua View6c nếu dòng dữ liệu không đáp ứng điều kiện của view, trong trường hợp này
--là nếu DIADIEM_DA không phải là 'TP HCM'.

--Xem kết quả của view
select * from View6c

--d-- đã xóa thành công
DELETE FROM View6c
WHERE MADA = '99';


--7--oke
-- Tạo bảng DEAN_HCM
use QuanLyDeAn
go
CREATE TABLE DEAN_HCM (
  MaDA varchar(2) PRIMARY KEY,
  TenDA nvarchar(50),
  DDIEM_DA varchar(20),
  PHONG varchar(2),
  CONSTRAINT check_ddiem_da_hcm CHECK (DDIEM_DA = 'TP HCM')
);

-- Thêm 2 record vào bảng DEAN_HCM
INSERT INTO DEAN_HCM (MaDA, TenDA, DDIEM_DA, PHONG) VALUES
(1, 'De án HCM 1', 'TP HCM', 10),
(2, 'De án HCM 2', 'TP HCM', 20);

-- Tạo bảng DEAN_HANOI
use QuanLyDeAn
go
CREATE TABLE DEAN_HANOI (
  MaDA varchar(2) PRIMARY KEY,
  TenDA nvarchar(50),
  DDIEM_DA varchar(20),
  PHONG varchar(2),
  CONSTRAINT check_ddiem_da_hanoi CHECK (DDIEM_DA = 'Hà Noi')
);

-- Thêm 2 record vào bảng DEAN_HANOI
INSERT INTO DEAN_HANOI (MaDA, TenDA, DDIEM_DA, PHONG)
VALUES (1, 'De án Hà Noi 1', 'Ha Noi', 2),
(2, 'De án Hà Noi 2', 'Ha Noi', 5);

-- Tạo bảng DEAN_VT
use QuanLyDeAn
go
CREATE TABLE DEAN_VT (
  MaDA varchar(2) PRIMARY KEY,
  TenDA nvarchar(50),
  DDIEM_DA varchar(20),
  PHONG varchar(2),
  CONSTRAINT check_ddiem_da_vt CHECK (DDIEM_DA = 'Vung Tàu')
);

-- Thêm 2 record vào bảng DEAN_VT
INSERT INTO DEAN_VT (MaDA, TenDA, DDIEM_DA, PHONG)
VALUES (5, 'De án Vũng Tàu 1', 'Vung Tàu', 2),
(6, 'De án Vũng Tàu 2', 'Vung Tàu', 5);


-- Tạo partition view từ 3 bảng dữ liệu
CREATE VIEW DEAN_PARTITION_VIEW AS
SELECT 'DEAN_HCM' AS TABLE_NAME, MaDA, TenDA, DDIEM_DA, PHONG FROM DEAN_HCM
UNION ALL
SELECT 'DEAN_HANOI' AS TABLE_NAME, MaDA, TenDA, DDIEM_DA, PHONG FROM DEAN_HANOI
UNION ALL
SELECT 'DEAN_VT' AS TABLE_NAME, MaDA, TenDA, DDIEM_DA, PHONG FROM DEAN_VT;

-- Xem kết quả view vừa tạo được
SELECT * FROM DEAN_PARTITION_VIEW;

-----------------------------------------------
--------------- Đề 06 ------------
--câu 1--
use QuanLyDeAn
go
begin
	declare @contro cursor;
	set @contro = cursor For
		select  PHONGBAN.TENPHG ,NHANVIEN.HONV + '' +NHANVIEN.TENLOT+''+ NHANVIEN.TENNV, count(DEAN.DDIEM_DA) 
		from PHONGBAN 
		join NHANVIEN  ON PHONGBAN.TRPHG = phongban.MAPHG
		join DIADIEM_PHG on PHONGBAN.MAPHG= DIADIEM_PHG.MAPHG
		GROUP BY
        TENPHG, HONV,TENLOT,TENNV, PHONGBAN.TENPHG
	open @contro;
	--Tạo biến
	declare @mada nvarchar(50);
	declare @ten nvarchar(50);
	declare @tenphg nvarchar(50);
	declare @tong numeric;
	declare @stt int=1; --them so thu tu
	fetch next from @contro into @mada, @ten, @tenphg, @tong;
	while (@@FETCH_STATUS = 0)
		begin
			print convert(varchar(3),@stt) +'.'+  ' Mã đe án: ' + @mada ;
			print '.' +'Tên đe án :' + @ten;
			print '.'+  ' Tên phòng: ' + @tenphg ;
			print '.'+  ' Tong thoi gian: ' + CAST(@tong AS VARCHAR);
			Set @stt+=1;
			fetch next from @contro into @mada, @ten, @tenphg, @tong;
		end;
	close @contro;
	deallocate @contro;
end;
--câu 2--
BEGIN TRANSACTION;
-- Tạo phòng ban mới
INSERT INTO PHONGBAN
VALUES (10,'An Ninh',80,'2023-12-09');
-- Tạo nhân viên mới và đặt làm trưởng phòng
INSERT INTO NHANVIEN(manv,HONV,TENLOT,TENNV, PHG) 
VALUES (201,N'Cao',null, N'Da',10);
DECLARE @id_nhan_vien int;
SET @id_nhan_vien = SCOPE_IDENTITY();
-- Cập nhật thông tin của phòng ban
UPDATE PHONGBAN 
SET TRPHG = @id_nhan_vien 
WHERE MAPHG = '10'
COMMIT TRANSACTION;


----------------
BEGIN TRANSACTION;
DECLARE @MaNhanVien VARCHAR(10) = '10';
DECLARE @MaDeAnCu NVARCHAR(50) = N'12';
DECLARE @MaDeAnMoi NVARCHAR(50) = N'13';

-- Chuyển nhân viên từ đề án cũ sang đề án mới
UPDATE PHANCONG
SET SODA = @MaDeAnMoi
WHERE MA_NVIEN = @MaNhanVien AND SODA = @MaDeAnCu;

-- Bổ sung nhân viên mới vào đề án cũ
INSERT INTO PHANCONG (MA_NVIEN, SODA, THOIGIAN)
VALUES (@MaNhanVien, @MaDeAnCu, '20');

COMMIT TRANSACTION;
--
SET XACT_ABORT ON
BEGIN TRAN

BEGIN TRY
	-- Chuyển nhân viên từ dự án có mã "8" sang dự án có mã "11"
	UPDATE PHANCONG
	SET SODA = '10'
	WHERE MA_NVIEN = '14' AND SODA = '8';

	-- Bổ sung nhân viên mới vào dự án "10"
	INSERT INTO PHANCONG (MA_NVIEN, SODA)
	VALUES ('131', '10');

	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN

	DECLARE @ErrorMessage VARCHAR(2000)
	SELECT @ErrorMessage = ERROR_MESSAGE()
	RAISERROR(@ErrorMessage, 16, 1)
END CATCH 




--câu 3--
alter TRIGGER Trg_ValidatePhanCong
ON PHANCONG
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra số lượng đề án mà mỗi nhân viên tham gia
    IF EXISTS (
        SELECT MA_NVIEN
        FROM (
            SELECT MA_NVIEN, COUNT(*) AS SoLuongDeAn
            FROM PHANCONG
            GROUP BY MA_NVIEN
        ) AS 
        WHERE SoLuongDeAn > 5
    )
    BEGIN
        -- Nếu có nhân viên tham gia quá 5 đề án, hủy thực hiện thêm hoặc chỉnh sửa
        ROLLBACK TRANSACTION;
        RAISERROR('Mỗi nhân viên không được tham gia quá 5 đề án.', 16, 1);
        RETURN;
    END;
END;



--câu 4--
CREATE PROCEDURE Proc_XuatPhongBanTrucThuocVaTruongPhong
    @MaNhanVien NVARCHAR(50)
AS
BEGIN
    -- Tìm thông tin phòng ban trực thuộc và họ tên trưởng phòng của nhân viên có mã xác định
    SELECT P.TENPHG AS TenPhongBan, NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS HoTenTruongPhong
    FROM NHANVIEN NV
    JOIN PHONGBAN P ON NV.PHG = P.MAPHG
    WHERE NV.MANV = @MaNhanVien
END;

EXEC Proc_XuatPhongBanTrucThuocVaTruongPhong @MaNhanVien = 10

--5--
use QuanLyDeAn
go
alter FUNCTION Func_DeAnQuanLyNhieuNhanVienNam
(
    @MaPhongBan NVARCHAR(50)
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @TenDeAn NVARCHAR(100)

    SELECT TOP 1 @TenDeAn = D.TENDA
    FROM DEAN D
    JOIN PHANCONG P ON D.MADA = P.SODA
    JOIN NHANVIEN NV ON P.MA_NVIEN = NV.MANV
    WHERE D.PHONG = @MaPhongBan AND NV.PHAI = 'Nam'
    GROUP BY D.TENDA
    ORDER BY COUNT(*) DESC

    RETURN @TenDeAn
END;


DECLARE @MaPhongBan NVARCHAR(50)
SET @MaPhongBan = N'2'
SELECT dbo.Func_DeAnQuanLyNhieuNhanVienNam(@MaPhongBan) AS TenDeAn







-- Đề 6---
--câu 1--
use QuanLyDeAn
go
begin
	declare @contro cursor;
	set @contro = cursor For
		SELECT PHONGBAN.TENPHG, NHANVIEN.HONV + ' ' + NHANVIEN.TENLOT + ' ' + NHANVIEN.TENNV, COUNT(DISTINCT DEAN.DDIEM_DA)
		FROM PHONGBAN
		JOIN NHANVIEN ON PHONGBAN.MAPHG = NHANVIEN.PHG
		JOIN DEAN ON NHANVIEN.MANV = DEAN.MADA
		GROUP BY PHONGBAN.TENPHG, NHANVIEN.HONV, NHANVIEN.TENLOT, NHANVIEN.TENNV;
		OPEN @contro;
	--Tạo biến
	DECLARE @tenphg NVARCHAR(50);
	DECLARE @hoten NVARCHAR(100);
	DECLARE @soluong INT;
	declare @stt int=1; --them so thu tu
	FETCH NEXT FROM @contro INTO @tenphg, @hoten, @soluong;
	while (@@FETCH_STATUS = 0)
		begin
			print convert(varchar(3),@stt) +'.' + ' Tên phòng ban: ' + @tenphg;
			print '.' +'Trưong phòng: ' + @hoten ;
			print '.'+  'Tên phòng: ' + @tenphg ;
			print '.'+ 'So lưong đia điem trien khai đe án: ' + CAST(@soluong AS VARCHAR);
			Set @stt+=1;
			FETCH NEXT FROM @contro INTO @tenphg, @hoten, @soluong;
		end;
	close @contro;
	deallocate @contro;
end;
-- Câu 2:--
BEGIN TRANSACTION;
-- Chuyển nhân viên từ phòng ban Tài chính sang Kế toán
UPDATE NHANVIEN
SET PHG = N'Kế Toán'
WHERE MANV = '666' AND PHG = N'Tài chính';
-- Thêm nhân viên mới làm trưởng phòng Tài chính
DECLARE @newMaNV VARCHAR(10);
DECLARE @newHoNV VARCHAR(50);
DECLARE @newTenLot VARCHAR(50);
DECLARE @newTenNV VARCHAR(50);
DECLARE @newMaNQL VARCHAR(10);
DECLARE @newPhg VARCHAR(50);

SET @newMaNV = 666;
SET @newHoNV = 'Nguyen';
SET @newTenLot = 'Van';
SET @newTenNV = 'A';
SET @newMaNQL = 'MADA123';
SET @newPhg = 'Tài chính';

INSERT INTO NHANVIEN (MANV, HONV, TENLOT, TENNV, MA_NQL, PHG)
VALUES (@newMaNV, @newHoNV, @newTenLot, @newTenNV, @newMaNQL, @newPhg);
COMMIT;




--câu 3-- oke
CREATE TRIGGER Trg_KiemSoatPhanCong
ON PHANCONG
AFTER INSERT, UPDATE
AS
BEGIN
	-- Kiểm tra số lượng đề án mà nhân viên nữ tham gia
	IF EXISTS (
		SELECT PHANCONG.MA_NVIEN, COUNT(*) AS SoLuongDeAn
		FROM PHANCONG
		JOIN NHANVIEN ON PHANCONG.MA_NVIEN = NHANVIEN.MANV
		WHERE NHANVIEN.PHAI = N'Nữ'
		GROUP BY PHANCONG.MA_NVIEN
		HAVING COUNT(*) > 3
	)
	BEGIN
		-- Nếu có nhân viên nữ tham gia quá 3 đề án, hủy thao tác và hiển thị thông báo lỗi
		ROLLBACK TRANSACTION
		RAISERROR('Nhân viên nữ không được tham gia quá 3 đề án', 16, 1)
		RETURN
	END
END

--câu 4:--
alter PROCEDURE XuatDuLieuPhongBan1
	@MaPhongBan NVARCHAR(50)
AS
BEGIN
	SELECT pb.TENPHG, COUNT(nv.MANV) AS TONG_NQL
	FROM PHONGBAN pb
	LEFT JOIN NHANVIEN nv ON pb.MAPHG = nv.MA_NQL
	WHERE pb.MAPHG = 10
	GROUP BY pb.TENPHG;
END

EXEC XuatDuLieuPhongBan1 @MaPhongBan= 10

--câu 5:--
alter FUNCTION GetManagerNameForEmployeee(@ma_nv NVARCHAR(10))
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @ten_tp NVARCHAR(255)
    SELECT TOP 1 @ten_tp = CONCAT(nv.HONV, ' ', nv.TENLOT, ' ', nv.TENNV)
    FROM NHANVIEN nv
    INNER JOIN PHANCONG pc ON nv.MANV = pc.MA_NVIEN
    INNER JOIN DEAN d ON nv.MA_NQL = d.MADA
    WHERE nv.MANV = @ma_nv
    GROUP BY nv.HONV, nv.TENLOT, nv.TENNV
    ORDER BY COUNT(pc.SODA) DESC
    RETURN @ten_tp
END
-- dùng hàm
SELECT dbo.GetManagerNameForEmployeee('13') AS HoTenTruongPhong

--Viết hàm cho biết họ tên trưởng phòng của một nhân viên có mã xác định mà nhân viên đó có số lượng đề án tham gia nhiều nhất