SELECT *
--SELECT TOP 500 *
FROM Messy..JsonStorage A with (NOLOCK)
--WHERE A.JasonDate < CAST(GETDATE() AS DATE)
ORDER BY A.JasonID DESC


			--ID					NVARCHAR(Max)	'$.id'
			--,price				bigint			'$.price'
			--,last_seen_at_date	DATETIME		'$.last_seen_at_date'

			
IF OBJECT_ID('tempdb..#TempALL') IS NOT NULL DROP TABLE #TempALL 
	SELECT --TOP 5000
		[JasonID]			= A.JasonID
		,[JasonType]		= A.JasonType
		,[VIN]				= M.VIN
		,[Price]			= F.Price
		,[odometer]			= O.odometer
		,[ListName]			= M.ListName
		,[color]			= M.color
		,[VehicleConfig]	= M.VehicleConfig
		,[Usage]			= M.Usage
		,[VINurl]			= F.VINurl
		,[unitCode]			= O.unitCode
		,[Currency]			= F.Currency
		,[Damages]			= M.Damages
		,[PrevOwners]		= M.PrevOwners
		,[Transmission]		= M.Transmission
		,[EngName]			= E.EngName
	INTO #TempALL
		-- --EveryThing:
		--,M.*
		--,B.*
		--,O.*
		--,E.*
		--,F.*
	FROM Messy..JsonStorage A with (NOLOCK)
	CROSS APPLY OPENJSON(A.Jason)
		WITH(
				ListName		NVARCHAR(Max)	'$.name'
				,Descript		NVARCHAR(Max)	'$.description'
				,bodyType		NVARCHAR(Max)	'$.bodyType'
				--,imageurl		NVARCHAR(Max)	'$.image'	-- All the same
				,color			NVARCHAR(Max)	'$.color'
				,sku			NVARCHAR(Max)	'$.sku'
				,WheelConfig	NVARCHAR(Max)	'$.driveWheelConfiguration'
				,VehicleConfig	NVARCHAR(Max)	'$.vehicleConfiguration'
				,Transmission	NVARCHAR(Max)	'$.vehicleTransmission'
				,VIN			NVARCHAR(Max)	'$.vehicleIdentificationNumber'
				,Damages		NVARCHAR(Max)	'$.knownVehicleDamages'
				,PrevOwners		NVARCHAR(Max)	'$.numberOfPreviousOwners'
				,Usage			NVARCHAR(Max)	'$.vehicleSpecialUsage'

			-- More Jason
				,Brand		NVARCHAR(MAX)	'$.brand'	AS JSON
				,Odometer	NVARCHAR(MAX)	'$.mileageFromOdometer'	AS JSON
				,Engine		NVARCHAR(MAX)	'$.vehicleEngine'	AS JSON
				,offers		NVARCHAR(MAX)	'$.offers'	AS JSON

			) M
	CROSS APPLY OPENJSON(M.Brand)
		WITH (
				typename		NVARCHAR(Max)	'$.type'
				,carbrand		NVARCHAR(Max)	'$.name'
			) B
	CROSS APPLY OPENJSON(M.Odometer)
		WITH (
				odometer		int				'$.value'
				,unitCode		NVARCHAR(Max)	'$.unitCode'
			) O
	CROSS APPLY OPENJSON(M.Engine)
		WITH (
				EngType		NVARCHAR(Max)	'$.type'
				,EngName	NVARCHAR(Max)	'$.name'
			) E
	CROSS APPLY OPENJSON(M.offers)
		WITH (
				Price		money			'$.price'
				,Currency	NVARCHAR(Max)	'$.priceCurrency'
				,VINurl		NVARCHAR(Max)	'$.url'
				,OfferDesc	NVARCHAR(Max)	'$.description'
			) F
	WHERE A.JasonID <= 7933

	-- 3353
	
	SELECT 
		A.*
	FROM #TempALL A
	ORDER BY A.JasonID DESC

	SELECT *
	FROM #TempALL A
	WHERE A.ListName = '2017 Toyota Camry LE 4dr Sedan (2.5L 4cyl 6A) LE'
	
	SELECT *
	FROM #TempALL A
	WHERE A.ListName NOT LIKE '2018%'
	ORDER BY A.JasonID

	--SELECT COUNT(*), A.VIN
	--FROM #TempALL A
	--GROUP BY A.VIN
	--HAVING COUNT(*) > 1


	
	SELECT A.color, COUNT(*)
	FROM #TempALL A
	GROUP BY A.color
	ORDER BY COUNT(*) DESC

	
	SELECT A.ListName, COUNT(*)
	FROM #TempALL A
	GROUP BY A.ListName
	ORDER BY COUNT(*) DESC

	
	SELECT LEFT(A.VehicleConfig, charindex(' ', VehicleConfig) - 1) , COUNT(*)
	FROM #TempALL A
	GROUP BY LEFT(A.VehicleConfig, charindex(' ', VehicleConfig) - 1) 
	ORDER BY COUNT(*) DESC

	--LEFT(A.VehicleConfig, charindex(' ', VehicleConfig) - 1) 




















