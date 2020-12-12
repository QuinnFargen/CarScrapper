


SELECT TOP 500 *
	-- SELECT COUNT(*)
FROM Messy.Cars.vwJsonMultiCarInfo a with (NOLOCK)
WHERE LEFT(A.ListName, 4) < 2000
-- 143643


	IF OBJECT_ID('tempdb..#TopVIN') IS NOT NULL DROP TABLE #TopVIN 
		SELECT --TOP 500 
			A.VIN
			,[JasonID] = MAX(a.JasonID)
		INTO #TopVIN
			-- SELECT COUNT(*)
		FROM Messy.Cars.vwJsonMultiCarInfo a with (NOLOCK)
		GROUP BY A.VIN
	-- 143079
	-- TIME: 0.05

	
	IF OBJECT_ID('Messy.dbo.AllCurrentData') IS NOT NULL DROP TABLE Messy.dbo.AllCurrentData 
		SELECT --TOP 500 
			A.JasonID
			,A.VIN
			,A.Price
			,a.odometer
			,[Year]		= CAST(LEFT(A.ListName, 4) AS int)
			,[Make]		= dbo.GetColumnValue(S.JasonType, '|', 1)
			,[Model]	= dbo.GetColumnValue(S.JasonType, '|', 2)
			,A.VehicleConfig
			,A.color
			,[Damage]	= CASE WHEN A.Damages IS NULL THEN 'NULL'	
								WHEN A.Damages LIKE '%multiple%' THEN 'Multi'
								WHEN A.Damages LIKE '%provided%' THEN 'NotProv'
								ELSE SUBSTRING(A.Damages,18,1)   END
			,A.Usage
			,A.PrevOwners
			,A.Transmission
			,[EngName] = COALESCE(A.EngName
									,CASE	WHEN A.VehicleConfig LIKE '%6cyl%' THEN '6 Cyl'
											WHEN A.VehicleConfig LIKE '%4cyl%' THEN '4 Cyl'
											WHEN A.VehicleConfig LIKE '%8cyl%' THEN '8 Cyl'
											ELSE 'NULL' END )
		INTO Messy.dbo.AllCurrentData 
			-- SELECT COUNT(*)
		FROM Messy.Cars.vwJsonMultiCarInfo a with (NOLOCK)
		JOIN #TopVIN B on A.JasonID = b.JasonID
		JOIN Messy..JsonStorage S with (NOLOCK) ON a.JasonID = S.JasonID
		-- 143079
		-- TIME: 0.19

	SELECT TOP 500 * FROM Messy.dbo.AllCurrentData A with (NOLOCK)
	WHERE a.EngName IS NULL


	
	SELECT TOP 500 
		a.EngName
		,[Str] = CASE	WHEN A.VehicleConfig LIKE '%6cyl%' THEN '6 Cyl'
						WHEN A.VehicleConfig LIKE '%4cyl%' THEN '4 Cyl'
						WHEN A.VehicleConfig LIKE '%8cyl%' THEN '8 Cyl'
						ELSE NULL END
		,a.Year
		, COUNT(*)
	FROM Messy.dbo.AllCurrentData A with (NOLOCK)
	WHERE a.EngName IS NULL
	GROUP BY A.EngName
		,CASE	WHEN A.VehicleConfig LIKE '%6cyl%' THEN '6 Cyl'
						WHEN A.VehicleConfig LIKE '%4cyl%' THEN '4 Cyl'
						WHEN A.VehicleConfig LIKE '%8cyl%' THEN '8 Cyl'
						ELSE NULL END
		,A.Year
	ORDER BY 
		A.Year



	/*		-- Code GraveYard:



	
	SELECT *
	FROM Messy..JsonStorage A with (NOLOCK)
	WHERE a.JasonID IN (109390,130908)


	
SELECT TOP 500 
	A.Usage
	,COUNT(*)
	-- SELECT COUNT(*)
FROM Messy.Cars.vwJsonMultiCarInfo a with (NOLOCK)
GROUP BY a.Usage

	SELECT COUNT(*)
		,[Make]		= dbo.GetColumnValue(S.JasonType, '|', 1)
		,[Model]	= dbo.GetColumnValue(S.JasonType, '|', 2)
	FROM Messy.Cars.vwJsonMultiCarInfo a with (NOLOCK)
	JOIN #TopVIN B on A.JasonID = b.JasonID
	JOIN Messy..JsonStorage S with (NOLOCK) ON a.JasonID = S.JasonID
	GROUP BY 
		 dbo.GetColumnValue(S.JasonType, '|', 1)
		, dbo.GetColumnValue(S.JasonType, '|', 2)
	ORDER BY 
		 dbo.GetColumnValue(S.JasonType, '|', 1)
		, dbo.GetColumnValue(S.JasonType, '|', 2)


-- */