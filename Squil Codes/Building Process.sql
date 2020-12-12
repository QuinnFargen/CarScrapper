
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

SELECT *
FROM Messy.Cars.vwJsonMultiCarInfo A with (NOLOCK)
WHERE a.JasonID = 1


---------------------------------------------------------
-- Starting a New Json Process
	DECLARE @JsonTypeID int = 1			-- Ed_MultiPageIndCar
	DECLARE @JProcID_Done bigint = NULL	-- Nothing to Update
	DECLARE @JProcID bigint
	EXEC Messy.[Cars].[LogJsonProcess] @JsonTypeID, @JProcID_Done
										, @JProcID OUTPUT
	
	--SELECT @JProcID

	
---------------------------------------------------------
-- Check & Log VinID / Trim Engine

	/*-- Testing:
		DECLARE @JsonTypeID int = 1	
		DECLARE @JProcID	bigint = 1
	-- */

	DECLARE @MMID bigint
	DECLARE @TEID bigint
	
	EXEC Messy.Cars.[Log_MMandTE] @JsonTypeID, @JProcID
								, @MMID OUTPUT, @TEID OUTPUT


	/*-- Testing:
		DECLARE @JsonTypeID int = 1	
		DECLARE @JProcID	bigint = 1
		DECLARE @MMID		bigint = 1
		DECLARE @TEID		bigint = 1
	-- */
	
	DECLARE @VinID bigint

	EXEC Messy.Cars.[LogVIN] @JsonTypeID, @JProcID, @MMID, @TEID
							, @VinID OUTPUT


---------------------------------------------------------
-- Check & Log VinID / Trim Engine



---------------------------------------------------------
-- Ending Json Process
	DECLARE @JsonTypeID int = 1
	DECLARE @JProcID bigint = 3
	EXEC Messy.[Cars].[LogJsonProcess] @JsonTypeID, @JProcID


