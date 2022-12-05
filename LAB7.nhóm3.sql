➢ Cau 1a :Nhập vào MaNV cho biết tuổi của nhân viên này:

if OBJECT_ID('fn_tuoi_nv') is not full 
   drop function fn_tuoi_nv
go
create function fn_tuoi_nv(@MaNhanVien nvarchar(9))
returns int
as
   begin
       return (select year(getdate())-year(ngsinh) 
	   from NHANVIEN where MANV=@MaNhanVien)
   end

print N'Tuổi của nhân viên :' +cast(dbo.fn_tuoi_nv('001') as varchar(5))

select * from nhanvien

1b) Nhập vào Manv cho biết số lượng đề án nhân viên này đã tham gia :

select count(mada) from PHANCONG where MA_NVIEN='001'

select * from PHANCONG

if OBJECT_ID('fn_dean_nv') is not full 
   drop function fn_dean_nv
go
create function fn_dean_nv(@MaNhanVien nvarchar(9))
returns int
as
   begin
       return (select count(mada) from PHANCONG 
	   where MA_NVien=@MaNhanVien)
   end

print N'Số lượng đề án của nhân viên :' +cast(dbo.fn_dean_nv('001') as varchar(5))

1c) Truyền tham số vào phái nam hoặc nữ,
xuất số lượng nhân viên theo phái :

if OBJECT_ID('fn_phai_nv') is not full 
   drop function fn_phai_nv
go
create function fn_phai_nv(@gt nvarchar(4))
returns int
as
   begin
       return (select count(*) from NHANVIEN
	   where upper(phai)=UPPER(@gt))
   end
select  * from NHANVIEN
print N'Số lượng nhân viên nam :' +cast(dbo.fn_phai_nv('Nam') as varchar(5))
print N'Số lượng nhân viên nữ :' +cast(dbo.fn_phai_nv(N'Nữ') as varchar(5))

1d) Truyền tham số đầu vào là tên phòng,
 tính mức lương trung bình của phòng đó, 
 Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình
của phòng đó :

declare @luongtb float
select @luongtb=avg(luong) from NHANVIEN
inner join PHONGBAN on PHONGBAN.MAPHG=NHANVIEN.PHG
where upper(TenPHG)=UPPER(@tenphongban)

insert into @ListNV
    select concat(Honv, ' ',TenLot, ' ',TenNV),luong from NHANVIEN
	where luong>@luongtb

if OBJECT_ID('fn_luong_nv_pb') is not full 
   drop function fn_luong_nv_pb
go
create function fn_luong_nv_pb(@tenphongban nvarchar(15))
returns @ListNV table(Hoten nvarchar(60),luong float)
as
    begin      
       declare @luongtb float
       select @luongtb=avg(luong) from NHANVIEN
       inner join PHONGBAN on PHONGBAN.MAPHG=NHANVIEN.PHG
       where upper(TenPHG)=UPPER(@tenphongban)

	   insert into @ListNV
       select concat(Honv, ' ',TenLot, ' ',TenNV),luong from NHANVIEN
	   where luong>@luongtb

	return
	end
select * from PHONGBAN
select * from dbo.fn_luong_nv_pb(N'Điều Hành');

select avg(luong) from NHANVIEN
         inner join PHONGBAN on PHONGBAN.MAPHG=NHANVIEN.PHG
		  where upper(TenPHG)=UPPER(N'Điều Hành')

1d) Tryền tham số đầu vào là Mã Phòng, cho biết tên phòng ban, họ tên người trưởng phòng
và số lượng đề án mà phòng ban đó chủ trì :

select PHONGBAN.TENPHG,concat(honv,' ',tenlot, ' ',tennv),count(mada)
from PHONGBAN inner join dean on denan.PHONG=PHONGBAN.MAPHG
inner join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
where PHONGBAN.MAPHG=@MaPB
group by tenphg, honv, TENLOT,tennv

if OBJECT_ID('fn_PB_NV_dean') is not full 
   drop function fn_PB_NV_dean
go
create function fn_PB_NV_dean(@MaPB int)
returns @listPB table(TenPhong nvarchar(20), HoTenNV nvarchar(60), slDuan int)
as
    begin
	    insert into @listPB
		select PHONGBAN.TENPHG,concat(honv,' ',tenlot, ' ',tennv),count(mada)
        from PHONGBAN inner join dean on denan.PHONG=PHONGBAN.MAPHG
        inner join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
        where PHONGBAN.MAPHG=@MaPB
        group by tenphg, honv, TENLOT,tennv
	return
	end

select * from dbo.fn_PB_NV_dean('001');

CÂU 2c : Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất :

if OBJECT_ID('vw_PB') is not full 
   drop function vw_PB
go
create view vw_PB(TenPhongBan,HoTenSP,SLNV)
as
   select top(1) with ties tenphg,count(nv.MaNV),concat(tp.honv,' ',tp.tenlot, ' ',tp.tennv)
   from NHANVIEN as nv inner join PHONGBAN  on PHONGBAN.MAPHG=nv.PHG
       inner join NHANVIEN as tp on tp.MANV=PHONGBAN.TRPHG
	   group by TENPHG,tp.TENNV,tp.HONV,tp.TENLOT
	   order by count(nv.MaNV) desc
select * from PHONGBAN
select * from NHANVIEN

select * from vw_PB