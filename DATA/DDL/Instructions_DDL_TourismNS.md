# Steps to create "Tourism-Nova Scotia" Data Mart
## Overview of "Tourism-Nova Scotia" Data Mart
   -   dim
        -   Country
        -   ModeOfEntry
        -   Seasons
        -   OperatorType
        -   Provinces
        -   Calendar
  -   fact
        -   Region
        -   Tourism

## Step 1️⃣ - Creating a Database
IN SQL Server Management Studio, create a new database called 'Tourism_NovaScotia' and execute the below code to switch the database context.
```
USE Tourism_NovaScotia;
GO
```

## Step 2️⃣ - Creating Schemas
We have two schemas in this mart. Use the below code to create the schemas

   1. dim
```
--Creating a schema called 'dim'
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dim')
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA dim;';
END
GO
```

   2. fact
```
--Creating a schema called 'fact'
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'fact')
BEGIN
    EXEC sp_executesql N'CREATE SCHEMA fact;';
END
GO
```

## Step 3️⃣ - Creating dim tables
### Country - Dimension table
```
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
```
### ModeOfEntry - Dimension table
```
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
```

