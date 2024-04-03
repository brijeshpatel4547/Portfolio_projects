-- Table: public.nashville_housing

DROP TABLE IF EXISTS public.nashville_housing;

CREATE TABLE IF NOT EXISTS public.nashville_housing
(
    UniqueID numeric,
	ParcelID varchar(55),
	LandUse varchar(55),
	PropertyAddress varchar(155),
	SaleDate timestamp,
	SalePrice varchar(50),
	LegalReference varchar(55),
	SoldAsVacant varchar(10),
	OwnerName varchar(155),
	OwnerAddress varchar(155),
	Acreage double precision,
	TaxDistrict varchar(100),
	LandValue numeric,
	BuildingValue numeric,
	TotalValue numeric,
	YearBuilt numeric,
	Bedrooms numeric,
	FullBath numeric,
	HalfBath numeric
);
