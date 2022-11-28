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
