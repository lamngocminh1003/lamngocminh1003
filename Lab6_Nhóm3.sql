---------Bài 1--------------

create trigger insertNhanVien on NhanVien
for insert
as
	if (select luong from inserted) < 15000
		begin
			print 'Luong phai lon hon 15000'
			rollback transaction
		end
select  * from NHANVIEN
insert into NHANVIEN
values ('Tran','Thanh','Huy','021','2020-12-12','Da Nang','Nam',16000,'004',1)

create trigger insertNhanVien2 on NhanVien
for insert
as
	declare @age int
	set @age = YEAR(GETDATE()) - (select YEAR(NgSinh) from inserted)
	if (@age < 18 or @age > 65)
		begin
			print 'Tuoi khong hop le'
			rollback transaction
		end
insert into NHANVIEN
values ('Tran','Thanh','Huy','024','2010-12-12','Da Nang','Nam',16000,'004',1)

create trigger UpdateNhanVien on NhanVien
for Update
as
	if(select dchi from inserted) like '%HCM'
		begin
			print 'Dia chi khong hop le'
			rollback transaction
		end

select * from NHANVIEN
update NHANVIEN set TENNV = 'NamNV' where MANV = '001'

-------------Bài 2---------------
create trigger insertNhanVien2a on NhanVien
after insert
as
begin
	select COUNT(case when UPPER(phai) = 'Nam' then 1 end) Nam,
		   COUNT(case when UPPER(phai) = N'Nữ' then 1 end) Nữ
	from NHANVIEN
end

insert into NHANVIEN
values ('Tran','Thanh','Huy','005','1965-01-01','Trung Vuong',N'Nữ',16000,'001',1)
select * from NHANVIEN


create trigger updateNhanVien2b on NhanVien
after update
as
begin
	if UPDATE(phai)
		begin
			select COUNT(case when UPPER(phai) = 'Nam' then 1 end) Nam,
				   COUNT(case when UPPER(phai) = N'Nữ' then 1 end) Nữ
			from NHANVIEN
		end
end

update NHANVIEN set PHAI = 'Nam' where MANV = '006'
select * from NHANVIEN

create trigger CountDeAn2c on DeAn
after delete
as
	begin
		select Ma_NVien, COUNT(MADA) as 'so luong' from PHANCONG
		group by MA_NVIEN
	end

select * from DEAN

delete DEAN where MADA = '22'

----------Bài 3------------
delete NHANVIEN where MANV = '001'

create trigger deleteTHANNHANNV on NhanVien
instead of delete
as
begin
	delete from THANNHAN where MA_NVIEN in (select MaNV from deleted)
	delete from NHANVIEN where MANV in (select MaNV from deleted)
end

delete NHANVIEN where MANV = '009'
select * from NHANVIEN

alter trigger insertNhanVien3b on NhanVien
after insert
as begin
	insert into PHANCONG values ((select MANV from inserted),1,1,100)
end

insert into NHANVIEN
values ('Tran','Thanh','Huy','010','1965-01-01','Trung Vuong',N'Nữ',16000,'001',1)

