
--CREATE SCHEMA Cars

/*
	IF OBJECT_ID('[Messy].[Cars].[VIN]') IS NOT NULL DROP TABLE [Messy].[Cars].[VIN]
	IF OBJECT_ID('[Messy].[Cars].[TrimEngine]') IS NOT NULL DROP TABLE [Messy].[Cars].[TrimEngine]  
	IF OBJECT_ID('[Messy].[Cars].[MakeModel]') IS NOT NULL DROP TABLE [Messy].[Cars].[MakeModel] 
-- */

--IF OBJECT_ID('[Messy].[Cars].[MakeModel]') IS NOT NULL DROP TABLE [Messy].[Cars].[MakeModel] 
CREATE TABLE [Messy].[Cars].[MakeModel](
	[MMID]			[bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[InsertDate]	[datetime] NOT NULL DEFAULT (getdate()),
	[Make]			[varchar](50) NOT NULL,
	[Model]			[varchar](50) NOT NULL,
	[Year]			[int] NOT NULL,
	CONSTRAINT MakeModel_unique UNIQUE ([Make], [Model], [Year])
)

SELECT *
FROM Messy.Cars.MakeModel A with (NOLOCK)


--IF OBJECT_ID('[Messy].[Cars].[TrimEngine]') IS NOT NULL DROP TABLE [Messy].[Cars].[TrimEngine] 
CREATE TABLE [Messy].[Cars].[TrimEngine](
	[TEID]		[bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[InsertDate]	[datetime] NOT NULL DEFAULT (getdate()),
	[MMID]			[bigint] NOT NULL FOREIGN KEY REFERENCES [Messy].[Cars].[MakeModel]([MMID]),
	[TrimLevel]		[varchar](50) NOT NULL,
	[EngName]		[varchar](50) NULL,	
	[Specialty]		[varchar](50) NULL,	
	CONSTRAINT MMIDTrimEng_unique UNIQUE ([MMID], [TrimLevel], [EngName], [Specialty])
)

SELECT *
FROM Messy.Cars.TrimEngine A with (NOLOCK)



--IF OBJECT_ID('[Messy].[Cars].[VIN]') IS NOT NULL DROP TABLE [Messy].[Cars].[VIN] 
CREATE TABLE [Messy].[Cars].[VIN](
	[VinID]			[bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[InsertDate]	[datetime] NOT NULL DEFAULT (getdate()),
	[VIN]			[varchar](17) NOT NULL,
	[MMID]			[bigint] NOT NULL FOREIGN KEY REFERENCES Messy.Cars.MakeModel([MMID]),
	[TEID]			[bigint] NULL FOREIGN KEY REFERENCES Messy.Cars.TrimEngine([TEID])		
 CONSTRAINT VIN_unique UNIQUE ([VIN])
)

SELECT *
FROM Messy.Cars.VIN A with (NOLOCK)





SELECT * FROM Messy.Cars.MakeModel A with (NOLOCK)
SELECT * FROM Messy.Cars.TrimEngine A with (NOLOCK)
SELECT * FROM Messy.Cars.VIN A with (NOLOCK)



IF OBJECT_ID('tempdb..#Years') IS NOT NULL DROP TABLE #Years 
	SELECT 	
		A.Calendar_Year
	INTO #Years
	FROM Messy..Calendar A with (NOLOCK)
	WHERE 1=1
		AND A.Calendar_Year >= 2000
		AND A.Calendar_Year < 2021
	GROUP BY A.Calendar_Year
	--	SELECT * FROM #Years

	--SELECT * FROM Messy..PossMakeModel A with (NOLOCK)
	----INSERT INTO Messy..PossMakeModel (make,model,minYr)
	----SELECT 'toyota','camry',2000
	--DROP TABLE Messy..PossMakeModel


	--INSERT INTO Messy.Cars.MakeModel (Make, Model, Year)
	--SELECT 
	--	A.make, A.model, [Year] = Y.Calendar_Year
	--FROM Messy..PossMakeModel A with (NOLOCK)
	--LEFT JOIN #Years Y on Y.Calendar_Year >= A.minYr
	--ORDER BY A.make, A.model, A.minYr
	---- 578

	
SELECT A.Make, A.Model, A.Year
FROM Messy.Cars.MakeModel A with (NOLOCK)
WHERE A.Model = 'camry'