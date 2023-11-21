select *
from PortfolioProject_New.dbo.NashvilleHousing

--Standardise date format

Select SaleDateCoverted, convert(date,saledate)
From PortfolioProject_New.dbo.NashvilleHousing

update NashvilleHousing
SET SaleDate = convert(date,saledate)


ALTER TABLE NashvilleHousing
Add SaleDateCoverted Date;

Update NashvilleHousing
SET SaleDateCoverted = CONVERT(Date,SaleDate)

--Populace Property Address date.
Select *
From PortfolioProject_New.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.PropertyAddress)
From PortfolioProject_New.dbo.NashvilleHousing a
join PortfolioProject_New.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.propertyaddress, b.PropertyAddress)
From PortfolioProject_New.dbo.NashvilleHousing a
join PortfolioProject_New.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--breaking out address into individual columns (address, city, states)

Select PropertyAddress
From PortfolioProject_New.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

Select 
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)as Address
, substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(propertyaddress)) as Address
From PortfolioProject_New.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(propertyaddress))

Select *
From PortfolioProject_New.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject_New.dbo.NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From PortfolioProject_New.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)

--Change Y and N to Yes and No "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(soldasvacant) as Countsold
From PortfolioProject_New.dbo.NashvilleHousing
group by SoldAsVacant
order by Countsold

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject_New.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   End

--Remove duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject_New.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--order by PropertyAddress



--Delete unused columns

Select *
From PortfolioProject_New.dbo.NashvilleHousing

ALTER TABLE PortfolioProject_New.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject_New.dbo.NashvilleHousing
DROP COLUMN SaleDate
