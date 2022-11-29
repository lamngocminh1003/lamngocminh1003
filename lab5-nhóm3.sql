--b1.a
 create proc sp_lab5_bai1_a @name nvarchar(20)
as
	begin
		print 'xin chào: '+@name
	end
exec sp_lab5_bai1_a N'Hải Nam'

--b1.b
create proc sp_lab5_bai1_b @numberA int, @numberB int
as
	begin
		declare @sum int =0;
		set @sum = @numberA + @numberB
		print 'Tong:'+cast(@sum as varchar(50))
		end
exec sp_lab5_bai1_b 4,5

--b1.c
create proc sp_lab5_bai1_c @n int
as
	begin
		declare @sum int =0,@i int=0;
		while @i<@n
				begin
					set @sum = @sum + @i
					set @i=@i+2
				end
		print 'sum even:'+cast(@sum as varchar(10))
		end
exec sp_lab5_bai1_c 10

--b1.d
alter  proc sp_lab5_bai1_d @a int,@b int
as
	begin
		while (@a !=@b)
				begin
					if(@a>@b)
						set @a = @a - @b
					else
						set @b = @b - @a
				end
		return @a
		end
declare @c int
exec @c = sp_lab5_bai1_d 8,2
print @c

--b2. Nhập vào @Manv, xuất thông tin các nhân viên theo @Manv.
create proc sp_timnvtheoma
	@MANV nvarchar(9)
as
begin
	select* from NHANVIEN where MANV= @MANV;
END;

EXEC sp_timnvtheoma '005';

--b2. Nhập vào @MaDa (mã đề án), cho biết số lượng nhân viên tham gia đề án đó
create proc sp_TongnvthamgiaDA
	@MADA INT
AS
BEGIN
	SELECT COUNT(MA_NVIEN) AS 'SỐ LƯỢNG' FROM PHANCONG WHERE MADA=@MADA;
END;
EXEC sp_TongnvthamgiaDA 1;

--b2. Nhập vào @MaDa và @Ddiem_DA (địa điểm đề án), cho biết số lượng nhân viên tham gia đề án có mã đề án là @MaDa và địa điểm đề án là @Ddiem_DA
create proc sp_ThongkenvDEAN
	@MADA INT,@DDIEM_DA NVARCHAR(15)
AS
BEGIN
		SELECT COUNT(B.MA_NVIEN) AS 'Số Lượng'
		FROM DEAN A INNER JOIN PHANCONG B ON A.MADA=B.MADA
		WHERE A.MADA = @MADA AND A.DDIEM_DA=@DDIEM_DA;
END;
EXEC sp_ThongkenvDEAN 1, N'Vũng Tàu';

select * from DEAN;

--b2. Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là @Trphg và các nhân viên này không có thân nhân.
create proc sp_TimnvtheoTRP
	@TRPHG NVARCHAR(9)
AS
BEGIN
	SELECT B.* FROM PHONGBAN A INNER JOIN NHANVIEN B ON A.MAPHG =B.PHG
		WHERE A.TRPHG=@TRPHG AND
			NOT EXISTS( SELECT * FROM THANNHAN WHERE MANV =B.MANV)
END;
EXEC sp_TimnvtheoTRP '005' ;

SELECT * FROM PHONGBAN

--b2. Nhập vào @Manv và @Mapb, kiểm tra nhân viên có mã @Manv có thuộc phòng ban có mã @Mapb hay không
create proc sp_KTNVTHUOCPHONG
	@MANV NVARCHAR(9), @MAPB INT
AS
BEGIN
	DECLARE @DEM INT;
	SELECT @DEM = COUNT(MANV) FROM NHANVIEN WHERE MANV =@MANV AND PHG = @MAPB

	RETURN @DEM ;
END;

DECLARE @RESULT INT;
EXEC  @RESULT = sp_KTNVTHUOCPHONG '005',5 ;
SELECT @RESULT;

SELECT * FROM NHANVIEN

--b3. Thêm phòng ban có tên CNTT vào csdl QLDA, các giá trị được thêm vào dưới dạng tham số đầu vào, kiếm tra nếu trùng Maphg thì thông báo thêm thất bại.
create proc sp_THEMPBMOI
	@TENPHG nvarchar (15) ,
	@MAPHG int ,
	@TRPHG nvarchar(9),
	@NG_NHANCHUC date
AS
BEGIN
	IF EXISTS (SELECT * FROM PHONGBAN WHERE MAPHG = @MAPHG)
	BEGIN
		PRINT N'Mã phòng ban đã tồn tại';
		return;
	END
	INSERT INTO [dbo].[PHONGBAN]
           ([TENPHG]
           ,[MAPHG]
           ,[TRPHG]
           ,[NG_NHANCHUC])
     VALUES
           (@TENPHG,@MAPHG,@TRPHG,@NG_NHANCHUC);
END;
EXEC sp_THEMPBMOI N'Công Nghệ Thông Tin', 10,'005','12-12-2020' ;
select * FROM PHONGBAN;

--b3. Cập nhật phòng ban có tên CNTT thành phòng IT.
create proc sp_CapNhatPhongBan
	@OldTENPHG nvarchar (15),
	@TENPHG nvarchar (15),
	@MAPHG int ,
	@TRPHG nvarchar(9),
	@NG_NHANCHUC date
AS
BEGIN
	UPDATE [dbo].[PHONGBAN]
    SET [TENPHG] = @TENPHG
      ,[MAPHG] = @MAPHG
      ,[TRPHG] = @TRPHG
      ,[NG_NHANCHUC] = @NG_NHANCHUC
    WHERE TENPHG = @OldTENPHG ;
END;
EXEC sp_CapNhatPhongBan N'Công Nghệ Thông Tin', 'IT',10,'005','12-12-2020' ;
select * FROM PHONGBAN;

--b3. Thêm một nhân viên vào bảng NhanVien, tất cả giá trị đều truyền dưới dạng tham số đầu vào với điều kiện:
-- nhân viên này trực thuộc phòng IT
--Nhận @luong làm tham số đầu vào cho cột Luong, nếu @luong<25000 thì nhân viên này do nhân viên có mã 009 quản lý, ngươc lại do nhân viên có mã 005 quản lý
--Nếu là nhân viên nam thi nhân viên phải nằm trong độ tuổi 18-65, nếu là nhân viên nữ thì độ tuổi phải từ 18-60.
CREATE proc sp_ThemNV
	@HONV nvarchar (15) ,
	@TENLOT nvarchar(15) ,
	@TENNV nvarchar(15) ,
	@MANV nvarchar(9) ,
	@NGSINH date ,
	@DCHI nvarchar(30) ,
	@PHAI nvarchar(3) ,
	@LUONG float ,
	@PHG int 
as
begin
	if exists (select * from PHONGBAN WHERE TENPHG ='IT')
	BEGIN
		PRINT N'Phòng phải là phòng IT';
		RETURN;
	END;
	DECLARE @MA_NQL NVARCHAR (9);
	IF @LUONG >25000
		SET @MA_NQL ='005';
	ELSE
		SET @MA_NQL ='009';

	DECLARE @AGE INT;
	SELECT @AGE = DATEDIFF(YEAR,@NGSINH,GETDATE())+1;

	IF @PHAI = 'Nam' and (@AGE <18 AND @AGE >60)
	BEGIN
		PRINT N'Nam phải có độ tuổi từ 18-65';
		return;
	END
	else if @PHAI = N'Nữ' and (@AGE <18 AND @AGE >60)
	 BEGIN
		PRINT N'Nữ phải có độ tuổi từ 18-60';
		return;
	 END

	INSERT INTO NHANVIEN
           (HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG)
     VALUES
           (@HONV,@TENLOT,@TENNV,@MANV,@NGSINH,@DCHI,@PHAI,@LUONG,@MA_NQL,@PHG)
end;
EXEC sp_ThemNV N'Nguyễn', N'Quang', N'Minh','030','1-12-1977',N'Đà Nẵng','Nam',30000,10;
selecT * from NHANVIEN