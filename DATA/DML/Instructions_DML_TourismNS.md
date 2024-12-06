# Sample Data Load for Test
Execute the below code to switch the database context.
```
USE Tourism_NovaScotia;
GO
```
## Step 1️⃣ - Load data into Dimension tables
### Country - dim table
```
/******************************Loading into dim.Country**************************************/

--Delete the existing records from the table
IF OBJECT_ID('dim.Country') IS NOT NULL
BEGIN
    DELETE FROM dim.Country;
END
GO

--Load the records into the table
INSERT INTO dim.Country(pkCountryOriginID, CountryOrigin)
	SELECT stgCountry.CountryOriginID
			,stgCountry.CountryOrigin
	FROM Tourism_NovaScotia.stg.dim_Country stgCountry
	WHERE stgCountry.CountryOriginID not in (SELECT pkCountryOriginID FROM dim.Country)
;
GO
```
