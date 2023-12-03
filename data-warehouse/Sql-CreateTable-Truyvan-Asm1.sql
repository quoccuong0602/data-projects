create table Source_Data_Staging(
PetID int, --- ID duy nhất của một vật nuôi
Pet_Type_ID int,
Type varchar(3), -- Loài của vật nuôi (Chó hoặc Mèo)
Age int, -- Số tháng tuổi của vật nuôi
Pet_Breed1_ID int,
Breed1 varchar(255), -- Giống chính của vật nuôi
Pet_Breed2_ID int,
Breed2 varchar(255), -- Giống thứ hai của vật nuôi (nếu là giống lai)
Pet_Gender_ID int,
Gender varchar(6), -- Giới tính của vật nuôi (Male, Female, Mixed)
Pet_Color1_ID int,
Color1 varchar(255), -- Màu sắc thứ nhất của vật nuôi
Pet_Color2_ID int,
Color2 varchar(255), -- Màu sắc thứ hai của vật nuôi (nếu có)
Pet_Color3_ID int,
Color3 varchar(255), -- Màu sắc thứ ba của vật nuôi (nếu có)
Pet_MaturitySize_ID int,
MaturitySize varchar(13), -- Kích thước khi trưởng thành (Small, Medium, Large, Extra Large, Not Specified)
Pet_FurLength_ID int,
FurLength varchar(13), -- Độ dài lông (Short, Medium, Long, Not Specified)
Pet_Vaccinated_ID int,
Vaccinated varchar(8), -- Thú cưng đã được tiêm phòng chưa (Yes, No, Not Sure)
Pet_Dewormed_ID int,
Dewormed varchar(8), -- Thú cưng đã được tẩy giun chưa (Yes, No, Not Sure)
Pet_Sterilized_ID int,
Sterilized varchar(8), -- Thú cưng đã được triệt sản chưa (Yes, No, Not Sure)
Pet_Health_ID int,
Health varchar(14), -- Tình trạng sức khỏe (Healthy, Minor Injury, Serious Injury, Not Specified)
Quantity int, --Số lượng vật nuôi có trong hồ sơ
Fee int, -- Phí nhận nuôi
State_ID int,
State varchar(255), -- Vị trí tiểu bang
RescuerID int, -- Id của người giải cứu
constraint PK_Source_Data_Staging_PetID primary key(PetID)
)

-- Dimension Table
create table Gender_dim(
Gender_ID int identity(1, 1),
Gender_Name varchar(6),
constraint PK_DimGender_Gender_ID primary key(Gender_ID)
)

create table Breed_dim(
Breed_ID int identity(1, 1),
Breed_Name varchar(255),
constraint PK_DimBreed_Breed_ID primary key(Breed_ID)
)

create table Type_dim(
Type_ID int identity(1, 1),
Type_Name varchar(3),
constraint PK_DimType_Type_ID primary key(Type_ID)
)

create table Color_dim(
Color_ID int identity(1, 1),
Color_Name varchar(255),
constraint PK_DimColor_Color_ID primary key(Color_ID)
)

create table MaturitySize_dim(
MaturitySize_ID int identity(1, 1),
MaturitySize_Name varchar(13),
constraint PK_DimMaturitySize_MaturitySize_ID primary key(MaturitySize_ID)
)

create table FurLength_dim(
FurLength_ID int identity(1, 1),
FurLength_Name varchar(13),
constraint PK_FurLength_FurLength_ID primary key(FurLength_ID)
)

create table Vaccinated_dim(
Vaccinated_ID int identity(1, 1),
Vaccinated_Name varchar(8),
constraint PK_Vaccinated_Vaccinated_ID primary key(Vaccinated_ID)
)

create table Dewormed_dim(
Dewormed_ID int identity(1, 1),
Dewormed_Name varchar(8),
constraint PK_Dewormed_Dewormed_ID primary key(Dewormed_ID)
)

create table Sterilized_dim(
Sterilized_ID int identity(1, 1),
Sterilized_Name varchar(8),
constraint PK_Sterilized_Sterilized_ID primary key(Sterilized_ID)
)

create table Health_dim(
Health_ID int identity(1, 1),
Health_Name varchar(14),
constraint PK_Health_Health_ID primary key(Health_ID)
)

create table State_dim(
State_ID int identity(1, 1),
State_Name varchar(255),
constraint PK_State_State_ID primary key(State_ID)
)

Create table PET_Fact(
PetID int,
Pet_Type_ID int,
Pet_Gender_ID int,
Pet_Breed1_ID int,
Pet_Breed2_ID int,
Pet_Color1_ID int,
Pet_Color2_ID int,
Pet_Color3_ID int,
Pet_MaturitySize_ID int,
Pet_Furlength_ID int,
Pet_Vaccinated_ID int,
Pet_Dewormed_ID int,
Pet_Sterilized_ID int,
Pet_Health_ID int,
Pet_State_ID int,
Pet_Age int,
Pet_Quanlity int,
Pet_Fee int,
Pet_RescuerID int
primary key(PetID)
)


--Số lượng vật nuôi được tiêm phòng cũng được triệt sản : 2512 
select count(*) from PET_Fact a
inner join Sterilized_dim b on a.Pet_Sterilized_ID = b.Sterilized_ID 
inner join Vaccinated_dim c on a.Pet_Vaccinated_ID = c.Vaccinated_ID 
where Sterilized_Name = 'Yes' and Vaccinated_Name = 'Yes'

--Số lượng vật nuôi ở mỗi bang :
select State_Name,sum(Pet_Quanlity) quantity from PET_Fact a 
inner join State_dim b on a.Pet_State_ID = b.State_ID 
group by State_Name

--Số lượng vật nuôi theo tình trạng sức khỏe
select Health_Name, sum(Pet_Quanlity) quantity from PET_Fact a
inner join Health_dim b on a.Pet_Health_ID = b.Health_ID
group by Health_Name

--Top 10 ID người nhận nuôi nhiều vật nuôi nhất
select top 10 Pet_RescuerID, sum(Pet_Quanlity) so_luong_vat_nuoi from PET_Fact 
group by Pet_RescuerID 
order by so_luong_vat_nuoi DESC 

--Số lượng vật nuôi được tiêm phòng cũng được triệt sản và cũng đc tẩy giun
select count(*) from PET_Fact a
inner join Sterilized_dim b on a.Pet_Sterilized_ID = b.Sterilized_ID 
inner join Vaccinated_dim c on a.Pet_Vaccinated_ID = c.Vaccinated_ID 
inner join Dewormed_dim e on a.Pet_Dewormed_ID = e.Dewormed_ID
where Sterilized_Name = 'Yes' and Vaccinated_Name = 'Yes' and Dewormed_Name ='Yes'

--Số lượng vật nuôi theo kích thước khi trưởng thành
select MaturitySize_Name, sum(Pet_Quanlity) quantity from PET_Fact a
inner join MaturitySize_dim b on a.Pet_MaturitySize_ID = b.MaturitySize_ID
group by MaturitySize_Name

--Top 5 số lượng vật nuôi có phí rẻ nhất
select top 5 Pet_Fee, sum(Pet_Quanlity) so_luong  from PET_Fact 
group by Pet_Fee
order by Pet_Fee

--Top 5 số lượng vật nuôi có phí cao nhất
select top 5 Pet_Fee, sum(Pet_Quanlity) so_luong  from PET_Fact 
group by Pet_Fee
order by Pet_Fee DESC

--Số lượng vật nuôi có 3 màu 
select count(*) from PET_Fact a
inner join Color_dim b on a.Pet_Color1_ID = b.Color_ID and b.Color_name != 'None'
inner join Color_dim c on a.Pet_Color2_ID = c.Color_ID and c.Color_name != 'None'
inner join Color_dim e on a.Pet_Color3_ID = e.Color_ID and e.Color_name != 'None'

--Số lượng vật nuôi là giống lai và có 3 màu
select count(*) from PET_Fact a
inner join Color_dim b on a.Pet_Color1_ID = b.Color_ID and b.Color_name != 'None'
inner join Color_dim c on a.Pet_Color2_ID = c.Color_ID and c.Color_name != 'None'
inner join Color_dim e on a.Pet_Color3_ID = e.Color_ID and e.Color_name != 'None'
inner join Breed_dim f on a.Pet_Breed2_ID = f.Breed_ID and f.Breed_Name != 'None'
