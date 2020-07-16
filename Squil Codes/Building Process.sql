
SELECT TOP 500 *
FROM Messy..JsonStorage a with (NOLOCK)
ORDER BY A.JasonID DESC

SELECT TOP 500 *
FROM Messy.[Cars].[vwJsonMultiCarInfo] A with (NOLOCK)
WHERE a.JasonID = 375


SELECT TOP 50 * FROM Messy.Cars.MakeModel A with (NOLOCK)
SELECT TOP 50 * FROM Messy.Cars.TrimEngine A with (NOLOCK)
SELECT TOP 50 * FROM Messy.Cars.VIN A with (NOLOCK)


SELECT TOP 500 * FROM Messy..JsonProcess A with (NOLOCK)
-- TRUNCATE TABLE Messy..JsonProcess

SELECT * FROM Messy..JsonType A with (NOLOCK)



---------------------------------------------------------
-- Starting a New Json Process
	DECLARE @JsonTypeID int = 1	-- Ed_MultiPageIndCar
	DECLARE @JProcID bigint
	SELECT @JProcID = Messy.[Cars].[LogJsonProcess] @JsonTypeID

	
---------------------------------------------------------
-- Check & Log VinID / Trim Engine



---------------------------------------------------------
-- Check & Log VinID / Trim Engine



---------------------------------------------------------
-- Ending Json Process
	DECLARE @JsonTypeID int = 1
	DECLARE @JProcID bigint = 3
	EXEC Messy.[Cars].[LogJsonProcess] @JsonTypeID, @JProcID


