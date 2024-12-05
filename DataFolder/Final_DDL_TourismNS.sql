/*************************************************************************************************
Step-1 Creating Database
*************************************************************************************************/
USE Tourism_NovaScotia;
GO

/*************************************************************************************************
Step-2 Creating Schemas
*************************************************************************************************/

--Creating a schema called 'stg'
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'stg')
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA stg;';
END
GO

--Creating a schema called 'dim'
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dim')
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA dim;';
END
GO

--Creating a schema called 'fact'
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'fact')
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA fact;';
END
GO

/*************************************************************************************************
Step-3 Creating dims
**************************************************************************************************/

/******************************dim.Country**************************************/
-- Drop foreign key constraints referencing dim.Country
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_CountryOriginID')
BEGIN
    ALTER TABLE fact.Tourism 
	DROP CONSTRAINT FK_CountryOriginID;
END

-- Drop and recreate the dim.Country table
DROP TABLE IF EXISTS dim.Country;

CREATE TABLE dim.Country (
    pkCountryOriginID INT NOT NULL
    ,CountryOrigin NVARCHAR(100) NOT NULL
);
GO

/*********Add primary key constraint**********/

ALTER TABLE dim.Country
ADD CONSTRAINT PK_CountryOriginID PRIMARY KEY (pkCountryOriginID);
GO

/******************************dim.ModeOfEntry**************************************/

-- Drop foreign key constraints referencing dim.ModeOfEntry
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_ModeOfEntryID')
BEGIN
    ALTER TABLE fact.Tourism 
	DROP CONSTRAINT FK_ModeOfEntryID;
END

-- Drop and recreate the dim.ModeOfEntry table
DROP TABLE IF EXISTS dim.ModeOfEntry;

CREATE TABLE dim.ModeOfEntry (
    pkModeOfEntryID NVARCHAR(10) NOT NULL --IDENTITY(1, 1)
    ,ukModeOfEntry NVARCHAR(100) NOT NULL
);
GO

/*********Add primary key constraint**********/

ALTER TABLE dim.ModeOfEntry
ADD CONSTRAINT PK_ModeOfEntryID PRIMARY KEY (pkModeOfEntryID);
GO

/*********Add unique key constraint**********/

ALTER TABLE dim.ModeOfEntry
ADD CONSTRAINT UK_ModeOfEntry UNIQUE (ukModeOfEntry);
GO

/******************************dim.Seasons**************************************/

-- Drop foreign key constraints referencing dim.Seasons
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_SeasonID')
BEGIN
    ALTER TABLE fact.Tourism 
	DROP CONSTRAINT FK_SeasonID;
END

-- Drop and recreate the dim.Seasons table
DROP TABLE IF EXISTS dim.Seasons;

CREATE TABLE dim.Seasons (
    pkSeasonsID INT NOT NULL --IDENTITY(11, 1)
    ,ukSeasons NVARCHAR(100) NOT NULL
    ,SeasonsOrder INT NOT NULL
);
GO

/*********Add primary key constraint**********/

ALTER TABLE dim.Seasons
ADD CONSTRAINT PK_SeasonsID PRIMARY KEY (pkSeasonsID);
GO

/*********Add unique key constraint**********/

ALTER TABLE dim.Seasons
ADD CONSTRAINT UK_Seasons UNIQUE (ukSeasons);
GO

/******************************dim.OperatorType**************************************/

-- Drop foreign key constraints referencing dim.OperatorType
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_OperatorTypeID')
BEGIN
    ALTER TABLE fact.Region 
	DROP CONSTRAINT FK_OperatorTypeID;
END

-- Drop and recreate the dim.OperatorType table
DROP TABLE IF EXISTS dim.OperatorType;

CREATE TABLE dim.OperatorType (
    pkOperatorTypeID INT NOT NULL
    ,OperatorType NVARCHAR(100) NOT NULL
);
GO

/*********Add primary key constraint**********/

ALTER TABLE dim.OperatorType
ADD CONSTRAINT PK_OperatorTypeID PRIMARY KEY (pkOperatorTypeID);
GO

/******************************dim.Provinces**************************************/

-- Drop foreign key constraints referencing dim.OperatorType
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_VisitorOrigin')
BEGIN
    ALTER TABLE fact.Tourism 
	DROP CONSTRAINT FK_VisitorOrigin;
END

-- Drop and recreate the dim.Provinces table
DROP TABLE IF EXISTS dim.Provinces;

CREATE TABLE dim.Provinces (
    pkVisitorOrigin NVARCHAR(100) NOT NULL
    ,OriginCountry NVARCHAR(100) NOT NULL
    ,Province NVARCHAR(100) NOT NULL
);
GO

/*********Add primary key constraint**********/

ALTER TABLE dim.Provinces
ADD CONSTRAINT PK_VisitorOrigin PRIMARY KEY (pkVisitorOrigin);
GO

/******************************dim.Calendar**************************************/

-- Drop foreign key constraints referencing dim.Calendar
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_TourismDate')
BEGIN
    ALTER TABLE fact.Tourism 
	DROP CONSTRAINT FK_TourismDate;
END

-- Drop and recreate the dim.Calendar table
DROP TABLE IF EXISTS dim.Calendar;

CREATE TABLE dim.Calendar (
    pkDateValue DATETIME NOT NULL
    ,[Year] NVARCHAR(20) NOT NULL
    ,[Month] INT NOT NULL
    ,[Day] INT NOT NULL
    ,[MonthName] NVARCHAR(20) NOT NULL
    ,[Quarter] NVARCHAR(3) NOT NULL
    ,[DayName] NVARCHAR(20) NOT NULL
    ,Weekday NVARCHAR(10) NOT NULL
);
GO

/*********Add primary key constraint**********/

ALTER TABLE dim.Calendar
ADD CONSTRAINT PK_DateValue PRIMARY KEY (pkDateValue);
GO

/*************************************************************************************************
Step-4 Creating facts
**************************************************************************************************/

/******************************fact.Region**************************************/

-- Drop and recreate the fact.Region table
DROP TABLE IF EXISTS fact.Region;

CREATE TABLE fact.Region (
    TouristAttractionID NVARCHAR(50) NOT NULL
    ,TouristAttraction NVARCHAR(100) NOT NULL
    ,[Name] NVARCHAR(100) NOT NULL
    ,fkOperatorTypeID INT NOT NULL
    ,OperatorType NVARCHAR(100) NOT NULL
    ,Longitude FLOAT NULL
    ,Latitude FLOAT NULL
    ,[Location] NVARCHAR(200) NOT NULL
    ,[Counter] INT NOT NULL
);
GO

/*********Add foreign key constraints**********/

--fkOperatorTypeID from fact.Region ----> pkOperatorTypeID from dim.OperatorType
ALTER TABLE fact.Region
ADD CONSTRAINT FK_OperatorTypeID 
	FOREIGN KEY (fkOperatorTypeID)
	REFERENCES dim.OperatorType (pkOperatorTypeID);
GO

/******************************fact.Tourism**************************************/

-- Drop and recreate the fact.Tourism table
DROP TABLE IF EXISTS fact.Tourism;

CREATE TABLE fact.Tourism (
    fkTourismDate DATETIME NOT NULL
    ,[MonthName] NVARCHAR(50) NOT NULL
    ,fkModeOfEntryID NVARCHAR(10) NOT NULL
    ,fkSeasonsID INT NOT NULL
    ,fkCountryOriginID INT NOT NULL
    ,fkVisitorOrigin NVARCHAR(100) NOT NULL
    ,VisitorCount INT NULL
    ,CountryOrigin NVARCHAR(50) NULL
);
GO

/*********Add foreign key constraints**********/

--fkTourismDate from fact.Tourism ----> pkDateValue from dim.Calendar
ALTER TABLE fact.Tourism
ADD CONSTRAINT FK_TourismDate
	FOREIGN KEY (fkTourismDate)
	REFERENCES dim.Calendar(pkDateValue);
GO

--fkModeOfEntryID from fact.Tourism ----> pkModeOfEntryID from dim.Calendar
ALTER TABLE fact.Tourism
ADD CONSTRAINT FK_ModeOfEntryID
	FOREIGN KEY (fkModeOfEntryID)
	REFERENCES dim.ModeOfEntry(pkModeOfEntryID);
GO

--fkSeasonsID from fact.Tourism ----> pkSeasonsID from dim.Calendar
ALTER TABLE fact.Tourism
ADD CONSTRAINT FK_SeasonID
	FOREIGN KEY (fkSeasonsID)
	REFERENCES dim.Seasons(pkSeasonsID);
GO

--fkCountryOriginID from fact.Tourism ----> pkCountryOriginID from dim.Calendar
ALTER TABLE fact.Tourism
ADD CONSTRAINT FK_CountryOriginID
	FOREIGN KEY (fkCountryOriginID)
	REFERENCES dim.Country(pkCountryOriginID);
GO

--fkVisitorOrigin from fact.Tourism ----> pkVisitorOrigin from dim.Calendar
ALTER TABLE fact.Tourism
ADD CONSTRAINT FK_VisitorOrigin
	FOREIGN KEY (fkVisitorOrigin)
	REFERENCES dim.Provinces(pkVisitorOrigin);
GO