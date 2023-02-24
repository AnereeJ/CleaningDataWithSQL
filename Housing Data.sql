/*

	Cleaning Data in SQL Queries

*/

select * 
from Housing_Data..HousingData;


-------------------------------------------------------
-- Standardize Sale Date.
 
 -- Changed date format, updated and then deleted the original to set actual date format.
select SaleDate, CONVERT(date, SaleDate) Date
from Housing_Data..HousingData

alter table HousingData
add Sale_Date date;

update Housing_Data..HousingData
set Sale_Date = CONVERT(date, SaleDate)

alter table HousingData
drop column SaleDate

--------------------------------------------------------
-- 1. Populate Property Address Data.

select *
from Housing_Data..HousingData
--where PropertyAddress is null
order by 2

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) as UpdatedPropertyAddress
from Housing_Data..HousingData a
join Housing_Data..HousingData b
on a.ParcelID = b.ParcelID and
	a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Housing_Data..HousingData a
join Housing_Data..HousingData b
on a.ParcelID = b.ParcelID and
	a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

select *
from Housing_Data..HousingData
where PropertyAddress is null
order by 2

-- 2. Address into different columns of streetname, city, state.

select PropertyAddress
from Housing_Data..HousingData

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as StreetAddress,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
from Housing_Data..HousingData

alter table HousingData
add StreetAddress nvarchar(255)

update Housing_Data..HousingData
set StreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table HousingData
add City nvarchar(255)

update Housing_Data.. HousingData
set City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select * from Housing_Data..HousingData

-- 3. Split Owner Address

select OwnerAddress 
from Housing_Data..HousingData

select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3) as OwnerStreetAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'), 2) as OwnerState,
PARSENAME(REPLACE(OwnerAddress,',','.'), 1) as OwnerCity
from Housing_Data..HousingData
where OwnerAddress is not null

alter table HousingData
add OwnerStreetAddress nvarchar(255);

update Housing_Data..HousingData
set OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
from Housing_Data..HousingData;


alter table HousingData
add OwnerCity nvarchar(255);

update Housing_Data..HousingData
set OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
from Housing_Data..HousingData


alter table HousingData
add OwnerState nvarchar(255);

update Housing_Data..HousingData
set OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from Housing_Data..HousingData

select *
from Housing_Data..HousingData

