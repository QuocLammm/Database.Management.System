CREATE DATABASE QuanLySinhVien_CaoNguyenQuocLam;

USE master;
CREATE LOGIN HoTenSV WITH PASSWORD = 'your_password';
USE QuanLySinhVien_CaoNguyenQuocLam;
CREATE USER HoTenSV_qlsv FOR LOGIN CaoNguyenQuocLam;
GRANT CREATE TABLE TO CaoNguyenQuocLam_qlsv;
GRANT ALTER TABLE TO CaoNguyenQuocLam_qlsv;
GRANT CREATE VIEW TO CaoNguyenQuocLam_qlsv;
GRANT ALTER VIEW TO CaoNguyenQuocLam_qlsv;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO CaoNguyenQuocLam_qlsv;

CREATE TABLE SinhVien (
    MaSV INT PRIMARY KEY,
    HoSV VARCHAR(50),
    TenSV VARCHAR(50),
    GioiTinh NVARCHAR(10),
    DiaChi NVARCHAR(100),
    Email NVARCHAR(100),
    NgaySinh DATE
);
INSERT INTO SinhVien VALUES
(01, 'Nguyen Van','An', 'Nam','Ha Noi', 'nguyenvana@gmail.com','2000-01-01'),
(02, 'Tran Thi','Binh', 'Nu', 'Ho Chi Minh', 'tranthib@gmail.com','2001-02-02'),
(03, 'Cao Nguyen Quoc','Lam', 'Nam', 'Da Nang', 'lam.cnq.63CNTT@ntu.deu.vn','2003-06-10');

CREATE TABLE MonHoc (
    MaMH INT PRIMARY KEY,
    TenMH NVARCHAR(50),
    SoTC INT
);
INSERT INTO MonHoc VALUES
(001, 'He quan tri co so du lieu', 3),
(002, 'Toan roi rac', 4),
(003, 'Lap Trinh C#', 3);

CREATE TABLE KeTQua (
    NamHoc INT,
    MaSV INT,
    MaMH INT,
    Diem FLOAT,
    CONSTRAINT FK_SV FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV),
    CONSTRAINT FK_MH FOREIGN KEY (MaMH) REFERENCES MonHoc (MaMH)
);

INSERT INTO KeTQua VALUES
(2020,01, 001, 8.5),
(2021,01, 002, 7.5),
(2020,02, 001, 9.5),
(2021,02, 002, 6.5);

SELECT MaSV, HoSV, TenSV, DiaChi, Email
FROM SinhVien
WHERE GioiTinh = 'Nữ';

SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen, NgaySinh
FROM SinhVien
WHERE DATEDIFF(YEAR, NgaySinh, GETDATE()) >= 19;

SELECT s.MaSV, s.HoSV, s.TenSV, SUM(s.SoTC) AS TongTinChi
FROM SinhVien s
INNER JOIN KetQua d ON s.MaSV = d.MaSV
WHERE s.GioiTinh = N'Nữ'
GROUP BY s.MaSV, s.HoSV, s.TenSV;

UPDATE MonHoc
SET SoTC = SoTC + 1;

SELECT sv.MaSV, sv.HoSV,sv.TenSV, SUM(dk.SoTC) AS TongTinChi
FROM SinhVien sv
INNER JOIN KeTQua dk ON sv.MaSV = dk.MaSV
WHERE sv.GioiTinh = N'Nữ'
GROUP BY sv.MaSV, sv.HoSV,sv.TenSV
HAVING SUM(dk.SoTC) > 4;

SELECT MaMH, TenMH, SoTC
FROM MonHoc
GROUP BY SoTC
HAVING COUNT(*) > 1