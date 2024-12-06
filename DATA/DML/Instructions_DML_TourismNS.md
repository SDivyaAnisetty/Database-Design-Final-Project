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
### ModeOfEntry - dim table
```
/******************************Loading into dim.ModeOfEntry**************************************/

--Delete the existing records from the table
IF OBJECT_ID('dim.ModeOfEntry') IS NOT NULL
BEGIN
    DELETE FROM dim.ModeOfEntry;
END
GO

--Load the records into the table
INSERT INTO dim.ModeOfEntry(pkModeOfEntryID, ukModeOfEntry)
	SELECT stgModeOfEntry.ModeOfEntryID
			,stgModeOfEntry.ModeOfEntry
	FROM Tourism_NovaScotia.stg.dim_ModeOfEntry stgModeOfEntry
	WHERE stgModeOfEntry.ModeOfEntryID not in (SELECT pkModeOfEntryID FROM dim.ModeOfEntry)
;
GO
```
### Seasons - dim table
```
/******************************Loading into dim.Seasons**************************************/

--Delete the existing records from the table
IF OBJECT_ID('dim.Seasons') IS NOT NULL
BEGIN
    DELETE FROM dim.Seasons;
END
GO

--Load the records into the table
INSERT INTO dim.Seasons(pkSeasonsID, ukSeasons, SeasonsOrder)
	SELECT stgSeasons.SeasonsID
			,stgSeasons.Seasons
			,stgSeasons.SeasonsOrder
	FROM Tourism_NovaScotia.stg.dim_Seasons stgSeasons
	WHERE stgSeasons.SeasonsID not in (SELECT pkSeasonsID FROM dim.Seasons)
;
GO
```
### OperatorType - dim table
```
/******************************Loading into dim.OperatorType**************************************/

--Delete the existing records from the table
IF OBJECT_ID('dim.OperatorType') IS NOT NULL
BEGIN
    DELETE FROM dim.OperatorType;
END
GO

--Load the records into the table
INSERT INTO dim.OperatorType(pkOperatorTypeID, OperatorType)
	SELECT stgOperatorType.OperatorTypeID
			,stgOperatorType.OperatorType
	FROM Tourism_NovaScotia.stg.dim_OperatorType stgOperatorType
	WHERE stgOperatorType.OperatorTypeID NOT IN (SELECT pkOperatorTypeID FROM dim.OperatorType)
GO
```
### Provinces - dim table
```
/******************************Loading into dim.Provinces**************************************/

--Delete the existing records from the table
IF OBJECT_ID('dim.Provinces') IS NOT NULL
BEGIN
    DELETE FROM dim.Provinces;
END
GO

--Load the records into the table
INSERT INTO dim.Provinces(pkVisitorOrigin, OriginCountry,Province)
	SELECT stgProvinces.VisitorOrigin
			,stgProvinces.OriginCountry
			,stgProvinces.Province
	FROM Tourism_NovaScotia.stg.dim_Provinces stgProvinces
	WHERE stgProvinces.VisitorOrigin NOT IN (SELECT pkVisitorOrigin FROM dim.Provinces)
GO
```
### Calendar - dim table
```
/******************************Loading into dim.Calendar**************************************/

--Delete the existing records from the table
IF OBJECT_ID('dim.Calendar') IS NOT NULL
BEGIN
    DELETE FROM dim.Calendar;
END
GO

--Load the records into the table
INSERT INTO dim.Calendar(pkDateValue, [Year], [Month], [Day], [MonthName], [Quarter], [DayName], [Weekday])
	SELECT stgCalendar.[Date]
      ,stgCalendar.[Year]
      ,stgCalendar.[Month]
      ,stgCalendar.[Day]
      ,stgCalendar.[MonthName]
      ,stgCalendar.[Quarter]
      ,stgCalendar.[DayName]
      ,stgCalendar.[WeekDay]
	FROM Tourism_NovaScotia.stg.dim_Calendar stgCalendar
	WHERE stgCalendar.[Date] NOT IN (SELECT pkDateValue FROM dim.Calendar)
GO
```
## Step 2️⃣ - Load data into Fact tables
### Region - fact table
```
/******************************Loading into fact.Region**************************************/

--Delete the existing records from the table
IF OBJECT_ID('fact.Region') IS NOT NULL
BEGIN
    DELETE FROM fact.Region;
END
GO

--Load the records into the table
INSERT INTO fact.Region(TouristAttractionID, TouristAttraction, [Name], fkOperatorTypeID, OperatorType
							, Longitude, Latitude, [Location], [Counter])
	SELECT stgRegion.TouristAttractionID
      ,stgRegion.TouristAttraction
      ,stgRegion.[Name]
      ,stgRegion.OperatorTypeID
      ,stgRegion.OperatorType
      ,stgRegion.Longitude
      ,stgRegion.Latitude
      ,stgRegion.[Location]
      ,stgRegion.[Counter]
	FROM stg.fact_Region stgRegion
	WHERE stgRegion.TouristAttractionID NOT IN (SELECT TouristAttractionID FROM fact.Region)
GO
```
### Tourism - fact table
```
/******************************Loading into fact.Tourism**************************************/

--Delete the existing records from the table
IF OBJECT_ID('fact.Tourism') IS NOT NULL
BEGIN
    DELETE FROM fact.Tourism;
END
GO

--Load the records into the table
INSERT INTO fact.Tourism (fkTourismDate, [MonthName], fkModeOfEntryID, fkSeasonsID, 
							fkCountryOriginID, fkVisitorOrigin, VisitorCount, CountryOrigin)
	SELECT [Month/Year]
			,[MonthName]
			,ModeOfEntryID
			,SeasonID
			,CountryOriginID
			,VisitorOrigin
			,VisitorCount
			,CountryOrigin
	FROM stg.fact_Tourism stgTourism
	WHERE stgTourism.[Month/Year] NOT IN (SELECT fkTourismDate FROM fact.Tourism);
GO
```
