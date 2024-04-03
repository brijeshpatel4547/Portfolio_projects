--************************************************************************************************************

SELECT * FROM
nashville_housing
;
--************************************************************************************************************

-- 1. Handling NULL values in Property Address data

SELECT * FROM
nashville_housing
ORDER BY parcelid


-- The data has multiple records for the same property sold at different prices WITH different unique id.
SELECT a.uniqueid,b.uniqueid,a.parcelid,b.parcelid, a.propertyaddress, b.propertyaddress
FROM nashville_housing A 
JOIN nashville_housing B
ON 	A.parcelid = B.parcelid 
AND A.uniqueid != B.uniqueid
WHERE A.propertyaddress IS NULL
;


UPDATE nashville_housing A
SET propertyaddress = COALESCE(A.propertyaddress , B.propertyaddress)
FROM nashville_housing B
WHERE A.parcelid = B.parcelid and A.uniqueid != B.uniqueid
AND A.propertyaddress IS NULL
;

--************************************************************************************************************

-- 2. Splitting Property Address
/*SELECT propertyaddress,property_street,property_city
FROM nashville_housing;

-- SELECTING THE DATA TO BE INSERTED
SELECT 	SUBSTRING(propertyaddress, 1,  STRPOS(propertyaddress,',')-1) as ADDRESS,
		SUBSTRING(propertyaddress,STRPOS(propertyaddress,',')+1,LENGTH(propertyaddress)) AS STREET
FROM nashville_housing;*/

-- ADDING NEW COLUMNS TO TABLE TO HOLD SLIPT ADDRESS
ALTER TABLE nashville_housing
ADD COLUMN Property_Street Varchar(100),
ADD COLUMN Property_City Varchar(100)

-- UPDATING BOTH COLUMNS WITH REQUIRED VALUES
UPDATE nashville_housing
SET Property_Street = SUBSTRING(propertyaddress, 1,  STRPOS(propertyaddress,',')-1),
	Property_City = SUBSTRING(propertyaddress,STRPOS(propertyaddress,',')+1,LENGTH(propertyaddress))
;

-- AS no longer required dropping it
ALTER TABLE nashville_housing
DROP COLUMN propertyaddress;

--************************************************************************************************************

--3. SPLITTING OWNER ADDRESS

/*SELECT OWNERADDRESS
FROM NASHVILLE_HOUSING;


Select
SPLIT_PART(OWNERADDRESS,',', 3),
SPLIT_PART(OWNERADDRESS,',', 2),
SPLIT_PART(OWNERADDRESS,',', 1)
From Nashville_Housing
;*/

-- ADDING NEW COLUMNS TO TABLE TO HOLD SLIPT ADDRESS
ALTER TABLE nashville_housing
ADD COLUMN owner_Street Varchar(100),
ADD COLUMN owner_City Varchar(100),
ADD COLUMN owner_state Varchar(100)
;

-- UPDATING BOTH COLUMNS WITH REQUIRED VALUES
UPDATE nashville_housing
SET owner_Street = SPLIT_PART(OWNERADDRESS,',', 1),
	owner_City = SPLIT_PART(OWNERADDRESS,',', 2),
	owner_state = SPLIT_PART(OWNERADDRESS,',', 3)
;

-- AS no longer required dropping it
ALTER TABLE nashville_housing
DROP COLUMN owneraddress;


--************************************************************************************************************

SELECT soldasvacant,COUNT(*) FROM
NASHVILLE_HOUSING
GROUP BY soldasvacant ;

-- To stay consistent with the data changing Y/N to Yes/No respectively for soldasvacant
SELECT 	soldasvacant,
		CASE WHEN soldasvacant = 'Y' THEN 'Yes'
			 WHEN soldasvacant = 'N' THEN 'No'
			 ELSE soldasvacant
		END
FROM nashville_housing;

UPDATE nashville_housing
SET soldasvacant = CASE WHEN soldasvacant = 'Y' THEN 'Yes'
			 			WHEN soldasvacant = 'N' THEN 'No'
			 			ELSE soldasvacant
				   END

--************************************************************************************************************
-- SHOWS DUPLICATES
WITH TABLE1 AS
(
	SELECT 	*,
			ROW_NUMBER() OVER (PARTITION BY PARCELID,PROPERTY_STREET,PROPERTY_CITY,SALEPRICE,SALEDATE,LEGALREFERENCE
							  ORDER BY UNIQUEID) AS ROW_NUM
	FROM NASHVILLE_HOUSING
)
SELECT * 
FROM TABLE1
WHERE ROW_NUM > 1
ORDER BY PROPERTY_STREET,PROPERTY_CITY;