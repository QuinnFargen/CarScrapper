

IF OBJECT_ID('[Messy].[dbo].[JsonType]') IS NOT NULL DROP TABLE [Messy].[dbo].[JsonType] 
CREATE TABLE [Messy].[dbo].[JsonType](
	[JsonTypeID]	[int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[InsertDate]	[datetime] NOT NULL DEFAULT (getdate()),
	[JsonTypeName]	[varchar](250) NOT NULL,
	[JsonTypeDesc]	[varchar](max) NOT NULL,
	[JsonTypeValue]	[varchar](500) NOT NULL,
	CONSTRAINT MakeModel_unique UNIQUE ([JsonTypeName])
)

ALTER TABLE [Messy].[dbo].[JsonStorage]
ADD [JsonTypeID] [int] NULL FOREIGN KEY REFERENCES [Messy].[dbo].[JsonType]([JsonTypeID])



SELECT TOP 500 *
FROM [Messy].[dbo].[JsonStorage]  A with (NOLOCK)

SELECT *
FROM [Messy].[dbo].[JsonType]  A with (NOLOCK)

INSERT INTO Messy..JsonType (JsonTypeName, JsonTypeDesc, JsonTypeValue)
SELECT 
	[JsonTypeName] = 'Ed_MultiPageIndCar'
	, [JsonTypeDesc] = 'Edmunds. Ind car from a page search with multi cars.'
	, [JsonTypeValue] = 'Make|Model|Year|Page|Ord'


--UPDATE Messy..JsonStorage
--SET JsonTypeID = 1