/*

Cleaning Data in SQL

*/

select * from dbo.NashvilleHousing



--Standard Date Format

select SaleDateConverted
from dbo.NashvilleHousing

Update NashvilleHousing 
set SaleDateConverted = Convert(Date,SaleDate)

alter Table dbo.NashvilleHousing
Add SaleDateConverted Date

-------------------------------------------------------------------------
-- Populate Property Adress data

select *
from dbo.NashvilleHousing
--where PropertyAddress is Null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.NashvilleHousing a
Join dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.NashvilleHousing a
Join dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


------------------------------------------------------------------
-- Breaking Out Adress into Idividual Column(Adress,City, State)

Select *
From NashvilleHousing


Select 
SUBSTRING(PropertyAddress, 1, CharIndex(',',PropertyAddress)-1) As Address
, SUBSTRING(PropertyAddress, CharIndex(',',PropertyAddress)+1,len(PropertyAddress)) As City
--CharIndex(',',PropertyAddress)
From dbo.NashvilleHousing




alter Table dbo.NashvilleHousing
Add PropertySplitAddress NVarchar(255)

Update NashvilleHousing 
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1,charindex(',', PropertyAddress)-1)


alter Table dbo.NashvilleHousing
Add PropertySplitCity NVarchar(255)

Update NashvilleHousing 
set PropertySplitCity = SUBSTRING(PropertyAddress,CharIndex(',',PropertyAddress)+1, Len(PropertyAddress))



Select *
From NashvilleHousing

select
parsename(Replace(OwnerAddress,',','.'),3),
parsename(Replace(OwnerAddress,',','.'),2),
parsename(Replace(OwnerAddress,',','.'),1)

from NashvilleHousing



alter Table dbo.NashvilleHousing
Add OwnerSplitAddress NVarchar(255)

Update NashvilleHousing 
set OwnerSplitAddress = parsename(Replace(OwnerAddress,',','.'),3)



alter Table dbo.NashvilleHousing
Add OwnerSplitCity NVarchar(255)

Update NashvilleHousing 
set OwnerSplitCity = parsename(Replace(OwnerAddress,',','.'),2)


alter Table dbo.NashvilleHousing
Add OwnerSplitState NVarchar(255)

Update NashvilleHousing 
set OwnerSplitState = parsename(Replace(OwnerAddress,',','.'),1)

---------------------------------------------------------------------

----- Chaange Y and N as Yes and No in  SoldAsVacant column


select distinct SoldAsVacant, count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, Case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
From NashvilleHousing

Update NashvilleHousing 
set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
						when SoldAsVacant = 'N' Then 'No'
						else SoldAsVacant
						end
------------------------------------------------------------------------------------------------

-- Remove Duplicates

with RowNumCTE As(
select *, 
		ROW_NUMBER() Over(
		partition by ParcelId,
					propertyAddress,
					saleprice,
					saledate,
					legalReference
		order by 
		UniqueID)  Row_Num
from dbo.NashvilleHousing
)
select * from
RowNumCTE
where Row_Num >1
order by PropertyAddress


--Delete from
--RowNumCTE
--where Row_Num >1

--------------------------------------------------------
----Delete Unused Column
select * from NashvilleHousing


Alter Table dbo.NashvilleHousing
Drop Column PropertyAddress,SaleDate,TaxDistrict


Alter Table dbo.NashvilleHousing
Rename Column SaleDate 


eXEC sp_rename 'DBO.NashvilleHousing.SaleDate','SaleDateConverted','COLUMN';