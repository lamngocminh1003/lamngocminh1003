----Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là TenNV, cột thứ 2 nhận giá trị
---o “TangLuong” nếu lương hiện tại của nhân viên nhở hơn trung bình lương trong
------phòng mà nhân viên đó đang làm việc.
-----o “KhongTangLuong “ nếu lương hiện tại của nhân viên lớn hơn trung bình lương
------trong phòng mà nhân viên đó đang làm việc.-----

SELECT IIF(LUONG>=LTB,'KHÔNG TĂNG LƯƠNG','Tăng lương')
as thuong,tennv,luong,ltb
from

(select TENNV,LUONG,ltb from NHANVIEN,
(select avg(LUONG) as 'ltb',PHG from NHANVIEN group by PHG) AS TAM
WHERE NHANVIEN.PHG = TAM.PHG) as abc

SELECT * FROM NHANVIEN
select avg(LUONG) as 'ltb',PHG from NHANVIEN group by PHG


----Viết chương trình phân loại nhân viên dựa vào mức lương.
---o Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang làm việc thì xếp loại “nhanvien”, ngược lại xếp loại “truongphong”
SELECT IIF(LUONG>=LTB,'truongphong','nhanvien')
as xeploai,tennv,luong,ltb
from

(select TENNV,LUONG,ltb from NHANVIEN,
(select avg(LUONG) as 'ltb',PHG from NHANVIEN group by PHG) AS TAM
WHERE NHANVIEN.PHG = TAM.PHG) as abc

SELECT * FROM NHANVIEN
select avg(LUONG) as 'ltb',PHG from NHANVIEN group by PHG

----.Viết chương trình hiển thị TenNV như hình bên dưới, tùy vào cột phái của nhân viên
select tennv = case PHAI
WHEN 'NAM' THEN 'MR.'+[TENNV]
WHEN N'Nữ' THEN 'MRS.'+[TENNV]
END
FROM NHANVIEN

--Viết chương trình tính thuế mà nhân viên phải đóng theo công thức:
--o 0<luong<25000 thì đóng 10% tiền lương
--o 25000<luong<30000 thì đóng 12% tiền lương
--o 30000<luong<40000 thì đóng 15% tiền lương
--o 40000<luong<50000 thì đóng 20% tiền lương
--o Luong>50000 đóng 25% tiền lương

SELECT TENNV,LUONG,THUE=CASE
WHEN LUONG BETWEEN 0 AND 25000 THEN LUONG*0.1
WHEN LUONG BETWEEN 25000 AND 30000 THEN LUONG*0.12
WHEN LUONG BETWEEN 30000 AND 40000 THEN LUONG*0.15
WHEN LUONG BETWEEN 40000 AND 50000 THEN LUONG*0.2
ELSE LUONG*0.25 END
FROM NHANVIEN

---Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn.

select * from NHANVIEN;

DECLARE @MAX INT, @NUM INT;
SELECT @MAX = MAX(CAST(MANV AS INT)) FROM NHANVIEN;

SET @NUM =1;

WHILE @NUM <= @MAX
BEGIN
	IF @NUM=4
	BEGIN
		SET @NUM=@NUM+1;
		CONTINUE;
	END

	IF @NUM %2 =0
	SELECT HONV,TENLOT, TENNV from NHANVIEN where cast (MANV as int) = @num;

	SET @NUM = @NUM +1;
END;

select * from PHONGBAN
BEGIN TRY
	insert into PHONGBAN(TENPHG,MAPHG,TRPHG, NG_NHANCHUC)
	values (N'Sản Xuất',7, '009','2020/03/02');
	print N'thêm dữ liệu thành công'
END TRY

BEGIN CATCH
	print N'failure : chèn dữ  liệu không thành công'
END CATCH