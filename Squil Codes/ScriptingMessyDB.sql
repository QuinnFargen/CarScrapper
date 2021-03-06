USE [Messy]
GO
/****** Object:  View [Cars].[vwJsonMultiCarInfo]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [Cars].[vwJsonMultiCarInfo]

AS

	SELECT 
		[JasonID]			= A.JasonID
		,[VIN]				= M.VIN
		,[Price]			= M.Price
		,[odometer]			= M.odometer
		,[ListName]			= M.ListName
		,[color]			= M.color
		,[VehicleConfig]	= M.VehicleConfig
		,[Usage]			= M.Usage
		,[VINurl]			= M.VINurl
		,[unitCode]			= M.unitCode
		,[Currency]			= M.Currency
		,[Damages]			= M.Damages
		,[PrevOwners]		= M.PrevOwners
		,[Transmission]		= M.Transmission
		,[EngName]			= M.EngName
		,[OfferDesc]		= M.OfferDesc

	FROM Messy..JsonStorage A with (NOLOCK)
	CROSS APPLY OPENJSON(A.Jason)
		WITH(
				ListName		NVARCHAR(Max)	'$.name'
				,Descript		NVARCHAR(Max)	'$.description'
				,bodyType		NVARCHAR(Max)	'$.bodyType'
				,color			NVARCHAR(Max)	'$.color'
				,sku			NVARCHAR(Max)	'$.sku'
				,WheelConfig	NVARCHAR(Max)	'$.driveWheelConfiguration'
				,VehicleConfig	NVARCHAR(Max)	'$.vehicleConfiguration'
				,Transmission	NVARCHAR(Max)	'$.vehicleTransmission'
				,VIN			NVARCHAR(Max)	'$.vehicleIdentificationNumber'
				,Damages		NVARCHAR(Max)	'$.knownVehicleDamages'
				,PrevOwners		NVARCHAR(Max)	'$.numberOfPreviousOwners'
				,Usage			NVARCHAR(Max)	'$.vehicleSpecialUsage'
				
				,odometer		int				'$.mileageFromOdometer.value'
				,unitCode		NVARCHAR(Max)	'$.mileageFromOdometer.unitCode'
				
				,EngName		NVARCHAR(Max)	'$.vehicleEngine.name'
				
				,Price			money			'$.offers.price'
				,Currency		NVARCHAR(Max)	'$.offers.priceCurrency'
				,VINurl			NVARCHAR(Max)	'$.offers.url'
				,OfferDesc		NVARCHAR(Max)	'$.offers.description'

			) M



GO
/****** Object:  Table [Cars].[MakeModel]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cars].[MakeModel](
	[MMID] [bigint] IDENTITY(1,1) NOT NULL,
	[InsertDate] [datetime] NOT NULL,
	[Make] [varchar](50) NOT NULL,
	[Model] [varchar](50) NOT NULL,
	[Year] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [MakeModel_unique] UNIQUE NONCLUSTERED 
(
	[Make] ASC,
	[Model] ASC,
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cars].[TrimEngine]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cars].[TrimEngine](
	[TEID] [bigint] IDENTITY(1,1) NOT NULL,
	[InsertDate] [datetime] NOT NULL,
	[MMID] [bigint] NOT NULL,
	[TrimLevel] [varchar](50) NOT NULL,
	[EngName] [varchar](50) NULL,
	[Specialty] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [MMIDTrimEng_unique] UNIQUE NONCLUSTERED 
(
	[MMID] ASC,
	[TrimLevel] ASC,
	[EngName] ASC,
	[Specialty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Cars].[VIN]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cars].[VIN](
	[VinID] [bigint] IDENTITY(1,1) NOT NULL,
	[InsertDate] [datetime] NOT NULL,
	[VIN] [varchar](17) NOT NULL,
	[MMID] [bigint] NOT NULL,
	[TEID] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[VinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [VIN_unique] UNIQUE NONCLUSTERED 
(
	[VIN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Calendar]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Calendar](
	[Calendar_Date] [datetime] NOT NULL,
	[Calendar_Year] [int] NOT NULL,
	[Calendar_Month] [int] NOT NULL,
	[Calendar_Day] [int] NOT NULL,
	[Calendar_Day_Suffix] [varchar](4) NULL,
	[Calendar_Quarter] [int] NOT NULL,
	[Calendar_Quarter_Name] [varchar](10) NULL,
	[First_Day_in_Week] [datetime] NOT NULL,
	[Last_Day_in_Week] [datetime] NOT NULL,
	[Is_Week_in_Same_Month] [int] NOT NULL,
	[First_Day_in_Month] [datetime] NOT NULL,
	[Last_Day_in_Month] [datetime] NOT NULL,
	[Is_Last_Day_in_Month] [int] NOT NULL,
	[First_Day_in_Quarter] [datetime] NULL,
	[Last_Day_in_Quarter] [datetime] NULL,
	[Is_Last_Day_in_Quarter] [int] NOT NULL,
	[Day_of_Week] [int] NOT NULL,
	[Day_of_Year] [int] NOT NULL,
	[Week_of_Month] [int] NOT NULL,
	[Week_of_Quarter] [int] NOT NULL,
	[Week_of_Year] [int] NOT NULL,
	[Days_in_Month] [int] NOT NULL,
	[Month_Days_Remaining] [int] NOT NULL,
	[WeekDays_in_Month] [int] NOT NULL,
	[Month_Weekdays_Remaining] [int] NOT NULL,
	[Month_WeekDays_Completed] [int] NOT NULL,
	[Days_in_Quarter] [int] NOT NULL,
	[Quarter_Days_Remaining] [int] NOT NULL,
	[Quarter_Days_Completed] [int] NOT NULL,
	[WeekDays_in_Quarter] [int] NOT NULL,
	[Quarter_Weekdays_Remaining] [tinyint] NULL,
	[Quarter_Weekdays_Completed] [int] NOT NULL,
	[Year_Days_Remaining] [int] NOT NULL,
	[Is_WeekDay] [int] NOT NULL,
	[Is_Leap_Year] [int] NOT NULL,
	[Day_Name] [varchar](10) NOT NULL,
	[Month_Day_Name_Instance] [int] NOT NULL,
	[Quarter_Day_Name_Instance] [int] NOT NULL,
	[Year_Day_Name_Instance] [int] NOT NULL,
	[Month_Name] [varchar](10) NOT NULL,
	[Year_Week] [varchar](6) NOT NULL,
	[Year_Month] [varchar](6) NOT NULL,
	[Year_Quarter] [varchar](6) NOT NULL,
	[Is_Holiday_USA] [int] NULL,
	[Is_Holiday_CANADA] [int] NULL,
	[Holiday_Name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Calendar_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CamryJasoned1]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CamryJasoned1](
	[JasonID] [int] IDENTITY(1,1) NOT NULL,
	[ID] [nvarchar](max) NULL,
	[vin] [nvarchar](max) NULL,
	[heading] [nvarchar](max) NULL,
	[price] [bigint] NULL,
	[miles] [bigint] NULL,
	[msrp] [bigint] NULL,
	[data_source] [nvarchar](max) NULL,
	[is_certified] [nvarchar](max) NULL,
	[vdp_url] [nvarchar](max) NULL,
	[carfax_1_owner] [nvarchar](max) NULL,
	[carfax_clean_title] [nvarchar](max) NULL,
	[exterior_color] [nvarchar](max) NULL,
	[interior_color] [nvarchar](max) NULL,
	[dom] [bigint] NULL,
	[dom_180] [bigint] NULL,
	[dom_active] [bigint] NULL,
	[seller_type] [nvarchar](max) NULL,
	[inventory_type] [nvarchar](max) NULL,
	[stock_no] [nvarchar](max) NULL,
	[last_seen_at] [bigint] NULL,
	[last_seen_at_date] [datetime] NULL,
	[scraped_at] [bigint] NULL,
	[scraped_at_date] [datetime] NULL,
	[first_seen_at] [bigint] NULL,
	[first_seen_at_date] [datetime] NULL,
	[ref_price] [bigint] NULL,
	[ref_price_dt] [bigint] NULL,
	[ref_miles] [bigint] NULL,
	[ref_miles_dt] [bigint] NULL,
	[source] [nvarchar](max) NULL,
	[media] [nvarchar](max) NULL,
	[dealer] [nvarchar](max) NULL,
	[build] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JsonProcess]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JsonProcess](
	[JProcID] [bigint] IDENTITY(1,1) NOT NULL,
	[JProcDateStart] [datetime] NOT NULL,
	[JProcDateEnd] [datetime] NULL,
	[JasonID] [bigint] NOT NULL,
	[Make] [varchar](25) NULL,
	[Model] [varchar](25) NULL,
	[Year] [varchar](25) NULL,
	[Page] [varchar](25) NULL,
	[Ord] [varchar](25) NULL,
PRIMARY KEY CLUSTERED 
(
	[JProcID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JsonStorage]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JsonStorage](
	[JasonID] [bigint] IDENTITY(1,1) NOT NULL,
	[JasonDate] [datetime] NOT NULL,
	[Jason] [nvarchar](max) NULL,
	[JasonType] [varchar](100) NULL,
	[JsonTypeID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[JasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JsonType]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JsonType](
	[JsonTypeID] [int] IDENTITY(1,1) NOT NULL,
	[InsertDate] [datetime] NOT NULL,
	[JsonTypeName] [varchar](250) NOT NULL,
	[JsonTypeDesc] [varchar](max) NOT NULL,
	[JsonTypeValue] [varchar](500) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[JsonTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [MakeModel_unique] UNIQUE NONCLUSTERED 
(
	[JsonTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MakeModel]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MakeModel](
	[MMTID] [bigint] IDENTITY(1,1) NOT NULL,
	[InsertDate] [datetime] NOT NULL,
	[Make] [varchar](50) NULL,
	[Model] [varchar](50) NULL,
	[YearMin] [int] NULL,
	[YearMax] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MMTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PyJobInfo]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PyJobInfo](
	[PyJobID] [int] IDENTITY(1,1) NOT NULL,
	[PyJobDate] [datetime] NOT NULL,
	[PyJobName] [nvarchar](max) NULL,
	[PyJobFlag] [int] NULL,
	[PyJobInt1] [int] NULL,
	[PyJobInt2] [int] NULL,
	[PyJobVal1] [nvarchar](max) NULL,
	[PyJobVal2] [nvarchar](max) NULL,
 CONSTRAINT [PK_PyJob_ID] PRIMARY KEY CLUSTERED 
(
	[PyJobID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SampleData]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SampleData](
	[DataID] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[Minitial] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[DOB] [varchar](50) NULL,
	[SSN_TIN] [varchar](50) NULL,
	[Gender] [varchar](50) NULL,
	[Income] [varchar](50) NULL,
	[Debt] [varchar](50) NULL,
	[Addr1] [varchar](50) NULL,
	[Addr2] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Zip] [varchar](50) NULL,
	[PersEmail] [varchar](50) NULL,
	[WorkEmail] [varchar](50) NULL,
	[WorkPhone] [varchar](50) NULL,
	[HomePhone] [varchar](50) NULL,
	[CellPhone] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TriggaLog]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TriggaLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[EVENTXML] [xml] NULL,
	[EventDate] [datetime] NOT NULL,
	[EventType]  AS (CONVERT([nvarchar](100),[dbo].[GetEventType]([EVENTXML]))),
	[LoginName]  AS ([dbo].[GetLoginName]([EVENTXML])),
	[ObjectName]  AS ([dbo].[GetObjectName]([EVENTXML])),
	[SchemaName]  AS ([dbo].[GetSchemaName]([EVENTXML])),
	[DBName]  AS ([dbo].[GetDatabaseName]([EVENTXML])),
	[ServerName]  AS ([dbo].[GetServerName]([EVENTXML])),
	[EventCode]  AS ([dbo].[GetTSQLCommand]([EVENTXML]))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Trim]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trim](
	[TrimID] [bigint] IDENTITY(1,1) NOT NULL,
	[InsertDate] [datetime] NOT NULL,
	[Trim] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Cars].[MakeModel] ADD  DEFAULT (getdate()) FOR [InsertDate]
GO
ALTER TABLE [Cars].[TrimEngine] ADD  DEFAULT (getdate()) FOR [InsertDate]
GO
ALTER TABLE [Cars].[VIN] ADD  DEFAULT (getdate()) FOR [InsertDate]
GO
ALTER TABLE [dbo].[JsonProcess] ADD  DEFAULT (getdate()) FOR [JProcDateStart]
GO
ALTER TABLE [dbo].[JsonStorage] ADD  DEFAULT (getdate()) FOR [JasonDate]
GO
ALTER TABLE [dbo].[JsonType] ADD  DEFAULT (getdate()) FOR [InsertDate]
GO
ALTER TABLE [dbo].[MakeModel] ADD  DEFAULT (getdate()) FOR [InsertDate]
GO
ALTER TABLE [dbo].[PyJobInfo] ADD  DEFAULT (getdate()) FOR [PyJobDate]
GO
ALTER TABLE [dbo].[TriggaLog] ADD  DEFAULT (getdate()) FOR [EventDate]
GO
ALTER TABLE [dbo].[Trim] ADD  DEFAULT (getdate()) FOR [InsertDate]
GO
ALTER TABLE [Cars].[TrimEngine]  WITH CHECK ADD FOREIGN KEY([MMID])
REFERENCES [Cars].[MakeModel] ([MMID])
GO
ALTER TABLE [Cars].[VIN]  WITH CHECK ADD FOREIGN KEY([MMID])
REFERENCES [Cars].[MakeModel] ([MMID])
GO
ALTER TABLE [Cars].[VIN]  WITH CHECK ADD FOREIGN KEY([TEID])
REFERENCES [Cars].[TrimEngine] ([TEID])
GO
ALTER TABLE [dbo].[JsonProcess]  WITH CHECK ADD FOREIGN KEY([JasonID])
REFERENCES [dbo].[JsonStorage] ([JasonID])
GO
ALTER TABLE [dbo].[JsonStorage]  WITH CHECK ADD FOREIGN KEY([JsonTypeID])
REFERENCES [dbo].[JsonType] ([JsonTypeID])
GO
ALTER TABLE [dbo].[JsonStorage]  WITH CHECK ADD  CONSTRAINT [Content should be formatted as JSON] CHECK  ((isjson([Jason])>(0)))
GO
ALTER TABLE [dbo].[JsonStorage] CHECK CONSTRAINT [Content should be formatted as JSON]
GO
/****** Object:  StoredProcedure [Cars].[JsonProcessLog]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Quinn Fargen
-- Create date: 05.03.20
-- Description:	Log Json Process
-- =============================================

CREATE PROCEDURE [Cars].[JsonProcessLog]
	
	@JsonTypeID int
	,@JProcID bigint = NULL

AS
BEGIN
	SET NOCOUNT ON;

	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--
	-- If Param NOT NULL then:
	--		Processing is Complete.
	--		We want to update JProcDateEnd

	IF @JProcID IS NOT NULL
	BEGIN

		UPDATE Messy.dbo.JsonProcess
		SET JProcDateEnd = GETDATE()
		FROM Messy.dbo.JsonProcess A with (NOLOCK)
		WHERE A.JProcID = @JProcID

	END -- IF @JProcID IS NOT NULL


		
	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--
	-- If JsonTypeID = 1
	--		This is the Ed_MultiPageIndCar
	--		Make|Model|Year|Page|Ord
	--
	-- If Param Null then:
	--		Start of Process and need to find JasonID to Process
	--		Log in JsonProcess Table Start

	IF @JsonTypeID = 1 AND @JProcID IS NULL
	BEGIN

		-- Identify Who to Process
		DECLARE @JasonID bigint = 
			(
			SELECT TOP 1 A.JasonID
			FROM Messy.dbo.JsonStorage A with (NOLOCK)
			LEFT JOIN Messy.dbo.JsonProcess B with (NOLOCK) ON A.JasonID = B.JasonID
			WHERE 1=1
				AND B.JasonID IS NULL
			ORDER BY A.JasonID
			)

		-- Null if No one to Process
		IF @JasonID IS NULL
		BEGIN
			-- No One Left to Process
			RETURN -5
		END -- IF @JasonID IS NULL

		-- NOT NULL if someone exist to Process
		IF @JasonID IS NOT NULL
		BEGIN

			INSERT INTO Messy.dbo.JsonProcess (JasonID,Make,Model,Year,Page,Ord)
			SELECT 
				[JasonID]	= A.JasonID
				,[Make]		= dbo.GetColumnValue(A.JasonType, '|', 1)
				,[Model]	= dbo.GetColumnValue(A.JasonType, '|', 2)
				,[Year]		= dbo.GetColumnValue(A.JasonType, '|', 3)
				,[Page]		= dbo.GetColumnValue(A.JasonType, '|', 4)
				,[Ord]		= dbo.GetColumnValue(A.JasonType, '|', 5)
			FROM Messy.dbo.JsonStorage A with (NOLOCK)
			WHERE A.JasonID = @JasonID

			-- Return @JProcID Created
			DECLARE @JProcID_New bigint = SCOPE_IDENTITY()
			RETURN @JProcID_New

		END -- IF @JasonID IS NOT NULL

	END -- IF @JsonTypeID = 1 AND @JProcID IS NULL











END
GO
/****** Object:  StoredProcedure [Cars].[LogJsonProcess]    Script Date: 7/21/2020 9:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Quinn Fargen
-- Create date: 05.03.20
-- Description:	Log Json Process
-- =============================================

CREATE PROCEDURE [Cars].[LogJsonProcess]
	
	@JsonTypeID int
	,@JProcID bigint = NULL 

AS
BEGIN
	SET NOCOUNT ON;

	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--
	-- If Param NOT NULL then:
	--		Processing is Complete.
	--		We want to update JProcDateEnd

	IF @JProcID IS NOT NULL
	BEGIN

		UPDATE Messy.dbo.JsonProcess
		SET JProcDateEnd = GETDATE()
		FROM Messy.dbo.JsonProcess A with (NOLOCK)
		WHERE A.JProcID = @JProcID

	END -- IF @JProcID IS NOT NULL


		
	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--	--
	-- If JsonTypeID = 1
	--		This is the Ed_MultiPageIndCar
	--		Make|Model|Year|Page|Ord
	--
	-- If Param Null then:
	--		Start of Process and need to find JasonID to Process
	--		Log in JsonProcess Table Start

	IF @JsonTypeID = 1 AND @JProcID IS NULL
	BEGIN

		-- Identify Who to Process
		DECLARE @JasonID bigint = 
			(
			SELECT TOP 1 A.JasonID
			FROM Messy.dbo.JsonStorage A with (NOLOCK)
			LEFT JOIN Messy.dbo.JsonProcess B with (NOLOCK) ON A.JasonID = B.JasonID
			WHERE 1=1
				AND B.JasonID IS NULL
			ORDER BY A.JasonID
			)

		-- Null if No one to Process
		IF @JasonID IS NULL
		BEGIN
			-- No One Left to Process
			RETURN -5
		END -- IF @JasonID IS NULL

		-- NOT NULL if someone exist to Process
		IF @JasonID IS NOT NULL
		BEGIN

			INSERT INTO Messy.dbo.JsonProcess (JasonID,Make,Model,Year,Page,Ord)
			SELECT 
				[JasonID]	= A.JasonID
				,[Make]		= dbo.GetColumnValue(A.JasonType, '|', 1)
				,[Model]	= dbo.GetColumnValue(A.JasonType, '|', 2)
				,[Year]		= dbo.GetColumnValue(A.JasonType, '|', 3)
				,[Page]		= dbo.GetColumnValue(A.JasonType, '|', 4)
				,[Ord]		= dbo.GetColumnValue(A.JasonType, '|', 5)
			FROM Messy.dbo.JsonStorage A with (NOLOCK)
			WHERE A.JasonID = @JasonID

			-- Return @JProcID Created & @JasonID
			DECLARE @JProcID_New bigint = SCOPE_IDENTITY()
			SELECT @JProcID_New

		END -- IF @JasonID IS NOT NULL

	END -- IF @JsonTypeID = 1 AND @JProcID IS NULL



END -- END SP
GO
