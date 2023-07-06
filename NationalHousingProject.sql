

----Data cleaning using MYSQL




select * from dbo.NationalHousing



-----Change date Format

select SaleDateConverted, CONVERT(Date, SaleDate)
from dbo.NationalHousing


update NationalHousing
Set Saledate = CONVERT(Date, SaleDate)

ALTER TABLE NationalHousing
add SaleDateConverted  Date;

Update NationalHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)


---Change Property address data

select* 
from dbo.NationalHousing
---where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from dbo.NationalHousing a
JOIN dbo.NationalHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL


update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from dbo.NationalHousing a
JOIN dbo.NationalHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL


---- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from dbo.NationalHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

from dbo.NationalHousing


ALTER TABLE NationalHousing
add PropertySplitAddress  nvarchar(255);

Update NationalHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)



ALTER TABLE NationalHousing
add PropertySplitCity  nvarchar(255);

Update NationalHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT * 
from dbo.NationalHousing


SELECT OwnerAddress
from dbo.NationalHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
from dbo.NationalHousing


ALTER TABLE NationalHousing
add OwnerSplitAddress  nvarchar(255);

Update NationalHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE NationalHousing
add OwnerSplitCity  nvarchar(255);

Update NationalHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NationalHousing
add OwnerSplitState  nvarchar(255);

Update NationalHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

Select * 
from dbo.NationalHousing


--- Change Y and N to Yes and No in "Sold as Vacant" field


select Distinct(SoldAsVacant), Count(SoldAsVacant)
from dbo.NationalHousing
Group by SoldAsVacant
order by 2



select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
when SoldAsVacant = 'N' Then 'No'
else SoldAsVacant
end
from dbo.NationalHousing


update dbo.NationalHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
when SoldAsVacant = 'N' Then 'No'
else SoldAsVacant
end



--- Remove Duplicates

WITH RowNumCTE AS(
select *, 
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order BY
			 UniqueID
			 )Row_num
from dbo.NationalHousing
---order by ParcelID
)
Select *
From RowNumCTE
where Row_num>1
order by PropertyAddress



---Delete Unused Columns

select *
from dbo.NationalHousing


ALTER Table dbo.NationalHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER Table dbo.NationalHousing
DROP COLUMN SaleDate