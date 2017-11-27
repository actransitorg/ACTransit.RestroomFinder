USE [Restroom]
GO
/****** Object:  UserDefinedFunction [dbo].[CharToTable]    Script Date: 11/7/2017 3:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[CharToTable] 
(
	@list	 NTEXT
    ,@delimiter NCHAR(1) = N','
)

RETURNS @Table TABLE 
(
     listpos INT IDENTITY(1, 1) NOT NULL
    ,str	   NVARCHAR(4000)
    ,nstr	   NVARCHAR(2000)
) 
AS
BEGIN
  -- SELECT * FROM [dbo].[CharToTable]('Abc,A,V,G,KJHLJJKHGGF,J,L,O,O,I,U,Y,G3,V2,R1',',')
      DECLARE @pos	    INT
		   ,@textpos  INT = 1
		   ,@chunklen SMALLINT
		   ,@tmpstr   NVARCHAR(4000)
		   ,@leftover NVARCHAR(4000) = ''
		   ,@tmpval   NVARCHAR(4000);

      WHILE @textpos <= DATALENGTH(@list) / 2
      BEGIN
		  SELECT @chunklen = 4000 - DATALENGTH(@leftover) / 2
			   ,@tmpstr = @leftover + SUBSTRING(@list, @textpos, @chunklen)
			   ,@textpos = @textpos + @chunklen
			   ,@pos = CHARINDEX(@delimiter, @tmpstr);

            WHILE @pos > 0
            BEGIN
                  SET @tmpval = LTRIM(RTRIM(LEFT(@tmpstr, @pos - 1)));

                  INSERT @Table (str, nstr) VALUES(@tmpval, @tmpval);

			   SELECT @tmpstr = SUBSTRING(@tmpstr, @pos + 1, LEN(@tmpstr))
				    ,@pos = CHARINDEX(@delimiter, @tmpstr);
            END

            SET @leftover = @tmpstr;
      END

      INSERT @Table(str, nstr) VALUES (LTRIM(RTRIM(@leftover)) ,LTRIM(RTRIM(@leftover)));

      RETURN;
END



GO
/****** Object:  Table [dbo].[Confirmation]    Script Date: 11/7/2017 3:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Confirmation](
	[ConfirmationId] [bigint] IDENTITY(1,1) NOT NULL,
	[Badge] [varchar](6) NOT NULL,
	[Agreed] [bit] NOT NULL,
	[IncidentDateTime] [datetime2](7) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feedback]    Script Date: 11/7/2017 3:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedback](
	[FeedbackId] [bigint] IDENTITY(1,1) NOT NULL,
	[RestroomId] [int] NOT NULL,
	[Badge] [varchar](6) NOT NULL,
	[NeedAttention] [bit] NOT NULL,
	[FeedbackText] [varchar](255) NULL,
	[Rate] [decimal](3, 2) NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_Feedback] PRIMARY KEY CLUSTERED 
(
	[FeedbackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log]    Script Date: 11/7/2017 3:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log](
	[LogId] [bigint] IDENTITY(1,1) NOT NULL,
	[DeviceId] [varchar](100) NULL,
	[DeviceModel] [varchar](100) NULL,
	[DeviceOS] [varchar](50) NULL,
	[Description] [varchar](255) NULL,
	[AddDateTime] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Restroom]    Script Date: 11/7/2017 3:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restroom](
    [RestroomId]    INT               IDENTITY (1, 1) NOT NULL,
    [RestroomType]  VARCHAR (16)      NULL,
    [RestroomName]  VARCHAR (52)      NULL,
    [Address]       VARCHAR (49)      NULL,
    [City]          VARCHAR (14)      NULL,
    [State]         VARCHAR (2)       NULL,
    [Zip]           INT               NULL,
    [Country]       VARCHAR (3)       NULL,
    [DrinkingWater] VARCHAR (3)       NULL,
    [ACTRoute]      VARCHAR (1000)    NULL,
    [Hours]         VARCHAR (130)     NULL,
    [Note]          VARCHAR (42)      NULL,
    [LongDec]       DECIMAL (9, 6)    NULL,
    [LatDec]        DECIMAL (9, 6)    NULL,
    [Geo]           [sys].[geography] NULL,
    [AddUserId]     VARCHAR (50)      NULL,
    [AddDateTime]   DATETIME          NULL,
    [UpdUserId]     VARCHAR (50)      NULL,
    [UpdDateTime]   DATETIME          NULL,
    [Active]        BIT               DEFAULT ((1)) NOT NULL,
 CONSTRAINT [PK_BTime] PRIMARY KEY CLUSTERED 
(
	[RestroomId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Confirmation] ON 
GO
INSERT [dbo].[Confirmation] ([ConfirmationId], [Badge], [Agreed], [IncidentDateTime], [AddDateTime]) VALUES (1, N'123456', 1, CAST(N'2016-08-04T09:47:58.0000000' AS DateTime2), CAST(N'2016-08-04T09:48:02.5032379' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Confirmation] OFF
GO
SET IDENTITY_INSERT [dbo].[Feedback] ON 
GO
INSERT [dbo].[Feedback] ([FeedbackId], [RestroomId], [Badge], [NeedAttention], [FeedbackText], [Rate], [AddDateTime], [UpdDateTime]) VALUES (1, 1, N'123456', 0, N'Bathroom tolerable ..', CAST(3.00 AS Decimal(3, 2)), CAST(N'2016-09-10T13:45:06.9405470' AS DateTime2), CAST(N'2016-09-10T13:45:06.9405470' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Feedback] OFF
GO
SET IDENTITY_INSERT [dbo].[Log] ON 
GO
INSERT [dbo].[Log] ([LogId], [DeviceId], [DeviceModel], [DeviceOS], [Description], [AddDateTime]) VALUES (1, NULL, NULL, NULL, N'PostOperatorInfo. Employee found.', CAST(N'2016-08-02T15:49:36.5005200' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Log] OFF
GO
SET IDENTITY_INSERT [dbo].[Restroom] ON 
GO
INSERT [dbo].[Restroom] ([RestroomId], [RestroomType], [RestroomName], [Address], [City], [State], [Zip], [Country], [DrinkingWater], [ACTRoute], [Hours], [Note], [LongDec], [LatDec], [Geo], [AddUserId], [AddDateTime], [UpdUserId], [UpdDateTime]) VALUES 
(1, N'NON-PAID', N'Gas Station ', N'123 Somewhere Ave', N'Alameda', N'CA', 94501, N'USA', N'Y', N'51A,663,O,W', N'Sun-Sat 5am-11pm', NULL, CAST(-122.2 AS Decimal(9, 6)), CAST(37.7 AS Decimal(9, 6)), 0xE6100000010C1B48179B56E24240F9BA0CFFE98E5EC0, NULL, NULL, N'Employee1', CAST(N'2017-03-20T11:28:53.920' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Restroom] OFF
GO
/****** Object:  StoredProcedure [dbo].[GetRestroom]    Script Date: 11/7/2017 3:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRestroom]
(
	@RestroomId Int 
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @AverateRatingCutoffDate DATE = DATEADD(WEEK, -1, GETDATE())

	;WITH AverageRating AS 
	(
		SELECT 
			f.RestroomId,
			AVG(f.Rate) 'AverageRating'
		FROM 
			dbo.Feedback f
		WHERE 
			f.RestroomId = @RestroomId
			AND f.AddDateTime >= @AverateRatingCutoffDate
		GROUP BY 
			f.RestroomId
	)
	SELECT 
		rs.RestroomId,
		rs.RestroomType,
		rs.RestroomName,
		rs.Address,
		rs.City,
		rs.State,
		rs.Zip,
		rs.Country,
		rs.DrinkingWater,
		rs.ACTRoute,
		rs.Hours,
		rs.Note,
		rs.LongDec,
		rs.LatDec,
		rs.Geo,
		ar.AverageRating
	FROM 
		dbo.Restroom rs 
		LEFT OUTER JOIN AverageRating ar
			ON rs.RestroomId = ar.RestroomId
	WHERE 
		rs.RestroomId = @RestroomId

END
GO
/****** Object:  StoredProcedure [dbo].[GetRestroomFeedback]    Script Date: 11/7/2017 3:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetRestroomFeedback]

 @StartDate DATE = NULL
,@EndDate DATE = NULL
,@Badge NVARCHAR(6) = NULL
,@RestroomName NVARCHAR(MAX) = NULL
,@City NVARCHAR(MAX) = NULL
,@Route NVARCHAR(MAX) = NULL
,@NeedsAttention INT = NULL -- -1=All, 0=No, 1=Yes
,@RestroomType NVARCHAR(MAX) = NULL
 
AS
BEGIN

IF @StartDate IS NULL OR @EndDate IS NULL 
BEGIN
    SET @StartDate = DATEADD(DAY,-1, DATEADD(wk, DATEDIFF(wk, 6, CURRENT_TIMESTAMP), 0) ) --start of last week then minus one so week starts Sunday
    SET @EndDate =   DATEADD(DAY,-1, DATEADD(wk, DATEDIFF(wk, 6, CURRENT_TIMESTAMP), 6) ) --end of last week then minus one so week starts Sunday
END

IF @RestroomName = '(All)' SET @RestroomName = NULL
IF @City = '(All)' SET @City = NULL
IF @Route = '(All)' SET @Route = NULL
IF @RestroomType = '(All)' SET @RestroomType = NULL
    
IF @Badge = '' 
    SET @Badge = NULL
ELSE IF @Badge IS NOT NULL AND LEN(@Badge) < 6
    SET @Badge = RIGHT('000000'+@Badge,6)

SELECT 
   r.RestroomId
  ,r.RestroomName
  ,r.RestroomType

  ,ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END RestroomAddress
  ,r.ACTRoute 
  
  ,CAST(f.AddDateTime AS DATETIME) FeedBackDate /*Time For Report*/
  ,RTRIM(e.FirstName + ' ' + e.LastName + ' ' + e.Badge) EmployeeNameBadge
  ,f.Badge
  ,f.Rate 
  ,CAST(f.NeedAttention AS TINYINT) NeedAttention
  --,CASE WHEN f.NeedAttention = 1 THEN 'x' ELSE 'a' END NeedAttentionCheckbox --Wingding font emptybox and Xcheckbox
  ,f.FeedbackText
  
    ,CAST( 
    CASE 
	   WHEN r.Address IS NOT NULL AND r.City IS NOT NULL AND r.State IS NOT NULL AND r.City IS NOT NULL  
	   THEN 'http://maps.google.com/maps?q='+ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END
	   ELSE ''
    END AS VARCHAR(255)) GoogleMapsLink
    
    ,CAST( 
    CASE 
	   WHEN r.Address IS NOT NULL AND r.City IS NOT NULL AND r.State IS NOT NULL AND r.City IS NOT NULL  
	   THEN 'javascript:void(window.open('''
		  +'http://maps.google.com/maps?q='+ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END
		  +''',''_blank''))'
	   ELSE ''
    END AS VARCHAR(255)) GoogleMapsLinkNewWindow
	
FROM dbo.Restroom r
JOIN dbo.Feedback f ON r.RestroomId = f.RestroomId 
JOIN EmployeeDW.dbo.EmployeeAll e ON RIGHT('000000'+f.Badge,6) = e.Badge
WHERE 1=1
	 AND CAST(f.AddDateTime AS DATE) BETWEEN @StartDate AND @EndDate
	 AND f.Badge = ISNULL(NULLIF(@Badge,''),f.Badge)
	 AND f.NeedAttention = ISNULL(NULLIF(@NeedsAttention,-1),f.NeedAttention)
	 AND 
	 (
		  ISNULL(NULLIF(@RestroomType,''),'') = ''
		  OR
		  RTRIM(LTRIM(REPLACE(r.RestroomType,',',''))) IN (SELECT STR FROM dbo.CharToTable(@RestroomType,','))

	 )
	 AND 
	 (
		  ISNULL(NULLIF(@RestroomName,''),'') = ''
		  OR
		  RTRIM(LTRIM(REPLACE(r.RestroomName,',',''))) IN (SELECT STR FROM dbo.CharToTable(@RestroomName,','))

	 )
	 AND 
	 (
		  ISNULL(NULLIF(@City,''),'') = ''
		  OR
		  RTRIM(LTRIM(REPLACE(r.City,',',''))) IN (SELECT STR FROM dbo.CharToTable(@City,','))

	 )
	 AND 
	 (
		  ISNULL(NULLIF(@Route,''),'') = ''
		  OR
		  r.RestroomId IN 
				    (
					   SELECT DISTINCT s.RestroomId --,r.ACTRoute ,o.Route
					   FROM dbo.Restroom s
					   CROSS APPLY
					   (
						  SELECT STR Route 
						  FROM dbo.CharToTable(s.ACTRoute,',')
						  WHERE STR IN (SELECT STR FROM dbo.CharToTable(@Route,','))
					   ) o
				    )

	 )
ORDER BY RestroomName 

END;--PROC

GO
/****** Object:  StoredProcedure [dbo].[GetRestroomList]    Script Date: 11/7/2017 3:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetRestroomList]

 @RestroomType NVARCHAR(MAX) = NULL
,@RestroomName NVARCHAR(MAX) = NULL
,@City NVARCHAR(MAX) = NULL
,@Route NVARCHAR(MAX) = NULL

AS
BEGIN


IF @RestroomType = '(All)' SET @RestroomType = NULL
IF @RestroomName = '(All)' SET @RestroomName = NULL
IF @Route = '(All)' SET @Route = NULL
IF @City = '(All)' SET @City = NULL


SELECT 
   r.RestroomId
  ,r.RestroomType
  ,r.RestroomName
  ,CASE WHEN ISNULL(r.RestroomName,'') = '' THEN 1 ELSE 0 END SortOrderBlankNameLast
  ,r.Address
  ,r.City
  ,r.State
  ,r.Zip
  ,r.Country
  ,r.DrinkingWater
  ,r.ACTRoute
  ,r.Hours
  ,r.Note
  
    ,CAST( 
    CASE 
	   WHEN r.Address IS NOT NULL AND r.City IS NOT NULL AND r.State IS NOT NULL AND r.City IS NOT NULL  
	   THEN 'http://maps.google.com/maps?q='+ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END
	   ELSE ''
    END AS VARCHAR(255)) GoogleMapsLink
    
    ,CAST( 
    CASE 
	   WHEN r.Address IS NOT NULL AND r.City IS NOT NULL AND r.State IS NOT NULL AND r.City IS NOT NULL  
	   THEN 'javascript:void(window.open('''
		  +'http://maps.google.com/maps?q='+ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END
		  +''',''_blank''))'
	   ELSE ''
    END AS VARCHAR(255)) GoogleMapsLinkNewWindow
	
FROM dbo.Restroom r
WHERE 1=1
	 AND r.RestroomType = ISNULL(NULLIF(@RestroomType,''),r.RestroomType)
	 AND 
	 (
		  ISNULL(NULLIF(@RestroomName,''),'') = ''
		  OR
		  RTRIM(LTRIM(REPLACE(r.RestroomName,',',''))) IN (SELECT STR FROM dbo.CharToTable(@RestroomName,','))

	 )
	 AND 
	 (
		  ISNULL(NULLIF(@City,''),'') = ''
		  OR
		  RTRIM(LTRIM(REPLACE(r.City,',',''))) IN (SELECT STR FROM dbo.CharToTable(@City,','))

	 )
	 AND 
	 (
		  ISNULL(NULLIF(@Route,''),'') = ''
		  OR
		  r.RestroomId IN (
					   SELECT DISTINCT s.RestroomId --,r.ACTRoute ,o.Route
					   FROM dbo.Restroom s
					   CROSS APPLY
					   (
						  SELECT STR Route 
						  FROM dbo.CharToTable(s.ACTRoute,',')
						  WHERE STR IN (SELECT STR FROM dbo.CharToTable(@Route,','))
					   ) o
				    )

	 )
ORDER BY SortOrderBlankNameLast ,RestroomName 

END;--PROC

GO
/****** Object:  StoredProcedure [dbo].[GetRestroomsNearby]    Script Date: 11/7/2017 3:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRestroomsNearby]
	-- Add the parameters for the stored procedure here
	@routeAlpha	varchar(5),
	@direction	varchar(12),
	@lat		decimal(9,6),
	@long		decimal(9,6),
	@distance	INT=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @RatingCutoffDate DATE = DATEADD(WEEK, -1, GETDATE())

	DECLARE @Origin GEOGRAPHY,@temp	varchar(30)
	--set @temp='POINT (' + cast(@lat as varchar) + ' ' + cast(@long  as varchar) + ')'
	
	
	SET @Origin = geography::Point(@lat, @long, 4326)
	
	--SET @Origin = GEOGRAPHY::STGeomFromText(@temp, 4326);

	SELECT 
		r.*,
		CAST(NULL AS DECIMAL(3, 2)) 'AverageRating'
	INTO 
		#Restroom
	FROM 
		dbo.Restroom r
	WHERE 
		(
			NULLIF(@routeAlpha, '') IS NULL 
			OR (',' + RTRIM(r.ACTRoute) + ',') LIKE '%,' + @routeAlpha + ',%'
			OR (', ' + RTRIM(r.ACTRoute) + ',') LIKE '%, ' + @routeAlpha + ',%'
		)
		AND (@Distance IS NULL OR @Origin.STDistance(geo) <= @Distance)
	
	;WITH AverageRating AS 
	(
		SELECT 
			RestroomId,
			AVG(Rate) 'AverageRating'
		FROM 
			Feedback
		WHERE 
			AddDateTime >= @RatingCutoffDate
			AND Rate != -1
		GROUP BY 		
			RestroomId
	)
	UPDATE 
		#Restroom
	SET 
		AverageRating = ar.AverageRating
	FROM 
		#Restroom rs
		INNER JOIN AverageRating ar 
			ON rs.RestroomId = ar.RestroomId
	
	SELECT 
		RestroomID, 
		RestroomType, 
		RestroomName, 
		Address, 
		City, 
		State, 
		Zip, 
		Country, 
		DrinkingWater, 
		ACTRoute, 
		Hours, 
		Note, 
		LongDec, 
		LatDec, 
		Geo,
		CAST(AverageRating AS DECIMAL(3, 2)) AS AverageRating
	FROM 
		#Restroom

END
GO
/****** Object:  StoredProcedure [dbo].[GetRestroomsNearby_Original_Unmodified]    Script Date: 11/7/2017 3:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
