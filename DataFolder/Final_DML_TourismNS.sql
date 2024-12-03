USE Tourism_NovaScotia;
GO

/*************************************************************************************************
Step-1 Loading Data into Dimension tables
*************************************************************************************************/

/******************************Loading into dim.Country**************************************/
GO
INSERT INTO dim.Country(pkCountryOriginID, CountryOrigin)
	SELECT stgCountry.CountryOriginID
			,stgCountry.CountryOrigin
	FROM Tourism_NovaScotia.stg.dim_Country stgCountry
	WHERE stgCountry.CountryOriginID not in (SELECT pkCountryOriginID FROM dim.Country)
;
GO

/******************************Loading into dim.ModeOfEntry**************************************/

GO
INSERT INTO dim.ModeOfEntry(pkModeOfEntryID, ukModeOfEntry)
	SELECT stgModeOfEntry.ModeOfEntryID
			,stgModeOfEntry.ModeOfEntry
	FROM Tourism_NovaScotia.stg.dim_ModeOfEntry stgModeOfEntry
	WHERE stgModeOfEntry.ModeOfEntryID not in (SELECT pkModeOfEntryID FROM dim.ModeOfEntry)
;
GO

/******************************Loading into dim.Seasons**************************************/
GO
INSERT INTO dim.Seasons(pkSeasonsID, ukSeasons, SeasonsOrder)
	SELECT stgSeasons.SeasonsID
			,stgSeasons.Seasons
			,stgSeasons.SeasonsOrder
	FROM Tourism_NovaScotia.stg.dim_Seasons stgSeasons
	WHERE stgSeasons.SeasonsID not in (SELECT pkSeasonsID FROM dim.Seasons)
;
GO

/******************************Loading into dim.OperatorType**************************************/
GO
INSERT INTO dim.OperatorType(pkOperatorTypeID, OperatorType)
	SELECT stgOperatorType.OperatorTypeID
			,stgOperatorType.OperatorType
	FROM Tourism_NovaScotia.stg.dim_OperatorType stgOperatorType
	WHERE stgOperatorType.OperatorTypeID NOT IN (SELECT pkOperatorTypeID FROM dim.OperatorType)
GO

/******************************Loading into dim.Provinces**************************************/
GO
INSERT INTO dim.Provinces(pkVisitorOrigin, OriginCountry,Province)
	SELECT stgProvinces.VisitorOrigin
			,stgProvinces.OriginCountry
			,stgProvinces.Province
	FROM Tourism_NovaScotia.stg.dim_Provinces stgProvinces
	WHERE stgProvinces.VisitorOrigin NOT IN (SELECT pkVisitorOrigin FROM dim.Provinces)
GO

/******************************Loading into dim.Calendar**************************************/
GO
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

/*************************************************************************************************
Step-2 Loading Data into Fact tables
*************************************************************************************************/

/******************************Loading into fact.Region**************************************/
GO
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

/******************************Loading into fact.Tourism**************************************/
GO
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