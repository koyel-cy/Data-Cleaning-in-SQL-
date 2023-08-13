select * from dbo.Nashville_housing_data;

select * from dbo.Nashville_housing_data order by 1;

select SaleDate, CONVERT(date, saleDate) from dbo.Nashville_housing_data;



UPDATE Nashville_housing_data 
SET SaleDate = CONVERT(date, saleDate);

ALTER TABLE Nashville_housing_data
ADD saleDateConverted Date;


UPDATE Nashville_housing_data 
SET saleDateConverted = CONVERT(date, saleDate);

--------------------------------------------------------------------
--populate property address data

select * from dbo.Nashville_housing_data 
--where PropertyAddress is null
order by ParcelID;

select parcelID , PropertyAddress,max(totalValue) over(partition by propertyAddress)from dbo.Nashville_housing_data;
-- some of the parcel id and their respective address are same

-- join the similar parcelID and propertyAddress using Aliasing
Select a.parcelID, a.PropertyAddress,  b.parcelID, b.PropertyAddress, isNULL(a.PropertyAddress, b.PropertyAddress) from Nashville_housing_data a 
join Nashville_housing_data b on a.ParcelID = b.ParcelID and a.F1 <> b.F1
where a.PropertyAddress IS NULL; 

update a
set PropertyAddress = isNULL(a.PropertyAddress, b.PropertyAddress)
from Nashville_housing_data a 
join Nashville_housing_data b on a.ParcelID = b.ParcelID and a.F1 <> b.F1
where a.PropertyAddress is null; 

--update a
--set PropertyAddress = 'undefined'
--from Nashville_housing_data a 
--join Nashville_housing_data b on a.ParcelID = b.ParcelID and a.F1 <> b.F1
--where a.PropertyAddress = 0; 

select propertyAddress from Nashville_housing_data;

-----Breaking out address into individual columns(address, city, state).
SELECT 
SUBSTRING(propertyAddress, 1, CHARINDEX('  ', propertyAddress)) as address, 
SUBSTRING(propertyAddress, CHARINDEX('  ', propertyAddress) + 1, LEN(propertyAddress))
as Address from Nashville_housing_data;

ALTER TABLE Nashville_housing_data
ADD propertySplitAddress nvarchar(255);
select * from dbo.Nashville_housing_data order by 1;

select SaleDate, CONVERT(date, saleDate) from dbo.Nashville_housing_data;



UPDATE Nashville_housing_data 
SET SaleDate = CONVERT(date, saleDate);

ALTER TABLE Nashville_housing_data
ADD saleDateConverted Date;


UPDATE Nashville_housing_data 
SET saleDateConverted = CONVERT(date, saleDate);

--------------------------------------------------------------------
--populate property address data

select * from dbo.Nashville_housing_data 
--where PropertyAddress is null
order by ParcelID;

select parcelID , PropertyAddress,max(totalValue) over(partition by propertyAddress)from dbo.Nashville_housing_data;
-- some of the parcel id and their respective address are same

-- join the similar parcelID and propertyAddress using Aliasing
Select a.parcelID, a.PropertyAddress,  b.parcelID, b.PropertyAddress, isNULL(a.PropertyAddress, b.PropertyAddress) from Nashville_housing_data a 
join Nashville_housing_data b on a.ParcelID = b.ParcelID and a.F1 <> b.F1
where a.PropertyAddress = '0'; 

update a
set PropertyAddress = isNULL(a.PropertyAddress, b.PropertyAddress)
from Nashville_housing_data a 
join Nashville_housing_data b on a.ParcelID = b.ParcelID and a.F1 <> b.F1
where a.PropertyAddress is null; 

--update a
--set PropertyAddress = 'undefined'
--from Nashville_housing_data a 
--join Nashville_housing_data b on a.ParcelID = b.ParcelID and a.F1 <> b.F1
--where a.PropertyAddress = 0; 

select propertyAddress from Nashville_housing_data;

-----Breaking out address into individual columns(address, city, state).
SELECT 
SUBSTRING(propertyAddress, 1, CHARINDEX(' ', propertyAddress)- 1 ) as address, 
SUBSTRING(propertyAddress, CHARINDEX(' ', propertyAddress) + 1, LEN(propertyAddress))
as Address from Nashville_housing_data;

ALTER TABLE Nashville_housing_data
ADD propertySplitAddress nvarchar(255);

UPDATE Nashville_housing_data 
SET propertySplitAddress = SUBSTRING(propertyAddress, 1, CHARINDEX('  ', propertyAddress));

ALTER TABLE Nashville_housing_data
ADD propertySplitCity nvarchar(255);


UPDATE Nashville_housing_data 
SET propertySplitCity = SUBSTRING(propertyAddress, CHARINDEX('  ', propertyAddress) + 1, LEN(propertyAddress));

select * from Nashville_housing_data;



--1708 ROBINDALE  CT
--1155 FITZPATRICK  RD
--211 TIMBERWAY  DR

------------------------------------ break out owner address for a state ----------------

select ownerAddress from Nashville_housing_data;

-----change Y and N to yes and No in soldAsVacant
Select SoldAsVacant from Nashville_housing_data;



UPDATE Nashville_housing_data 
SET propertySplitAddress = SUBSTRING(propertyAddress, 1, CHARINDEX('  ', propertyAddress));

ALTER TABLE Nashville_housing_data
ADD propertySplitCity nvarchar(255);


UPDATE Nashville_housing_data 
SET propertySplitCity = SUBSTRING(propertyAddress, CHARINDEX('  ', propertyAddress) + 1, LEN(propertyAddress));

select * from Nashville_housing_data;



--1708 ROBINDALE  CT
--1155 FITZPATRICK  RD
--211 TIMBERWAY  DR

------------------------------------ break out owner address for a state ----------------



-----change Y and N to yes and No in soldAsVacant
Select distinct(SoldAsVacant), count(SoldAsVacant) from Nashville_housing_data group by soldAsVacant order by 2;

--- remove duplicates BY using CTE -----------------------------------------------------------------------------------------
select * from dbo.Nashville_housing_data;

WITH RowNumCTE AS (
select *, ROW_NUMBER() OVER(
PARTITION BY ParcelID, propertyAddress, SaleDate, SalePrice, legalReference order by F1) AS row_num from dbo.Nashville_housing_data
)



select * from RowNumCTE WHERE row_num>1 order by PropertyAddress;

DELETE from RowNumCTE WHERE row_num>1 ;

--- delete unnecessary columns---
Alter table dbo.Nashville_housing_data
drop column TaxDistrict;

