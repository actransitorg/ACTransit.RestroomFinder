USE [master]
GO

--CREATE DATABASE [RestroomFinder2]
-- CONTAINMENT = NONE
-- ON  PRIMARY 
--( NAME = N'RestroomFinder2', FILENAME = N'D:\Data\RestroomFinder2.mdf' , SIZE = 16384KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
-- LOG ON 
--( NAME = N'RestroomFinder2_log', FILENAME = N'E:\Log\RestroomFinder2_log.ldf' , SIZE = 9096KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
--GO
ALTER DATABASE [RestroomFinder2] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RestroomFinder2[dbo[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [RestroomFinder2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [RestroomFinder2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [RestroomFinder2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [RestroomFinder2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [RestroomFinder2] SET ARITHABORT OFF 
GO
ALTER DATABASE [RestroomFinder2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [RestroomFinder2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [RestroomFinder2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [RestroomFinder2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [RestroomFinder2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [RestroomFinder2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [RestroomFinder2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [RestroomFinder2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [RestroomFinder2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [RestroomFinder2] SET  DISABLE_BROKER 
GO
ALTER DATABASE [RestroomFinder2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [RestroomFinder2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [RestroomFinder2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [RestroomFinder2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [RestroomFinder2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [RestroomFinder2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [RestroomFinder2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [RestroomFinder2] SET RECOVERY FULL 
GO
ALTER DATABASE [RestroomFinder2] SET  MULTI_USER 
GO
ALTER DATABASE [RestroomFinder2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [RestroomFinder2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [RestroomFinder2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [RestroomFinder2] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [RestroomFinder2] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sysp_db_vardecimal_storage_format N'RestroomFinder2', N'ON'
GO
ALTER DATABASE [RestroomFinder2] SET QUERY_STORE = OFF
GO
USE [RestroomFinder2]
GO
/****** Object:  User [linkSrvrReader]    Script Date: 3/9/2022 8:54:44 AM ******/
--CREATE USER [linkSrvrReader] FOR LOGIN [linkSrvrReader] WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  User [ACTRANSIT\WT89463$]    Script Date: 3/9/2022 8:54:44 AM ******/
--CREATE USER [ACTRANSIT\WT89463$] FOR LOGIN [ACTRANSIT\WT89463$] WITH DEFAULT_SCHEMA=[dbo]
--GO
/****** Object:  User [ACTRANSIT\WEBTEST06B$]    Script Date: 3/9/2022 8:54:44 AM ******/
--CREATE USER [ACTRANSIT\WEBTEST06B$] FOR LOGIN [ACTRANSIT\WEBTEST06B$] WITH DEFAULT_SCHEMA=[dbo]
--GO
/****** Object:  User [ACTRANSIT\WEBTEST06A$]    Script Date: 3/9/2022 8:54:44 AM ******/
--CREATE USER [ACTRANSIT\WEBTEST06A$] FOR LOGIN [ACTRANSIT\WEBTEST06A$] WITH DEFAULT_SCHEMA=[dbo]
--GO
/****** Object:  User [ACTRANSIT\WEB06B$]    Script Date: 3/9/2022 8:54:44 AM ******/
--CREATE USER [ACTRANSIT\WEB06B$] FOR LOGIN [ACTRANSIT\WEB06B$] WITH DEFAULT_SCHEMA=[dbo]
--GO
/****** Object:  User [ACTRANSIT\WEB06A$]    Script Date: 3/9/2022 8:54:44 AM ******/
--CREATE USER [ACTRANSIT\WEB06A$] FOR LOGIN [ACTRANSIT\WEB06A$] WITH DEFAULT_SCHEMA=[dbo]
--GO
/****** Object:  User [ACTRANSIT\ISReader]    Script Date: 3/9/2022 8:54:44 AM ******/
--CREATE USER [ACTRANSIT\ISReader] FOR LOGIN [ACTRANSIT\ISReader] WITH DEFAULT_SCHEMA=[dbo]
--GO
-- ALTER ROLE [db_datareader] ADD MEMBER [linkSrvrReader]
-- GO
-- ALTER ROLE [db_datareader] ADD MEMBER [ACTRANSIT\WT89463$]
-- GO
-- ALTER ROLE [db_datawriter] ADD MEMBER [ACTRANSIT\WT89463$]
-- GO
-- ALTER ROLE [db_owner] ADD MEMBER [ACTRANSIT\WEBTEST06B$]
-- GO
-- ALTER ROLE [db_owner] ADD MEMBER [ACTRANSIT\WEBTEST06A$]
-- GO
-- ALTER ROLE [db_datareader] ADD MEMBER [ACTRANSIT\WEB06B$]
-- GO
-- ALTER ROLE [db_datawriter] ADD MEMBER [ACTRANSIT\WEB06B$]
-- GO
-- ALTER ROLE [db_datareader] ADD MEMBER [ACTRANSIT\WEB06A$]
-- GO
-- ALTER ROLE [db_datawriter] ADD MEMBER [ACTRANSIT\WEB06A$]
-- GO
-- ALTER ROLE [db_datareader] ADD MEMBER [ACTRANSIT\ISReader]
-- GO






/****** Object:  UserDefinedFunction [dbo[CharToTable]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo[CharToTable] 
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
  -- SELECT * FROM [dbo[CharToTable]('Abc,A,V,G,KJHLJJKHGGF,J,L,O,O,I,U,Y,G3,V2,R1',',')
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
/****** Object:  Table [dbo[Contact]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[Contact](
	[ContactId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceProvider] [varchar](100) NOT NULL,
	[ContactName] [varchar](100) NOT NULL,
	[Title] [varchar](100) NULL,
	[Phone] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Address] [varchar](100) NULL,
	[Deleted] [bit] NOT NULL,
	[Notes] [varchar](max) NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo[Restroom_History]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[Restroom_History](
	[RestroomId] [int] NOT NULL,
	[EquipmentNum] [char](12) NULL,
	[RestroomType] [varchar](16) NULL,
	[RestroomName] [varchar](100) NULL,
	[Address] [varchar](255) NULL,
	[City] [varchar](14) NULL,
	[State] [varchar](2) NULL,
	[Zip] [int] NULL,
	[Country] [varchar](3) NULL,
	[DrinkingWater] [varchar](3) NULL,
	[ACTRoute] [varchar](2000) NULL,
	[WeekdayHours] [varchar](130) NULL,
	[SaturdayHours] [varchar](130) NULL,
	[SundayHours] [varchar](130) NULL,
	[Note] [varchar](500) NULL,
	[NearestIntersection] [varchar](500) NULL,
	[LongDec] [decimal](9, 6) NULL,
	[LatDec] [decimal](9, 6) NULL,
	[Geo] [geography] NULL,
	[NotificationEmail] [varchar](255) NULL,
	[ContactId] [int] NULL,
	[CleanedContactId] [int] NULL,
	[RepairedContactId] [int] NULL,
	[SuppliedContactId] [int] NULL,
	[SecurityGatesContactId] [int] NULL,
	[SecurityLocksContactId] [int] NULL,
	[IsToiletAvailable] [bit] NOT NULL,
	[AverageRating] [decimal](3, 2) NULL,
	[Deleted] [bit] NOT NULL,
	[StatusListId] [int] NULL,
	[UnavailableFrom] [datetime] NULL,
	[UnavailableTo] [datetime] NULL,
	[Division] [varchar](25) NULL,
	[IsPublic] [bit] NOT NULL,
	[IsHistory] [bit] NULL,
	[Comment] [varchar](max) NULL,
	[AddressChanged] [bit] NULL,
	[ToiletGenderId] [int] NULL,
	[LabelId] [varchar](20) NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
	[SysStartTime] [datetime2](7) NOT NULL,
	[SysEndTime] [datetime2](7) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [ix_Restroom_History]    Script Date: 3/9/2022 8:54:44 AM ******/
CREATE CLUSTERED INDEX [ix_Restroom_History] ON [dbo[Restroom_History]
(
	[SysEndTime] ASC,
	[SysStartTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo[Restroom]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[Restroom](
	[RestroomId] [int] IDENTITY(1,1) NOT NULL,
	[EquipmentNum] [char](12) NULL,
	[RestroomType] [varchar](16) NULL,
	[RestroomName] [varchar](100) NULL,
	[Address] [varchar](255) NULL,
	[City] [varchar](14) NULL,
	[State] [varchar](2) NULL,
	[Zip] [int] NULL,
	[Country] [varchar](3) NULL,
	[DrinkingWater] [varchar](3) NULL,
	[ACTRoute] [varchar](2000) NULL,
	[WeekdayHours] [varchar](130) NULL,
	[SaturdayHours] [varchar](130) NULL,
	[SundayHours] [varchar](130) NULL,
	[Note] [varchar](500) NULL,
	[NearestIntersection] [varchar](500) NULL,
	[LongDec] [decimal](9, 6) NULL,
	[LatDec] [decimal](9, 6) NULL,
	[Geo] [geography] NULL,
	[NotificationEmail] [varchar](255) NULL,
	[ContactId] [int] NULL,
	[CleanedContactId] [int] NULL,
	[RepairedContactId] [int] NULL,
	[SuppliedContactId] [int] NULL,
	[SecurityGatesContactId] [int] NULL,
	[SecurityLocksContactId] [int] NULL,
	[IsToiletAvailable] [bit] NOT NULL,
	[AverageRating] [decimal](3, 2) NULL,
	[Deleted] [bit] NOT NULL,
	[StatusListId] [int] NULL,
	[UnavailableFrom] [datetime] NULL,
	[UnavailableTo] [datetime] NULL,
	[Division] [varchar](25) NULL,
	[IsPublic] [bit] NOT NULL,
	[IsHistory] [bit] NULL,
	[Comment] [varchar](max) NULL,
	[AddressChanged] [bit] NULL,
	[ToiletGenderId] [int] NULL,
	[LabelId] [varchar](20) NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [PK_BTime] PRIMARY KEY CLUSTERED 
(
	[RestroomId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo[Restroom_History] )
)
GO
/****** Object:  View [dbo[RestroomContact]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo[RestroomContact] AS 

	SELECT DISTINCT C.ContactId, C.ServiceProvider, C.ContactName, C.Title, C.Phone, C.Email, C.[Address], C.Notes,
	CASE
    WHEN R.RestroomId IS NOt NULL THEN CAST(1 AS BIT)
	ELSE CAST(0 AS BIT) END HasRestroom
	FROM Contact C 
	LEFT JOIN Restroom R
	ON R.ContactId = C.ContactId
	WHERE C.Deleted != 1
GO
/****** Object:  Table [dbo[UserDevice]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[UserDevice](
	[UserDeviceId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[DeviceId] [bigint] NOT NULL,
	[Active] [bit] NOT NULL,
	[LastLogon] [datetime] NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_UserDevice] PRIMARY KEY CLUSTERED 
(
	[UserDeviceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo[Device]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[Device](
	[DeviceId] [bigint] IDENTITY(1,1) NOT NULL,
	[DeviceGuid] [varchar](100) NOT NULL,
	[DeviceModel] [varchar](100) NOT NULL,
	[DeviceOS] [varchar](50) NOT NULL,
	[PhoneNumber] [varchar](20) NULL,
	[Confirm2FACode] [varchar](20) NULL,
	[Confirm2FAExpires] [datetime] NULL,
	[Confirmed2FACode] [bit] NULL,
	[LastUsed] [datetime] NULL,
	[DeviceSessionId] [varchar](4000) NULL,
	[Description] [varchar](255) NULL,
	[Active] [bit] NOT NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_DEvice] PRIMARY KEY CLUSTERED 
(
	[DeviceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo[User]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Badge] [varchar](6) NOT NULL,
	[SecurityCardFormatted] [varchar](10) NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](30) NULL,
	[PreferredPhone] [varchar](24) NULL,
	[JobTitle] [varchar](30) NULL,
	[IsDemo] [bit] NULL,
	[Active] [bit] NOT NULL,
	[Description] [varchar](255) NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo[V_UserDevice]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE View [dbo[V_UserDevice] AS 

	SELECT  u.UserId,
			u.Badge, 
			u.FirstName,
			u.LastName,
			u.MiddleName,
			CONCAT_WS(' ', u.FirstName, u.LastName) AS [Name],
			u.PreferredPhone,
			u.JobTitle,
			u.Active AS UserActive,
			u.[Description] AS UserDescription,
			ud.LastLogon,
			ud.Active AS UserDeviceActive,
			d.DeviceId, 
			d.DeviceGuid, 
			d.DeviceModel, 
			d.DeviceOS, 
			d.DeviceSessionId, 
			d.LastUsed, 
			d.[Description] AS DeviceDescription, 
			d.Active AS DeviceActive
	FROM [User] u
		LEFT JOIN UserDevice ud on u.UserId = ud.UserId
		LEFT JOIN Device d on d.DeviceId = ud.DeviceId
GO
/****** Object:  View [dbo[V_User]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE View [dbo[V_User] AS

	SELECT
		vu.UserId, 
		vu.Badge,
		vu.[Name], 
		vu.FirstName, 
		vu.LastName, 
		vu.MiddleName,
		vu.PreferredPhone,
		vu.JobTitle,
		vu.UserActive, 
		vu.UserDescription, 
		vu.LastLogon, 
		vu.UserDeviceActive, 
		vu.DeviceId, 
		vu.DeviceGuid,
		vu.DeviceModel, 
		vu.DeviceOS, 
		vu.DeviceDescription, 
		vu.DeviceActive,
		x.NumberOfActiveDevices
	FROM V_UserDevice vu
	INNER JOIN(
		SELECT 
			Badge,
			MAX(LastLogon) LastLogon, 
			COUNT(DeviceGuid) NumberOfActiveDevices
		FROM V_UserDevice
		WHERE DeviceActive = 1
		GROUP BY Badge
	) x ON x.Badge = vu.Badge 
		AND x.LastLogon=vu.LastLogon
GO
/****** Object:  View [dbo[ApprovedRestroom]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE   VIEW [dbo[ApprovedRestroom] AS 

-- Latest approved version of each restroom
WITH NewRestroom
AS
(
	-- New restrooms in pending status
	SELECT R.RestroomId, R.SysEndTime
	FROM Restroom R 
		LEFT JOIN Restroom_History RH ON R.RestroomId = RH.RestroomId
	WHERE R.StatusListId = 1 -- Pending
		AND R.Deleted = 0 -- Not deleted
		AND (RH.RestroomId IS NULL 
				OR NOT EXISTS(SELECT RestroomID 
							  FROM Restroom_History 
							  WHERE RestroomId = RH.RestroomId 
								AND R.StatusListId = 2))
		AND R.SysEndTime = CONVERT(DATETIME2(7), '9999-12-31T23:59:59.9999999')
),

-- Latest approved version of each restroom
EditedRestroom
AS
(	
	SELECT * 
	FROM NewRestroom

	UNION

	SELECT R.RestroomId, MAX(R.SysEndTime) AS SysEndTime
	FROM restroom FOR SYSTEM_TIME All R
		LEFT JOIN NewRestroom NR ON R.RestroomId = NR.RestroomId
	WHERE R.StatusListId IN (2, 3) -- Approved/InActive
		AND R.Deleted = 0 -- Not deleted
		AND NR.RestroomId IS NULL
	GROUP By R.RestroomId
)

SELECT RH.*, 
COALESCE (EA.[Name], RH.AddUserId) AS AddUserName,
COALESCE (EU.[Name], RH.UpdUserId) AS UpdUserName,
	   '''' + REPLACE(RH.ACTRoute,  ',', ''',''') + '''' AS SearchRoutes
			--CAST(CASE 
			--		WHEN (RH.SysEndTime = CONVERT(DATETIME2(7), '9999-12-31T23:59:59.9999999') AND RH.StatusListId = 1) THEN 1 -- New restooms in pending status (created from APP)
			--		WHEN (RH.SysEndTime <> CONVERT(DATETIME2(7), '9999-12-31T23:59:59.9999999') AND RH.StatusListId = 2) THEN 1 -- Modified restrooms pending review (modified from APP)
			--		ELSE 0
			-- END AS BIT) AS PendingReview
FROM Restroom FOR SYSTEM_TIME All RH
	INNER JOIN 
		EditedRestroom AS SR ON RH.RestroomId = SR.RestroomId
			AND RH.SysEndTime = SR.SysEndTime
	INNER JOIN 
				(SELECT RestroomId
				 FROM Restroom
				 WHERE Deleted = 0) AS NDR ON SR.RestroomId = NDR.RestroomId -- If current version of the restroom is deleted then ignore from results (restrooms cannot be deleted from APP)
	LEFT JOIN 
		EmployeeDW.dbo.Employees AS EA ON RH.AddUserId like '%' + EA.NTLogin    
	LEFT JOIN 
		EmployeeDW.dbo.Employees AS EU ON RH.UpdUserId like '%' + EU.NTLogin
GO
/****** Object:  View [dbo[ReviewRestroom]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--THIS VIEW WILL SHOW LATEST APPROVED VERSION OF ANY RESTROOM ALONG WITH ANY OF ITS PENDING CHANGES
CREATE     VIEW [dbo[ReviewRestroom] AS 

WITH ShowRestroom
AS
-- Latest approved version of each restroom
(SELECT RestroomId, MAX(SysEndTime) AS SysEndTime
		FROM restroom FOR SYSTEM_TIME All
		WHERE StatusListId IN (2, 3) -- Approved/InActive
			AND Deleted = 0 -- Not deleted
		GROUP By RestroomId 

UNION

-- New restrooms in pending status
SELECT DISTINCT R.RestroomId, R.SysEndTime
FROM Restroom R 
	LEFT JOIN Restroom_History RH ON R.RestroomId = RH.RestroomId
WHERE R.StatusListId = 1 -- Pending
	AND R.Deleted = 0 -- Not deleted
	--AND RH.RestroomId IS NULL
	AND R.SysEndTime = CONVERT(DATETIME2(7), '9999-12-31T23:59:59.9999999') 
)

SELECT NEWID() AS ReviewRestroomId, T.*
FROM
(SELECT DISTINCT RH.RestroomId,
		RH.EquipmentNum,
		RH.RestroomType,
		RH.RestroomName,
		RH.[Address],
		RH.City,
		RH.[State],
		RH.Zip,
		RH.Country,
		RH.DrinkingWater,
		RH.ACTRoute,
		RH.WeekdayHours,
		RH.SaturdayHours,
		RH.SundayHours,
		RH.Note,
		RH.NearestIntersection,
		RH.LongDec,
		RH.LatDec,
		NULL AS Geo, --LEFT FOR COMPATIBILITY PURPOSES WITH ASP.NET BUT CAN BE REMOVED
		RH.NotificationEmail,
		RH.ContactId,
		RH.CleanedContactId,
		RH.RepairedContactId,
		RH.SuppliedContactId,
		RH.SecurityGatesContactId,
		RH.SecurityLocksContactId,
		RH.IsToiletAvailable,
		RH.AverageRating,
		RH.Deleted,
		RH.StatusListId,
		RH.UnavailableFrom,
		RH.UnavailableTo,
		RH.Division,
		RH.IsPublic,
		RH.IsHistory,
		RH.Comment,
		RH.AddressChanged,
		RH.ToiletGenderId,
		RH.LabelId,
		RH.AddUserId,
		RH.AddDateTime,
		RH.UpdUserId,
		RH.UpdDateTime,
		RH.SysStartTime,
		RH.SysEndTime,
		COALESCE (EA.[Name], RH.AddUserId) AS AddUserName,
		COALESCE (EU.[Name], RH.UpdUserId) AS UpdUserName
FROM Restroom FOR SYSTEM_TIME All RH
	INNER JOIN 
		ShowRestroom AS SR ON RH.RestroomId = SR.RestroomId
			AND RH.SysEndTime >= SR.SysEndTime
	LEFT JOIN 
		EmployeeDW.dbo.Employees AS EA ON RH.AddUserId like '%' + EA.NTLogin    
	LEFT JOIN 
		EmployeeDW.dbo.Employees AS EU ON RH.UpdUserId like '%' + EU.NTLogin 
WHERE Deleted = 0 -- Not deleted
) T
GO
/****** Object:  UserDefinedFunction [dbo[CreateAlphanumericSortValue]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo[CreateAlphanumericSortValue]
(
	@ItemToSort varchar(200),
	@SortNumericsFirst bit = 1
)
RETURNS varchar(801)
WITH SCHEMABINDING
AS
	--==========================================================================================
	-- This function takes an alphanumeric string and encodes it so that it can be properly sorted
	--    against other alphanumeric strings
	-- The encoding will insert a three digit string before each numeric portion of the item to sort
	--    The three digits represent the number of digits in the numeric portion that it will precede (zero-padded)
	-- The encoding will also account for leading zeros in each numeric portion by adding a three digit
	--    string at the end of the item to sort, for each numeric portio  Those three digits will
	--    represent the number of leading zeros in the numeric portion (zero-padded)
	-- Examples:
	-- ABC =	  ABC
	-- ABC1 =     ABC0011 000
	-- ABC1ABC1 = ABC0011ABC0011 000000
	-- ABC12    = ABC00212 000
	-- ABC012   = ABC00212 001
	--
	-- Worst case notes:
	--	The max count of leading zeros is -- all zeros = 200
	--  The max count of numbers -- all numbers = 200
	--  A single space separates the leading zero string from the rest
	--	Leading zeros get trimmed
	--  Each number portion gets 3 new characters in front (and 3 new characters at the end)
	--			1 leading zero nets 2 characters
	--			2 leading zeros net 1 character
	--			3 leading zeros net 0 characters
	--			>3 lose characters
	--  All characters just spits out the same string
	--  So, no leading zeros, but with numbers, adds the most characters
	--	So, the most number-sets = the most characters -- which is every other is a number
	--			= 100 numbers & 100 alphas
	--			= 100 * 3 characters each in front + 100 * 3 characters each at then + 1 space
	--			= 801 characters
	-- FY This function is specifically being used for ... (some domain specific stuff)... sorting at this time.
	--    As such, everything has been set up for that length, which is 200 characters
	--    A change in that length could require numerous changes to to code below -- be carefu
	--		(If you can have > 999 numbers/zeros to count)
	--==========================================================================================
BEGIN
	declare @WorkingItem varchar(200) = @ItemToSort
	declare @DigitCount int = 0
	declare @LeadingZeroCount int = 0
	declare @CurrentNumber varchar(200) = ''
	declare @Leftmost varchar(1) = ''
	declare @LeadingZeroString varchar(300) = ''

	--==========================================================================================
	-- With 200 character input, the worst case output should be 801 characters
	--==========================================================================================
	declare @SortValue varchar(801) = ''	

	--==========================================================================================
	-- We will work thru the input string one character at a time
	--==========================================================================================
	declare @FirstIsCharacter bit = 0
	if (isnumeric(left(@WorkingItem, 1)) = 0)
		select @FirstIsCharacter = 1

	while (len(@WorkingItem) > 0)
	begin
		select @Leftmost = left(@WorkingItem, 1)

		--==========================================================================================
		-- Is the first character a number?
		--==========================================================================================
		if (isnumeric(@Leftmost) = 1 and @Leftmost != '-')
		begin
			while (isnumeric(@Leftmost) = 1 and @Leftmost != '-')
			begin
				--==========================================================================================
				-- Parse out all of the consecutive digits to get the current number
				--==========================================================================================
				if (@Leftmost = '0' and @DigitCount = 0)
				begin
					--==========================================================================================
					-- Leading zero -- just count how many we have in this set of digits
					--    We'll add the string for it to the end of our output below
					--==========================================================================================
					select @LeadingZeroCount = @LeadingZeroCount + 1
				end
				else
				begin
					--==========================================================================================
					-- Not a leading zero, so increment the digit count, and remember the current number value
					--==========================================================================================
					select @DigitCount = @DigitCount + 1
					select @CurrentNumber = @CurrentNumber + @Leftmost
				end

				--==========================================================================================
				-- Trim off the character we just checked, get the next character to check and continue the inner loop
				--==========================================================================================
				select @WorkingItem = substring(@WorkingItem, 2, 200)
				select @Leftmost = left(@WorkingItem, 1)
			end -- while (isnumeric(@Leftmost) = 1)

			--==========================================================================================
			-- We now have the current number from our input string
			--    Add the current number's leading zero string to the entire leading zero string, zero-padded
			--==========================================================================================
			if (@LeadingZeroCount < 10)
				select @LeadingZeroString = @LeadingZeroString + '00' + cast(@LeadingZeroCount as varchar)
			else if (@LeadingZeroCount < 100)
				select @LeadingZeroString = @LeadingZeroString + '0' + cast(@LeadingZeroCount as varchar)
			else
				select @LeadingZeroString = @LeadingZeroString + cast(@LeadingZeroCount as varchar)

			--==========================================================================================
			-- Add the current number's sort code, along with the current number, to the returned sort value
			--==========================================================================================
			if (@DigitCount < 10)
				select @SortValue = @SortValue + '00' + cast(@DigitCount as varchar) + @CurrentNumber
			else if (@DigitCount < 100)
				select @SortValue = @SortValue + '0' + cast(@DigitCount as varchar) + @CurrentNumber
			else
				select @SortValue = @SortValue + cast(@DigitCount as varchar) + @CurrentNumber

			--==========================================================================================
			-- Reset for the next iteration
			--==========================================================================================
			select @DigitCount = 0
			select @CurrentNumber = ''
			select @LeadingZeroCount = 0
		end -- if (isnumeric(@Leftmost) = 1)

		--==========================================================================================
		-- The character we are currently working with is not a number, just tag it onto our return value
		--    Ignoring whitespace
		--==========================================================================================
		if (@Leftmost != ' ')
			select @SortValue = @SortValue + @Leftmost

		--==========================================================================================
		-- Trim off the character we just checked and continue the main loop
		--==========================================================================================
		select @WorkingItem = substring(@WorkingItem, 2, 200)

	end -- while (len(@WorkingItem) > 0)

	if (@SortNumericsFirst = 0 and @FirstIsCharacter = 1)
		select @SortValue = '-999999999' + @SortValue

	--==========================================================================================
	-- Finally, tag on the leading zero value and return our sort value
	--==========================================================================================
	select @SortValue = @SortValue +  ' ' + @LeadingZeroString

	return @SortValue
END
GO
/****** Object:  Table [dbo[Confirmation]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[Confirmation](
	[ConfirmationId] [bigint] IDENTITY(1,1) NOT NULL,
	[Badge] [varchar](6) NOT NULL,
	[Agreed] [bit] NOT NULL,
	[IncidentDateTime] [datetime2](7) NOT NULL,
	[DeviceId] [varchar](100) NULL,
	[SessionId] [varchar](2000) NULL,
	[Active] [bit] NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_Confirmation] PRIMARY KEY CLUSTERED 
(
	[ConfirmationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo[CostTermList]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[CostTermList](
	[CostTermListId] [int] NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_CostTermList] PRIMARY KEY CLUSTERED 
(
	[CostTermListId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo[Feedback]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[Feedback](
	[FeedbackId] [bigint] IDENTITY(1,1) NOT NULL,
	[RestroomId] [int] NOT NULL,
	[Badge] [varchar](6) NOT NULL,
	[NeedAttention] [bit] NOT NULL,
	[NeedRepair] [bit] NULL,
	[NeedSupply] [bit] NULL,
	[NeedCleaning] [bit] NULL,
	[Closed] [bit] NULL,
	[FeedbackText] [varchar](255) NULL,
	[Rating] [decimal](3, 2) NULL,
	[Issue] [varchar](255) NULL,
	[Resolution] [varchar](2000) NULL,
	[ReportedAction] [varchar](2000) NULL,
	[WorkRequestDescription] [varchar](255) NULL,
	[WorkRequestId] [varchar](50) NULL,
	[InspectionPassed] [bit] NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_Feedback] PRIMARY KEY CLUSTERED 
(
	[FeedbackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo[Log]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[Log](
	[LogId] [bigint] IDENTITY(1,1) NOT NULL,
	[DeviceId] [varchar](100) NULL,
	[DeviceModel] [varchar](100) NULL,
	[DeviceOS] [varchar](50) NULL,
	[Description] [varchar](255) NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo[RestroomStatusList]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[RestroomStatusList](
	[RestroomStatusListId] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[Title] [varchar](50) NULL,
	[Description] [varchar](255) NULL,
	[IsDefault] [bit] NOT NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_RestroomStatusList] PRIMARY KEY CLUSTERED 
(
	[RestroomStatusListId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo[RestroomType]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[RestroomType](
	[RestroomTypeId] [int] NOT NULL,
	[RestroomType] [varchar](50) NOT NULL,
	[Description] [varchar](200) NULL,
	[IsDefault] [bit] NOT NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_RestroomType] PRIMARY KEY CLUSTERED 
(
	[RestroomTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo[Setting]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[Setting](
	[SettingId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[Active] [bit] NOT NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED 
(
	[SettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo[ToiletGender]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[ToiletGender](
	[ToiletGenderId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Title] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ToiletGender] PRIMARY KEY CLUSTERED 
(
	[ToiletGenderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo[zzzRestroomContact]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[zzzRestroomContact](
	[RestroomId] [int] NOT NULL,
	[ContactId] [int] NOT NULL,
	[Cost] [money] NOT NULL,
	[CostTermListId] [int] NULL,
	[LastPaid] [datetime] NULL,
 CONSTRAINT [PK_RestroomContact] PRIMARY KEY CLUSTERED 
(
	[RestroomId] ASC,
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo[Employees]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo[Employees] AS 
SELECT * FROM  EmployeeDW.dbo.Employees

GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Device_DeviceGuid]    Script Date: 3/9/2022 8:54:44 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Device_DeviceGuid] ON [dbo[Device]
(
	[DeviceGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_User_Badge]    Script Date: 3/9/2022 8:54:44 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_User_Badge] ON [dbo[User]
(
	[Badge] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_UserDevice_UserID_DeviceID]    Script Date: 3/9/2022 8:54:44 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserDevice_UserID_DeviceID] ON [dbo[UserDevice]
(
	[UserId] ASC,
	[DeviceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo[Confirmation] ADD  CONSTRAINT [DF_Confirmation_AddUserId]  DEFAULT (suser_name()) FOR [AddUserId]
GO
ALTER TABLE [dbo[Confirmation] ADD  CONSTRAINT [DF_Confirmation_AddDateTime1]  DEFAULT (sysdatetime()) FOR [AddDateTime]
GO
ALTER TABLE [dbo[Confirmation] ADD  CONSTRAINT [DF_Confirmation_UpdUserId]  DEFAULT (suser_name()) FOR [UpdUserId]
GO
ALTER TABLE [dbo[Confirmation] ADD  CONSTRAINT [DF_Confirmation_UpdDateTime]  DEFAULT (sysdatetime()) FOR [UpdDateTime]
GO
ALTER TABLE [dbo[Contact] ADD  CONSTRAINT [DF_Contact_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo[Contact] ADD  CONSTRAINT [DF_Contact_AddUserId]  DEFAULT (suser_name()) FOR [AddUserId]
GO
ALTER TABLE [dbo[Contact] ADD  CONSTRAINT [DF_Contact_AddDateTime]  DEFAULT (sysdatetime()) FOR [AddDateTime]
GO
ALTER TABLE [dbo[Contact] ADD  CONSTRAINT [DF_Contact_UpdUserId]  DEFAULT (suser_name()) FOR [UpdUserId]
GO
ALTER TABLE [dbo[Contact] ADD  CONSTRAINT [DF_Contact_UpdDateTime]  DEFAULT (sysdatetime()) FOR [UpdDateTime]
GO
ALTER TABLE [dbo[Feedback] ADD  CONSTRAINT [DF_Feedback_AddUserId]  DEFAULT (suser_name()) FOR [AddUserId]
GO
ALTER TABLE [dbo[Feedback] ADD  CONSTRAINT [DF_Feedback_UpdUserId]  DEFAULT (suser_name()) FOR [UpdUserId]
GO
ALTER TABLE [dbo[Restroom] ADD  CONSTRAINT [DF_Restroom_IsToiletAvailable]  DEFAULT ((1)) FOR [IsToiletAvailable]
GO
ALTER TABLE [dbo[Restroom] ADD  CONSTRAINT [DF_Restroom_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo[Restroom] ADD  CONSTRAINT [DF_Restroom_StatusListId]  DEFAULT ((2)) FOR [StatusListId]
GO
ALTER TABLE [dbo[Restroom] ADD  CONSTRAINT [DF_Restroom_AddUserId]  DEFAULT (suser_name()) FOR [AddUserId]
GO
ALTER TABLE [dbo[Restroom] ADD  CONSTRAINT [DF_Restroom_AddDateTime]  DEFAULT (sysdatetime()) FOR [AddDateTime]
GO
ALTER TABLE [dbo[Restroom] ADD  CONSTRAINT [DF__Restroom__SysSta__30C33EC3]  DEFAULT (getutcdate()) FOR [SysStartTime]
GO
ALTER TABLE [dbo[Restroom] ADD  CONSTRAINT [DF__Restroom__SysEnd__31B762FC]  DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) FOR [SysEndTime]
GO
ALTER TABLE [dbo[Restroom_History] ADD  CONSTRAINT [DF_Restroom_History_IsToiletAvailable]  DEFAULT ((1)) FOR [IsToiletAvailable]
GO
ALTER TABLE [dbo[RestroomStatusList] ADD  CONSTRAINT [DF_RestroomStatusList_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [dbo[RestroomType] ADD  CONSTRAINT [DF_RestroomType_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [dbo[Setting] ADD  CONSTRAINT [DF_Setting_Value]  DEFAULT ('') FOR [Value]
GO
ALTER TABLE [dbo[Setting] ADD  CONSTRAINT [DF_Setting_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo[Setting] ADD  CONSTRAINT [DF_Setting_AddUserId]  DEFAULT (suser_name()) FOR [AddUserId]
GO
ALTER TABLE [dbo[Setting] ADD  CONSTRAINT [DF_Setting_AddDateTime]  DEFAULT (sysdatetime()) FOR [AddDateTime]
GO
ALTER TABLE [dbo[User] ADD  CONSTRAINT [DF_User_Active]  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo[User] ADD  CONSTRAINT [DF_User_AddUserId]  DEFAULT (suser_name()) FOR [AddUserId]
GO
ALTER TABLE [dbo[User] ADD  CONSTRAINT [DF_User_AddDateTime]  DEFAULT (sysdatetime()) FOR [AddDateTime]
GO
ALTER TABLE [dbo[User] ADD  CONSTRAINT [DF_User_UpdUserId]  DEFAULT (suser_name()) FOR [UpdUserId]
GO
ALTER TABLE [dbo[User] ADD  CONSTRAINT [DF_User_UpdDateTime]  DEFAULT (sysdatetime()) FOR [UpdDateTime]
GO
ALTER TABLE [dbo[UserDevice] ADD  CONSTRAINT [DF_UserDevice_AddUserId]  DEFAULT (suser_name()) FOR [AddUserId]
GO
ALTER TABLE [dbo[UserDevice] ADD  CONSTRAINT [DF_UserDevice_AddDateTime]  DEFAULT (sysdatetime()) FOR [AddDateTime]
GO
ALTER TABLE [dbo[UserDevice] ADD  CONSTRAINT [DF_UserDevice_UpdUserId]  DEFAULT (suser_name()) FOR [UpdUserId]
GO
ALTER TABLE [dbo[UserDevice] ADD  CONSTRAINT [DF_UserDevice_UpdDateTime]  DEFAULT (sysdatetime()) FOR [UpdDateTime]
GO
ALTER TABLE [dbo[Feedback]  WITH NOCHECK ADD  CONSTRAINT [FK_Feedback_Restroom] FOREIGN KEY([RestroomId])
REFERENCES [dbo[Restroom] ([RestroomId])
GO
ALTER TABLE [dbo[Feedback] CHECK CONSTRAINT [FK_Feedback_Restroom]
GO
ALTER TABLE [dbo[Restroom]  WITH NOCHECK ADD  CONSTRAINT [FK_Restroom_CleanedContact] FOREIGN KEY([CleanedContactId])
REFERENCES [dbo[Contact] ([ContactId])
GO
ALTER TABLE [dbo[Restroom] CHECK CONSTRAINT [FK_Restroom_CleanedContact]
GO
ALTER TABLE [dbo[Restroom]  WITH NOCHECK ADD  CONSTRAINT [FK_Restroom_Contact] FOREIGN KEY([ContactId])
REFERENCES [dbo[Contact] ([ContactId])
GO
ALTER TABLE [dbo[Restroom] CHECK CONSTRAINT [FK_Restroom_Contact]
GO
ALTER TABLE [dbo[Restroom]  WITH NOCHECK ADD  CONSTRAINT [FK_Restroom_RepairedContact] FOREIGN KEY([RepairedContactId])
REFERENCES [dbo[Contact] ([ContactId])
GO
ALTER TABLE [dbo[Restroom] CHECK CONSTRAINT [FK_Restroom_RepairedContact]
GO
ALTER TABLE [dbo[Restroom]  WITH NOCHECK ADD  CONSTRAINT [FK_Restroom_RestroomStatusList] FOREIGN KEY([StatusListId])
REFERENCES [dbo[RestroomStatusList] ([RestroomStatusListId])
GO
ALTER TABLE [dbo[Restroom] CHECK CONSTRAINT [FK_Restroom_RestroomStatusList]
GO
ALTER TABLE [dbo[Restroom]  WITH NOCHECK ADD  CONSTRAINT [FK_Restroom_SecurityGatesContact] FOREIGN KEY([SecurityGatesContactId])
REFERENCES [dbo[Contact] ([ContactId])
GO
ALTER TABLE [dbo[Restroom] CHECK CONSTRAINT [FK_Restroom_SecurityGatesContact]
GO
ALTER TABLE [dbo[Restroom]  WITH NOCHECK ADD  CONSTRAINT [FK_Restroom_SecurityLocksContact] FOREIGN KEY([SecurityLocksContactId])
REFERENCES [dbo[Contact] ([ContactId])
GO
ALTER TABLE [dbo[Restroom] CHECK CONSTRAINT [FK_Restroom_SecurityLocksContact]
GO
ALTER TABLE [dbo[Restroom]  WITH NOCHECK ADD  CONSTRAINT [FK_Restroom_SuppliedContact] FOREIGN KEY([SuppliedContactId])
REFERENCES [dbo[Contact] ([ContactId])
GO
ALTER TABLE [dbo[Restroom] CHECK CONSTRAINT [FK_Restroom_SuppliedContact]
GO
ALTER TABLE [dbo[UserDevice]  WITH CHECK ADD  CONSTRAINT [FK_UserDevice_Device] FOREIGN KEY([DeviceId])
REFERENCES [dbo[Device] ([DeviceId])
GO
ALTER TABLE [dbo[UserDevice] CHECK CONSTRAINT [FK_UserDevice_Device]
GO
/****** Object:  StoredProcedure [dbo[GetRestroom]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo[GetRestroom]
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
			AVG(f.Rating) 'AverageRating'
		FROM 
			dbo.Feedback f
		WHERE 
			f.RestroomId = @RestroomId
			AND f.AddDateTime >= @AverateRatingCutoffDate
		GROUP BY 
			f.RestroomId
	)
	--SELECT 
		--rRestroomId,
		--rRestroomType,
		--rRestroomName,
		--rEquipmentNum,
		--rAddress,
		--rCity,
		--rState,
		--rZip,
		--rCountry,
		--rDrinkingWater,
		--rACTRoute,
		--rWeekdayHours,
		--rSaturdayHours,
		--rSundayHours,
		--rNearestIntersection,
		--rNote,
		--rLongDec,
		--rLatDec,
		--rGeo,
		--rIsDistrictOwned,
		--rIsDistrictCleaned,
		--rIsDistrictRepaired,
		--rIsDistrictSupplied,
		--rIsPublic,
		--rDivision,		
		--rDeleted,
		--rActive,
		--rStatusListId,
		--rNotificationEmail,
	SELECT 
		rRestroomId
		,rContactId
		,rEquipmentNum
		,r[RestroomType]
		,r[RestroomName]
		,r[Address]
		,r[City]
		,r[State]
		,r[Zip]
		,r[Country]
		,r[DrinkingWater]
		,r[ACTRoute]
		,r[WeekdayHours]
		,r[SaturdayHours]
		,r[SundayHours]
		,r[Note]
		,r[NearestIntersection]
		,r[LongDec]
		,r[LatDec]
		,r[Geo]
		,r[NotificationEmail]
		--,r[IsDistrictOwned]
		--,r[IsDistrictCleaned]
		--,r[IsDistrictRepaired]
		--,r[IsDistrictSupplied]
		,r[CleanedContactId]
		,r[RepairedContactId]
		,r[SuppliedContactId]
		,r[SecurityGatesContactId]
		,r[SecurityLocksContactId]
		,r[IsToiletAvailable]
		,rAddressChanged
		,r[AverageRating]
		,rToiletGenderId
		,rLabelId
		,r[Deleted]
		,r[StatusListId]
		,r[UnavailableFrom]
		,r[UnavailableTo]
		,r[Division]
		,r[IsPublic]
		,r[AddUserId]
		,r[AddDateTime]
		,r[UpdUserId]
		,r[UpdDateTime]
		,cast(0 as bit) as IsHistory
		,r[Comment]
		,ar.AverageRating
	FROM 
		dbo.Restroom rs 
		LEFT OUTER JOIN AverageRating ar
			ON rRestroomId = ar.RestroomId
	WHERE 
		rRestroomId = @RestroomId

END
GO
/****** Object:  StoredProcedure [dbo[GetRestroomContact]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [GetRestroomContact] 'RestroomName', 'Descending'
CREATE PROCEDURE [dbo[GetRestroomContact] 
(	
	@SortField varchar(50),
	@SortDirection varchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statement
	SET NOCOUNT ON;

    SELECT R.RestroomId, R.RestroomName, R.LabelId, RTitle 'Status', C.ServiceProvider 'OwnedServiceProvider', C.ContactId 'OwnedContactId',
	CC.ServiceProvider 'CleanedServiceProvider', CC.ContactId 'CleanedContactId',
	RC.ServiceProvider 'RepairedServiceProvider', RC.ContactId 'RepairedContactId',
	SC.ServiceProvider 'SuppliedServiceProvider', SC.ContactId 'SuppliedContactId',
	SGC.ServiceProvider 'SecurityGateServiceProvider', SGC.ContactId 'SecurityGateContactId',
	SLC.ServiceProvider 'SecurityLockServiceProvider', SLC.ContactId 'SecurityLockContactId' 
	FROM Restroom R
	INNER JOIN RestroomStatusList RS
	ON R.StatusListId = RRestroomStatusListId
	LEFT JOIN Contact C
	ON R.ContactId = C.ContactId
	LEFT JOIN Contact CC
	ON R.CleanedContactId = CC.ContactId
	LEFT JOIN Contact RC
	ON R.RepairedContactId = RC.ContactId
	LEFT JOIN Contact SC
	ON R.SuppliedContactId = SC.ContactId
	LEFT JOIN Contact SGC
	ON R.SecurityGatesContactId = SGC.ContactId
	LEFT JOIN Contact SLC
	ON R.SecurityLocksContactId = SLC.ContactId
	WHERE R.Deleted = 0
	--order by case when CC.ServiceProvider is null then 2 else 1 end, CC.ServiceProvider desc	
	ORDER BY CASE WHEN @SortField = 'RestroomName' AND @SortDirection = 'Descending' THEN R.RestroomName END DESC, 
		CASE WHEN @SortField = 'RestroomName' AND @SortDirection = 'Ascending' THEN R.RestroomName END,
		CASE WHEN @SortField = 'LabelId' AND R.LabelId IS NULL OR R.LabelId = '' THEN 2 ELSE 1 END,
		CASE WHEN @SortField = 'LabelId' AND @SortDirection = 'Descending' THEN R.LabelId END DESC,
		CASE WHEN @SortField = 'LabelId' AND @SortDirection = 'Ascending' THEN R.LabelId END,
		CASE WHEN @SortField = 'StatusName' AND @SortDirection = 'Descending' THEN RTitle END DESC,
		CASE WHEN @SortField = 'StatusName' AND @SortDirection = 'Ascending' THEN RTitle END,
		CASE WHEN @SortField = 'OwnedServiceProvider' AND C.ServiceProvider IS NULL OR C.ServiceProvider = '' THEN 2 ELSE 1 END,
		CASE WHEN @SortField = 'OwnedServiceProvider' AND @SortDirection = 'Descending' THEN C.ServiceProvider END DESC, 
		CASE WHEN @SortField = 'OwnedServiceProvider' AND @SortDirection = 'Ascending' THEN C.ServiceProvider END,
		CASE WHEN @SortField = 'CleanedServiceProvider' AND CC.ServiceProvider IS NULL OR CC.ServiceProvider = '' THEN 2 ELSE 1 END,
		CASE WHEN @SortField = 'CleanedServiceProvider' AND @SortDirection = 'Descending' THEN CC.ServiceProvider END DESC, 
		CASE WHEN @SortField = 'CleanedServiceProvider' AND @SortDirection = 'Ascending' THEN CC.ServiceProvider END,
		CASE WHEN @SortField = 'RepairedServiceProvider' AND RC.ServiceProvider IS NULL OR RC.ServiceProvider = '' THEN 2 ELSE 1 END,
		CASE WHEN @SortField = 'RepairedServiceProvider' AND @SortDirection = 'Descending' THEN RC.ServiceProvider END DESC, 
		CASE WHEN @SortField = 'RepairedServiceProvider' AND @SortDirection = 'Ascending' THEN RC.ServiceProvider END,
		CASE WHEN @SortField = 'SuppliedServiceProvider' AND SC.ServiceProvider IS NULL OR SC.ServiceProvider = '' THEN 2 ELSE 1 END,
		CASE WHEN @SortField = 'SuppliedServiceProvider' AND @SortDirection = 'Descending' THEN SC.ServiceProvider END DESC, 
		CASE WHEN @SortField = 'SuppliedServiceProvider' AND @SortDirection = 'Ascending' THEN SC.ServiceProvider END,
		CASE WHEN @SortField = 'SecurityGateServiceProvider' AND SGC.ServiceProvider IS NULL OR SGC.ServiceProvider = '' THEN 2 ELSE 1 END,
		CASE WHEN @SortField = 'SecurityGateServiceProvider' AND @SortDirection = 'Descending' THEN SGC.ServiceProvider END DESC, 
		CASE WHEN @SortField = 'SecurityGateServiceProvider' AND @SortDirection = 'Ascending' THEN SGC.ServiceProvider END,
		CASE WHEN @SortField = 'SecurityLocksServiceProvider' AND SLC.ServiceProvider IS NULL OR SLC.ServiceProvider = '' THEN 2 ELSE 1 END,
		CASE WHEN @SortField = 'SecurityLocksServiceProvider' AND @SortDirection = 'Descending' THEN SLC.ServiceProvider END DESC, 
		CASE WHEN @SortField = 'SecurityLocksServiceProvider' AND @SortDirection = 'Ascending' THEN SLC.ServiceProvider END
END
GO
/****** Object:  StoredProcedure [dbo[GetRestroomFeedback]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--GRANT EXECUTE ON dbo.GetRestroomFeedback TO 'ACTRANSIT\ISReader'
--GRANT EXECUTE ON dbo.GetRestroomFeedback TO 'ACTRANSIT\ISReader'
--GRANT EXECUTE ON dbo.CharToTable TO 'ACTRANSIT\ISReader'

/*

EXEC dbo.GetRestroomFeedback

 @StartDate  = '2015-08-21'
,@EndDate  = '2016-08-27'
,@Badge  = ''
,@RestroomName = '(All)'
,@City = '(All)'
,@Route = '(All)'
,@InspectionPassed = 'All'
,@NeedsAttention = '(All)'

*/

CREATE PROC [dbo[GetRestroomFeedback]

 @StartDate DATE = NULL
,@EndDate DATE = NULL
,@Badge NVARCHAR(6) = NULL
,@RestroomName NVARCHAR(MAX) = NULL
,@City NVARCHAR(MAX) = NULL
,@Route NVARCHAR(MAX) = NULL
,@InspectionPassed INT = NULL -- -1=All, 0=No, 1=Yes
,@NeedsAttention INT = NULL -- -1=All, 0=No, 1=Yes
,@NeedRepair INT = NULL -- -1=All, 0=No, 1=Yes
,@NeedSupply INT = NULL -- -1=All, 0=No, 1=Yes
,@NeedCleaning INT = NULL -- -1=All, 0=No, 1=Yes
,@RestroomType NVARCHAR(MAX) = NULL
,@Resolution INT = NULL -- -1=All, 0=No, 1=Yes
,@LabelId NVARCHAR(MAX) = NULL
,@StatusListId INT = NULL
,@ToiletGenderId INT = NULL

AS
BEGIN

---- Parameter start
--DECLARE  @StartDate DATE = '2020-03-05'
--	   ,@EndDate DATE = '2017-03-11'
--	   ,@Badge NVARCHAR(6)
--	   ,@RestroomName NVARCHAR(MAX) --= 'Yali’s Café' --Nob Hill,
--	   ,@City NVARCHAR(MAX)	   
--	   ,@Route NVARCHAR(MAX) --= '31,51A'
--	   ,@InspectionPassed INT = NULL -- -1=All, 0=No, 1=Yes
--	   ,@NeedsAttention INT = NULL -- -1=All, 0=No, 1=Yes
--	   ,@NeedRepair INT = NULL -- -1=All, 0=No, 1=Yes
--	   ,@NeedSupply INT = NULL -- -1=All, 0=No, 1=Yes
--	   ,@NeedCleaning INT = NULL -- -1=All, 0=No, 1=Yes
--       ,@RestroomType NVARCHAR(MAX) = NULL
--       ,@Resolution NVARCHAR(MAX) = NULL
--	   ,@LabelId NVARCHAR(MAX) = NULL
--       ,@StatusListId INT = NULL
--       ,@ToiletGenderId INT = NULL
---- Parameter end

IF @StartDate IS NULL OR @EndDate IS NULL 
BEGIN
    SET @StartDate = DATEADD(DAY,-1, DATEADD(wk, DATEDIFF(wk, 6, CURRENT_TIMESTAMP), 0) ) --start of last week then minus one so week starts Sunday
    SET @EndDate =   DATEADD(DAY,-1, DATEADD(wk, DATEDIFF(wk, 6, CURRENT_TIMESTAMP), 6) ) --end of last week then minus one so week starts Sunday
END

IF @RestroomName = '(All)' SET @RestroomName = NULL
IF @City = '(All)' SET @City = NULL
IF @Route = '(All)' SET @Route = NULL
IF @RestroomType = '(All)' SET @RestroomType = NULL
IF (@Resolution IS NULL) SET @Resolution = -1
IF @LabelId = '(All)' SET @LabelId = NULL
    
IF @Badge = '' 
    SET @Badge = NULL
ELSE IF @Badge IS NOT NULL AND LEN(@Badge) < 6
    SET @Badge = RIGHT('000000'+@Badge,6)

SELECT 
   r.RestroomId
  ,r.RestroomName
  ,r.RestroomType
  ,r.LabelId
  ,r.StatusListId
  ,r.ToiletGenderId

  ,ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END RestroomAddress
  ,r.ACTRoute
  
  ,CAST(f.AddDateTime AS DATETIME) FeedBackDate /*Time For Report*/
  ,RTRIM(e.FirstName + ' ' + e.LastName + ' ' + e.Badge) EmployeeNameBadge
  ,f.Badge
  ,f.Rating
  ,CAST(f.NeedRepair AS TINYINT) NeedRepair
  ,CAST(f.NeedSupply AS TINYINT) NeedSupply
  ,CAST(f.NeedCleaning AS TINYINT) NeedCleaning
  ,f.Resolution
  ,CAST(f.InspectionPassed AS TINYINT) InspectionPassed
  ,CAST(f.NeedAttention AS TINYINT) NeedAttention
  --,CASE WHEN f.NeedAttention = 1 THEN 'x' ELSE 'a' END NeedAttentionCheckbox --Wingding font emptybox and Xcheckbox
  ,f.FeedbackText
  ,f.ReportedAction
  
    ,CAST( 
    CASE 
	   WHEN r.Address IS NOT NULL AND r.City IS NOT NULL AND r.State IS NOT NULL AND r.City IS NOT NULL  
	   THEN 'http://mapgoogle.com/maps?q='+ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END
	   ELSE ''
    END AS VARCHAR(255)) GoogleMapsLink
    
    ,CAST( 
    CASE 
	   WHEN r.Address IS NOT NULL AND r.City IS NOT NULL AND r.State IS NOT NULL AND r.City IS NOT NULL  
	   THEN 'javascript:void(window.open('''
		  +'http://mapgoogle.com/maps?q='+ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END
		  +''',''_blank''))'
	   ELSE ''
    END AS VARCHAR(255)) GoogleMapsLinkNewWindow
	
FROM dbo.Restroom r
JOIN dbo.Feedback f ON r.RestroomId = f.RestroomId 
JOIN EmployeeDW.dbo.EmployeeAll e ON RIGHT('000000'+f.Badge,6) = e.Badge
WHERE 1=1
	 --AND r.Active = 1
--	 AND r.StatusListId = 2 --Approved
	 AND CAST(f.AddDateTime AS DATE) BETWEEN @StartDate AND @EndDate
	 AND f.Badge = ISNULL(NULLIF(@Badge,''),f.Badge)
	 AND f.InspectionPassed = ISNULL(NULLIF(@InspectionPassed,-1),f.InspectionPassed)
	 AND f.NeedAttention = ISNULL(NULLIF(@NeedsAttention,-1),f.NeedAttention)
	 AND f.NeedRepair = ISNULL(NULLIF(@NeedRepair,-1),f.NeedRepair)
	 AND f.NeedSupply = ISNULL(NULLIF(@NeedSupply,-1),f.NeedSupply)
	 AND f.NeedCleaning = ISNULL(NULLIF(@NeedCleaning,-1),f.NeedCleaning)
	 AND
     (
		@Resolution = -1
        OR
        (@Resolution = 1 AND f.Resolution IS NOT NULL)
        OR
        (@Resolution = 0 AND f.Resolution IS NULL)
     )
	 AND 
	 (
		  ISNULL(NULLIF(@RestroomType,''),'') = ''
		  OR
		  RTRIM(LTRIM(REPLACE(r.RestroomType,',',''))) IN (SELECT STR FROM dbo.CharToTable(@RestroomType,','))

	 )
	 AND 
	 (
		  ISNULL(NULLIF(@LabelId,''),'') = ''
		  OR
		  RTRIM(LTRIM(REPLACE(r.LabelId,',',''))) IN (SELECT STR FROM dbo.CharToTable(@LabelId,','))

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
					   SELECT DISTINCT RestroomId --,r.ACTRoute ,o.Route
					   FROM dbo.Restroom s
					   CROSS APPLY
					   (
						  SELECT STR Route 
						  FROM dbo.CharToTable(ACTRoute,',')
						  WHERE STR IN (SELECT STR FROM dbo.CharToTable(@Route,','))
					   ) o
				    )

	 )
ORDER BY RestroomName 

END;--PROC

--GO

--EXECUTE sp_addextendedproperty @name = N'ACT_Desc', @value = 'Lists Restroom feedback from the Restroom Finder database', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetRestroomFeedback';
--GO

--EXECUTE sp_addextendedproperty @name = N'ACT_InternalApp', @value = 'Not found in TFS application', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetRestroomFeedback';
--GO

--EXECUTE sp_addextendedproperty @name = N'ACT_Note', @value = '', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetRestroomFeedback';
--GO

--EXECUTE sp_addextendedproperty @name = N'ACT_SSISPackage', @value = 'Not Directly Called from SSIS', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetRestroomFeedback';
--GO

--EXECUTE sp_addextendedproperty @name = N'ACT_SSRS', @value = 'SSRS Restroom Feedback uses this procedure', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetRestroomFeedback';
--GO


GO
/****** Object:  StoredProcedure [dbo[GetRestroomHistory]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo[GetRestroomHistory]
(
	@RestroomId Int,
	@SortField varchar(50),
	@SortDirection varchar(50)
)
AS

--declare @RestroomId Int = 569
--declare @SortField varchar(50) = 'UpdDateTime'
--declare @SortDirection varchar(50) = 'Ascending'
BEGIN
	SET NOCOUNT ON;
		
SELECT R.*, C.ServiceProvider, C.ContactName, C.Title ContactTitle, C.Email ContactEmail, C.Phone ContactPhone, C.[Address] ContactAddress, C.Notes ContactNotes, 
	CC.ServiceProvider 'CleanedServiceProvider', RC.ServiceProvider 'RepairedServiceProvider', SC.ServiceProvider 'SuppliedServiceProvider',
	SGC.ServiceProvider 'SecurityGateServiceProvider', SLC.ServiceProvider 'SecurityLocksServiceProvider', RTitle [Status]
FROM dbo.Restroom FOR SYSTEM_TIME ALL R
LEFT JOIN Contact C
	ON R.ContactId = C.ContactId
LEFT JOIN Contact CC
	ON R.CleanedContactId = CC.ContactId
LEFT JOIN Contact RC
	ON R.RepairedContactId = RC.ContactId
LEFT JOIN Contact SC
	ON R.SuppliedContactId = SC.ContactId
LEFT JOIN Contact SGC
	ON R.SecurityGatesContactId = SGC.ContactId
LEFT JOIN Contact SLC
	ON R.SecurityLocksContactId = SLC.ContactId
INNER JOIN RestroomStatusList RS
	ON R.StatusListId = RRestroomStatusListId
WHERE 
	RestroomId = @RestroomId --AND StatusListId = 2 
ORDER BY CASE WHEN @SortField = 'RestroomName' AND @SortDirection = 'Descending' THEN R.RestroomName END DESC, 
		CASE WHEN @SortField = 'RestroomName' AND @SortDirection = 'Ascending' THEN R.RestroomName END,  
		CASE WHEN @SortField = 'RestroomType' AND @SortDirection = 'Descending' THEN R.RestroomType END DESC, 
		CASE WHEN @SortField = 'RestroomType' AND @SortDirection = 'Ascending' THEN R.RestroomType END,
		CASE WHEN @SortField = 'Address' AND @SortDirection = 'Descending' THEN R.[Address] END DESC, 
		CASE WHEN @SortField = 'Address' AND @SortDirection = 'Ascending' THEN R.[Address] END,
		CASE WHEN @SortField = 'City' AND @SortDirection = 'Descending' THEN R.City END DESC, 
		CASE WHEN @SortField = 'City' AND @SortDirection = 'Ascending' THEN R.City END,
		CASE WHEN @SortField = 'DrinkingWater' AND @SortDirection = 'Descending' THEN R.DrinkingWater END DESC, 
		CASE WHEN @SortField = 'DrinkingWater' AND @SortDirection = 'Ascending' THEN R.DrinkingWater END,
		CASE WHEN @SortField = 'IsToiletAvailable' AND @SortDirection = 'Descending' THEN R.IsToiletAvailable END DESC, 
		CASE WHEN @SortField = 'IsToiletAvailable' AND @SortDirection = 'Ascending' THEN R.IsToiletAvailable END,
		CASE WHEN @SortField = 'ACTRoute' AND @SortDirection = 'Descending' THEN R.ACTRoute END DESC, 
		CASE WHEN @SortField = 'ACTRoute' AND @SortDirection = 'Ascending' THEN R.ACTRoute END,
		--CASE WHEN @SortField = 'Active' AND @SortDirection = 'Descending' THEN R.Active END DESC, 
		--CASE WHEN @SortField = 'Active' AND @SortDirection = 'Ascending' THEN R.Active END,
		CASE WHEN @SortField = 'IsPublic' AND @SortDirection = 'Descending' THEN R.IsPublic END DESC, 
		CASE WHEN @SortField = 'IsPublic' AND @SortDirection = 'Ascending' THEN R.IsPublic END,
		CASE WHEN @SortField = 'UpdUserId' AND @SortDirection = 'Descending' THEN R.UpdUserId END DESC, 
		CASE WHEN @SortField = 'UpdUserId' AND @SortDirection = 'Ascending' THEN R.UpdUserId END,
		CASE WHEN @SortField = 'UpdDateTime' AND @SortDirection = 'Descending' THEN R.UpdDateTime END DESC, 
		CASE WHEN @SortField = 'UpdDateTime' AND @SortDirection = 'Ascending' THEN R.UpdDateTime END,
		CASE WHEN @SortField = 'ServiceProvider' AND @SortDirection = 'Descending' THEN C.ServiceProvider END DESC, 
		CASE WHEN @SortField = 'ServiceProvider' AND @SortDirection = 'Ascending' THEN C.ServiceProvider END,
		CASE WHEN @SortField = 'ContactName' AND @SortDirection = 'Descending' THEN C.ContactName END DESC, 
		CASE WHEN @SortField = 'ContactName' AND @SortDirection = 'Ascending' THEN C.ContactName END,
		CASE WHEN @SortField = 'ContactTitle' AND @SortDirection = 'Descending' THEN C.Title END DESC, 
		CASE WHEN @SortField = 'ContactTitle' AND @SortDirection = 'Ascending' THEN C.Title END,
		CASE WHEN @SortField = 'ContactPhone' AND @SortDirection = 'Descending' THEN C.Phone END DESC, 
		CASE WHEN @SortField = 'ContactPhone' AND @SortDirection = 'Ascending' THEN C.Phone END,
		CASE WHEN @SortField = 'ContactEmail' AND @SortDirection = 'Descending' THEN C.Email END DESC, 
		CASE WHEN @SortField = 'ContactEmail' AND @SortDirection = 'Ascending' THEN C.Email END,
		CASE WHEN @SortField = 'ContactAddress' AND @SortDirection = 'Descending' THEN C.[Address] END DESC, 
		CASE WHEN @SortField = 'ContactAddress' AND @SortDirection = 'Ascending' THEN C.[Address] END,
		CASE WHEN @SortField IS NULL THEN R.UpdDateTime END 
															
END
GO
/****** Object:  StoredProcedure [dbo[GetRestroomList]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--GRANT EXECUTE ON dbo.GetRestroomList TO 'ACTRANSIT\ISReader'
--GRANT EXECUTE ON dbo.GetRestroomFeedback] TO 'ACTRANSIT\ISReader'
--GRANT EXECUTE ON dbo.[CharToTable] TO 'ACTRANSIT\ISReader'

CREATE PROC [dbo[GetRestroomList]

	 @RestroomType NVARCHAR(MAX) = NULL
	,@RestroomName NVARCHAR(MAX) = NULL
	,@City NVARCHAR(MAX) = NULL
	,@Route NVARCHAR(MAX) = NULL
	,@Zip	INT			= NULL
	,@StatusListId	INT	= 2 --In Service
	,@IsPublic	BIT		= NULL
	--,@Active	BIT		= NULL
	,@Deleted	BIT		= NULL

AS
BEGIN

---- Parameter start
--DECLARE  @RestroomType NVARCHAR(MAX) 
--	   ,@RestroomName NVARCHAR(MAX) = 'Yali’s Café' --Nob Hill,
--	   ,@City NVARCHAR(MAX)
--	   ,@Route NVARCHAR(MAX) --= '31,51A'
---- Parameter end
DECLARE @RatingCutoffDate DATE = DATEADD(WEEK, -1, GETDATE())
 
IF @RestroomType = '(All)' SET @RestroomType = NULL
IF @RestroomName = '(All)' SET @RestroomName = NULL
IF @Route = '(All)' SET @Route = NULL
IF @City = '(All)' SET @City = NULL

IF @StatusListId IS NULL OR @StatusListId = 1
	BEGIN
		;WITH AverageRating AS 
		(
			SELECT 
				RestroomId,
				AVG(Rating) 'AverageRating'
			FROM 
				Feedback
			WHERE 
				AddDateTime >= @RatingCutoffDate
				AND Rating != -1
			GROUP BY 		
				RestroomId
		)
		SELECT 
			r.RestroomId
			,r.ContactId
			,r.EquipmentNum
			,r.[RestroomType]
			,r.[RestroomName]
			,r.[Address]
			,r.[City]
			,r.[State]
			,r.[Zip]
			,r.[Country]
			,r.[DrinkingWater]
			,r.[ACTRoute]
			,r.[WeekdayHours]
			,r.[SaturdayHours]
			,r.[SundayHours]
			,r.[Note]
			,r.[NearestIntersection]
			,r.[LongDec]
			,r.[LatDec]
			,r.[Geo]
			,r.[NotificationEmail]
			--,r.[IsDistrictOwned]
			--,r.[IsDistrictCleaned]
			--,r.[IsDistrictRepaired]
			--,r.[IsDistrictSupplied]
			,r.[CleanedContactId]
			,r.[RepairedContactId]
			,r.[SuppliedContactId]
			,r.[SecurityGatesContactId]
			,r.[SecurityLocksContactId]
			,r.[IsToiletAvailable]
			,r.LabelId
			,CAST(ar.AverageRating AS DECIMAL(3, 2)) AS AverageRating
			--,r.[Active]
			,r.[Deleted]
			,r.ToiletGenderId
			,r.AddressChanged
			,r.[StatusListId]
			,r.[UnavailableFrom]
			,r.[UnavailableTo]
			,r.[Division]
			,r.[IsPublic]
			,r.[AddUserId]
			,r.[AddDateTime]
			,r.[UpdUserId]
			,r.[UpdDateTime]
			,cast(0 as bit) as IsHistory
			,r.[Comment]
			,CAST( 
				CASE 
					WHEN r.Address IS NOT NULL AND r.City IS NOT NULL AND r.State IS NOT NULL AND r.City IS NOT NULL  
					THEN 'http://mapgoogle.com/maps?q='+ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END
					ELSE ''
				END AS VARCHAR(255)) GoogleMapsLink
    
			,CAST( 
				CASE 
					WHEN r.Address IS NOT NULL AND r.City IS NOT NULL AND r.State IS NOT NULL AND r.City IS NOT NULL  
					THEN 'javascript:void(window.open('''
						+'http://mapgoogle.com/maps?q='+ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END
						+''',''_blank''))'
					ELSE ''
				END AS VARCHAR(255)) GoogleMapsLinkNewWindow
	
		FROM dbo.Restroom r
		LEFT JOIN AverageRating ar 
				ON r.RestroomId = ar.RestroomId
		WHERE 1=1
			AND (@Zip IS NULL OR r.zip=@Zip)
			AND (@IsPublic IS NULL OR r.IsPublic=@IsPublic)
			--AND (@Active IS NULL OR r.Active=@Active)
			AND (r.Deleted=0)
			--AND (@Deleted IS NULL OR r.Deleted=@Deleted)
			AND (@StatusListId IS NULL OR r.StatusListId=@StatusListId)
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
							SELECT DISTINCT RestroomId --,r.ACTRoute ,o.Route
							FROM dbo.Restroom s
							CROSS APPLY
							(
								SELECT STR Route 
								FROM dbo.CharToTable(ACTRoute,',')
								WHERE STR IN (SELECT STR FROM dbo.CharToTable(@Route,','))
							) o
						)

			)
		ORDER BY RestroomName 
	END
ELSE
	BEGIN
		;WITH AverageRating AS 
		(
			SELECT 
				RestroomId,
				AVG(Rating) 'AverageRating'
			FROM 
				Feedback
			WHERE 
				AddDateTime >= @RatingCutoffDate
				AND Rating != -1
			GROUP BY 		
				RestroomId
		)
		SELECT 
			r.RestroomId
			,r.ContactId
			,r.EquipmentNum
			,r.[RestroomType]
			,r.[RestroomName]
			,r.[Address]
			,r.[City]
			,r.[State]
			,r.[Zip]
			,r.[Country]
			,r.[DrinkingWater]
			,r.[ACTRoute]
			,r.[WeekdayHours]
			,r.[SaturdayHours]
			,r.[SundayHours]
			,r.[Note]
			,r.[NearestIntersection]
			,r.[LongDec]
			,r.[LatDec]
			,r.[Geo]
			,r.[NotificationEmail]
			--,r.[IsDistrictOwned]
			--,r.[IsDistrictCleaned]
			--,r.[IsDistrictRepaired]
			--,r.[IsDistrictSupplied]
			,r.[CleanedContactId]
			,r.[RepairedContactId]
			,r.[SuppliedContactId]
			,r.[SecurityGatesContactId]
			,r.[SecurityLocksContactId]
			,r.[IsToiletAvailable]
			,r.LabelId
			,CAST(ar.AverageRating AS DECIMAL(3, 2)) AS AverageRating
			--,r.[Active]
			,r.[Deleted]
			,r.ToiletGenderId
			,r.AddressChanged
			,r.[StatusListId]
			,r.[UnavailableFrom]
			,r.[UnavailableTo]
			,r.[Division]
			,r.[IsPublic]
			,r.[AddUserId]
			,r.[AddDateTime]
			,r.[UpdUserId]
			,r.[UpdDateTime]
			,cast(0 as bit) as IsHistory
			,r.Comment
			,CAST( 
				CASE 
					WHEN r.Address IS NOT NULL AND r.City IS NOT NULL AND r.State IS NOT NULL AND r.City IS NOT NULL  
					THEN 'http://mapgoogle.com/maps?q='+ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END
					ELSE ''
				END AS VARCHAR(255)) GoogleMapsLink
    
			,CAST( 
				CASE 
					WHEN r.Address IS NOT NULL AND r.City IS NOT NULL AND r.State IS NOT NULL AND r.City IS NOT NULL  
					THEN 'javascript:void(window.open('''
						+'http://mapgoogle.com/maps?q='+ISNULL(r.Address,'')+', '+ISNULL(r.City,'')+', '+ISNULL(r.State,'')+CASE WHEN r.Zip IS NOT NULL AND LEN(CAST(r.Zip AS VARCHAR(25))) >= 5 THEN ', '+CAST(r.Zip AS VARCHAR(25)) ELSE '' END
						+''',''_blank''))'
					ELSE ''
				END AS VARCHAR(255)) GoogleMapsLinkNewWindow
		FROM Restroom FOR system_time All r
		INNER JOIN (
			Select 
				Max(RestroomId) as RestroomId, Max(SysEndTime) SysEndTime  FROM Restroom  FOR system_time All 
			where 
				StatusListId=@StatusListId
			Group By RestroomId) X on x.RestroomId=R.RestroomId AND X.SysEndTime=R.SysEndTime AND r.StatusListId=@statusListId
		LEFT JOIN AverageRating ar 
				ON r.RestroomId = ar.RestroomId
		WHERE 1=1
			AND StatusListId=@StatusListId
			and r.RestroomId not in (select RestroomId from Restroom where StatusListId=3)
			AND (@Zip IS NULL OR r.zip=@Zip)
			AND (@IsPublic IS NULL OR r.IsPublic=@IsPublic)
			--AND (@Active IS NULL OR r.Active=@Active)
			AND (r.Deleted=0)
			--AND (@Deleted IS NULL OR r.Deleted=@Deleted)
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
							SELECT DISTINCT RestroomId --,r.ACTRoute ,o.Route
							FROM dbo.Restroom s
							CROSS APPLY
							(
								SELECT STR Route 
								FROM dbo.CharToTable(ACTRoute,',')
								WHERE STR IN (SELECT STR FROM dbo.CharToTable(@Route,','))
							) o
						)

			)
		ORDER BY RestroomName 
	END
	   	  
END;--PROC
GO
/****** Object:  StoredProcedure [dbo[GetRestroomsByDivision]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo[GetRestroomsByDivision]
AS
BEGIN

	SET NOCOUNT ON

	--Uncomment when importing schedule with Entity Framework designer tool so EF can see the column names and create a complex type
	--SET FMTONLY OFF 
	
	--DECLARE @CurrentDate AS Datetime = GETDATE()
	--DECLARE @BookingId AS Varchar(20) = NULL --'1812WR'

	DECLARE @MktSchedule TABLE (version_id int, line_id int, RouteAlpha varchar(50), [description] varchar(MAX))

	DECLARE @GarageRoute AS TABLE (Division CHAR(2), Route_Alpha VARCHAR(6), ValidToDate DATETIME2(7))

	;WITH LastLineVersion AS
	(SELECT MAX(Version_Id) AS Version_Id, Line_Name
	FROM [wu4_actransit[dbo[sch_lines] 
	GROUP BY Line_Name)

	INSERT INTO @MktSchedule
	SELECT Version_Id, line_id, line_name, CASE WHEN CHARINDEX('via', [description]) > 0 THEN LEFT(CONVERT(VARCHAR(MAX), [description]), CHARINDEX('via', [description]) - 2) ELSE [description] END
	FROM [wu4_actransit[dbo[sch_lines] L
		INNER JOIN LastLineVersion LLV ON version_id = LLV.Version_Id 
			AND line_name = LLV.line_name
	ORDER BY line_name

	INSERT INTO @GarageRoute
	SELECT DISTINCT Garage AS Division, TRIM(r.[value]) AS [Route_Alpha], ValidToDate
	FROM [SchedulingDWHASTU[Block] h
		CROSS APPLY STRING_SPLIT(TRIM('/' FROM REPLACE(h.AllRoutes, ' ', '')),'/')  r

	;WITH RouteByDivision 
	AS
	(SELECT Division, A.[Route_Alpha]
	 FROM @GarageRoute A
		INNER JOIN
		(SELECT GR.[Route_Alpha], MAX(GR.ValidToDate) AS ValidToDate
		FROM @GarageRoute GR
		GROUP BY [Route_Alpha]) B ON A.[Route_Alpha] = B.[Route_Alpha] AND A.ValidToDate = B.ValidToDate
	),

	RestroomByRoute
	AS
	(SELECT TRIM(Ro.[value]) AS [Route], R.*
	FROM ApprovedRestroom R
		CROSS APPLY STRING_SPLIT(TRIM(',' FROM REPLACE(R.ACTRoute, ' ', '')), ',') Ro
	),

	RestroomByDivision
	AS 
	(SELECT TRIM(TDR.Division) AS CalculatedDivision,
			RR.*, 
			Case 
              WHEN ISNUMERIC(RR.[Route])=1 Then RR.[Route]
              WHEN ISNUMERIC(RR.[Route])=0 and RR.[Route] like '[0-9][0-9][0-9][0-9][0-9]%' then substring(Route_Alpha,1,5)
              WHEN ISNUMERIC(RR.[Route])=0 and RR.[Route] like '[0-9][0-9][0-9][0-9]%' then substring(Route_Alpha,1,4)
              WHEN ISNUMERIC(RR.[Route])=0 and RR.[Route] like '[0-9][0-9][0-9]%' then substring(Route_Alpha,1,3)
              WHEN ISNUMERIC(RR.[Route])=0 and RR.[Route] like '[0-9][0-9]%' then substring(Route_Alpha,1,2)
              WHEN ISNUMERIC(RR.[Route])=0 and RR.[Route] like '[0-9]%' then substring(Route_Alpha,1,1)
              ELSE 9999999
			END AS number,
			CASE
              WHEN ISNUMERIC(Route_Alpha)=1 Then NULL
              WHEN ISNUMERIC(Route_Alpha)=0 and Route_Alpha like '[0-9][0-9][0-9][0-9][0-9]%' then substring(Route_Alpha,6,Len(Route_Alpha)-4)
              WHEN ISNUMERIC(Route_Alpha)=0 and Route_Alpha like '[0-9][0-9][0-9][0-9]%' then substring(Route_Alpha,5,Len(Route_Alpha)-3)
              WHEN ISNUMERIC(Route_Alpha)=0 and Route_Alpha like '[0-9][0-9][0-9]%' then substring(Route_Alpha,4,Len(Route_Alpha)-2)
              WHEN ISNUMERIC(Route_Alpha)=0 and Route_Alpha like '[0-9][0-9]%' then substring(Route_Alpha,3,Len(Route_Alpha)-1)
              WHEN ISNUMERIC(Route_Alpha)=0 and Route_Alpha like '[0-9]%' then substring(Route_Alpha,2,Len(Route_Alpha))
              ELSE Route_Alpha
			END AS str,
	   LEFT(m[description], CHARINDEX(',', m[description] + ',') - 1) AS DestinationName		
	FROM RestroomByRoute RR
		INNER JOIN RouteByDivision TDR 
			ON RR.[Route] = TDR.[Route_Alpha] 
		LEFT JOIN @MktSchedule ms
			ON mRouteAlpha = RR.[Route]
	)

	SELECT RestroomId, 
		   ContactId,
		   EquipmentNum,
		   RestroomType,
		   RestroomName,
		   [Address],
		   City,
		   [State],
		   Zip, 
		   Country,
		   DrinkingWater,
		   ACTRoute,
		   CalculatedDivision AS Division,
		   [Route],
		   DestinationName,
		   WeekdayHours,
		   SaturdayHours,
		   SundayHours,
		   Note,
		   LongDec,
		   LatDec,
		   NotificationEmail,
		   CleanedContactId,
		   RepairedContactId,
		   SuppliedContactId,
		   SecurityGatesContactId,
		   SecurityLocksContactId,
		   IsToiletAvailable,
		   LabelId,
		   --Active,
		   ToiletGenderId,
		   AddressChanged,
		   Deleted,
		   IsHistory,
		   IsPublic,
		   StatusListId,
		   UnavailableFrom,
		   UnavailableTo
	FROM RestroomByDivision
	WHERE Deleted = 0
	ORDER BY Division, Number, [Str]
       
END
GO
/****** Object:  StoredProcedure [dbo[GetRestroomsNearby]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo[GetRestroomsNearby]
	-- Add the parameters for the stored procedure here
	@routeAlpha	varchar(5)
	,@direction	varchar(12)
	,@lat		decimal(9,6)
	,@long		decimal(9,6)
	,@distance	INT		= NULL
	,@isPublic	BIT		= NULL
	,@Zip	INT			= NULL
	,@statusListId	INT	= NULL
	--,@active	BIT		= NULL
	,@deleted	BIT		= NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statement
	SET NOCOUNT ON;

	--Uncomment when importing schedule with Entity Framework designer tool so EF can see the column names and create a complex type
	--SET FMTONLY OFF 

	DECLARE @RatingCutoffDate DATE = DATEADD(WEEK, -1, GETDATE())

	DECLARE @Origin GEOGRAPHY,@temp	varchar(30)
	--set @temp='POINT (' + cast(@lat as varchar) + ' ' + cast(@long  as varchar) + ')'
	
	
	SET @Origin = geography::Point(@lat, @long, 4326)
	
	--Select @deleted
	--SET @Origin = GEOGRAPHY::STGeomFromText(@temp, 4326);
	IF (@statusListId IS NULL) OR @statusListId = 1
	BEGIN
		;WITH AverageRating AS 
		(
			SELECT 
				RestroomId,
				AVG(Rating) 'AverageRating'
			FROM 
				Feedback
			WHERE 
				AddDateTime >= @RatingCutoffDate
				AND Rating != -1
			GROUP BY 		
				RestroomId
		)
		SELECT 		
			r.RestroomID
			,r.ContactId
			,r.RestroomType 
			,r.RestroomName 
			,r.EquipmentNum
			,r.Address
			,r.City
			,r.State 
			,r.Zip 
			,r.Country
			,r.DrinkingWater
			,r.ACTRoute
			,r.WeekdayHours
			,r.SaturdayHours
			,r.SundayHours
			,r.Note
			,r.NearestIntersection
			,r.LongDec
			,r.LatDec
			,r.Geo
			,r.NotificationEmail
			--,r.IsDistrictOwned
			--,r.IsDistrictCleaned
			--,r.IsDistrictRepaired
			--,r.IsDistrictSupplied
			,r.[CleanedContactId]
			,r.[RepairedContactId]
			,r.[SuppliedContactId]
			,r.[SecurityGatesContactId]
			,r.[SecurityLocksContactId]
			,r.IsToiletAvailable
			--,r.Active
			,r.AddressChanged
			,r.ToiletGenderId
			,r.LabelId
			,r.Deleted
			,r.StatusListId
			,r.UnavailableFrom
			,r.UnavailableTo
			,r.Division
			,r.IsPublic
			,r.AddUserId
			,r.AddDateTime
			,r.UpdUserId
			,r.UpdDateTime
			,CAST(ar.AverageRating AS DECIMAL(3, 2)) AS AverageRating
			,CAST(0 AS BIT) AS IsHistory
			,r.Comment
		FROM 
			dbo.Restroom r
		LEFT JOIN AverageRating ar 
			ON r.RestroomId = ar.RestroomId
		WHERE 			
			(
				NULLIF(@routeAlpha, '') IS NULL 
				OR (',' + RTRIM(r.ACTRoute) + ',') LIKE '%,' + @routeAlpha + ',%'
				OR (', ' + RTRIM(r.ACTRoute) + ',') LIKE '%, ' + @routeAlpha + ',%'
			)
			AND (@Distance IS NULL OR @OrigiSTDistance(geo) <= @Distance)
			AND (@Zip IS NULL OR r.zip=@Zip)
			AND (@IsPublic IS NULL OR r.IsPublic=@IsPublic)
			--AND (@Active IS NULL OR r.Active=@Active)
			AND (@deleted IS NULL OR ISNULL(r.Deleted,0)=@deleted)
			AND (@StatusListId IS NULL OR r.StatusListId=@StatusListId)
	END
	ELSE
	BEGIN
	;WITH AverageRating AS 
		(
			SELECT 
				RestroomId,
				AVG(Rating) 'AverageRating'
			FROM 
				Feedback
			WHERE 
				AddDateTime >= @RatingCutoffDate
				AND Rating != -1
			GROUP BY 		
				RestroomId
		)
		SELECT 
			r.RestroomID
			,r.ContactId
			,r.RestroomType 
			,r.RestroomName 
			,r.EquipmentNum
			,r.Address
			,r.City
			,r.State 
			,r.Zip 
			,r.Country
			,r.DrinkingWater
			,r.ACTRoute
			,r.WeekdayHours
			,r.SaturdayHours
			,r.SundayHours
			,r.Note
			,r.NearestIntersection
			,r.LongDec
			,r.LatDec
			,r.Geo
			,r.NotificationEmail
			--,r.IsDistrictOwned
			--,r.IsDistrictCleaned
			--,r.IsDistrictRepaired
			--,r.IsDistrictSupplied
			,r.[CleanedContactId]
			,r.[RepairedContactId]
			,r.[SuppliedContactId]
			,r.[SecurityGatesContactId]
			,r.[SecurityLocksContactId]
			,r.IsToiletAvailable
			,r.LabelId
			--,r.Active
			,r.AddressChanged
			,r.ToiletGenderId
			,r.Deleted
			,r.StatusListId
			,r.UnavailableFrom
			,r.UnavailableTo
			,r.Division
			,r.IsPublic
			,r.AddUserId
			,r.AddDateTime
			,r.UpdUserId
			,r.UpdDateTime
			,CAST(ar.AverageRating AS DECIMAL(3, 2)) AS AverageRating
			,CASE  
				WHEN r.SysEndTime <=  getutcdate() THEN CAST(1 AS BIT)
				ELSE 
					CAST(0 AS BIT)
			END AS IsHistory
			,r.Comment
		FROM 
			dbo.Restroom FOR system_time All r
		LEFT JOIN AverageRating ar 
			ON r.RestroomId = ar.RestroomId
		Inner JOIN (
			Select 
				RestroomId, Max(SysEndTime) SysEndTime  FROM Restroom  FOR system_time All 
			where 
				StatusListId=@StatusListId
			Group By RestroomId
		) X on X.RestroomId=r.RestroomId AND X.SysEndTime=r.SysEndTime AND r.StatusListId=@statusListId
		WHERE 
			r.RestroomId not in (select RestroomId from Restroom where StatusListId=3) AND
			(
				NULLIF(@routeAlpha, '') IS NULL 
				OR (',' + RTRIM(r.ACTRoute) + ',') LIKE '%,' + @routeAlpha + ',%'
				OR (', ' + RTRIM(r.ACTRoute) + ',') LIKE '%, ' + @routeAlpha + ',%'
			)
			AND (@Distance IS NULL OR @OrigiSTDistance(geo) <= @Distance)
			AND (@Zip IS NULL OR r.zip=@Zip)
			AND (@IsPublic IS NULL OR r.IsPublic=@IsPublic)
			--AND (@Active IS NULL OR r.Active=@Active)
			AND (@deleted IS NULL OR r.Deleted=@deleted)
			AND (@StatusListId IS NULL OR r.StatusListId=@StatusListId)

	
	END

	
	
	--;WITH AverageRating AS 
	--(
	--	SELECT 
	--		RestroomId,
	--		AVG(Rating) 'AverageRating'
	--	FROM 
	--		Feedback
	--	WHERE 
	--		AddDateTime >= @RatingCutoffDate
	--		AND Rating != -1
	--	GROUP BY 		
	--		RestroomId
	--)
	--UPDATE 
	--	#Restroom
	--SET 
	--	AverageRating = ar.AverageRating
	--FROM 
	--	#Restroom rs
	--	INNER JOIN AverageRating ar 
	--		ON rRestroomId = ar.RestroomId
	
	--SELECT 
	--	RestroomID, 
	--	RestroomType, 
	--	RestroomName, 
	--	EquipmentNum,
	--	Address, 
	--	City, 
	--	State, 
	--	Zip, 
	--	Country, 
	--	DrinkingWater, 
	--	ACTRoute, 
	--	WeekdayHours, 
	--	SaturdayHours,
	--	WeekdayHours,
	--	Note, 
	--	NearestIntersection,
	--	LongDec, 
	--	LatDec, 
	--	Geo,
 --       NotificationEmail,
 --       IsDistrictOwned,
 --       IsDistrictCleaned,
 --       IsDistrictRepaired,
 --       IsDistrictSupplied,
	--	Active,
	--	Deleted,
	--	StatusListId,
	--	UnavailableFrom,
	--	UnavailableTo,
	--	Division,
	--	IsPublic,
	--	AddUserId,
	--	AddDateTime,
	--	UpdUserId,
	--	UpdDateTime,
	--	CAST(AverageRating AS DECIMAL(3, 2)) AS AverageRating
	--FROM 
	--	#Restroom

END
GO
/****** Object:  StoredProcedure [dbo[GetRestroomsNearby_Original_Unmodified]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo[GetRestroomsNearby_Original_Unmodified]
	-- Add the parameters for the stored procedure here
	@routeAlpha	varchar(5),
	@direction	varchar(12),
	@lat		decimal(9,6),
	@long		decimal(9,6),
	@distance	INT=500
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statement
	SET NOCOUNT ON;

	DECLARE @Origin GEOGRAPHY,@temp	varchar(30)
	--set @temp='POINT (' + cast(@lat as varchar) + ' ' + cast(@long  as varchar) + ')'
	
	
	SET @Origin = geography::Point(@lat, @long, 4326)
	
	--SET @Origin = GEOGRAPHY::STGeomFromText(@temp, 4326);

	-- return all rows from events in 40km radius
	SELECT 
		* 
	FROM 
		Restroom 
	WHERE 
		(@routeAlpha is null or ACTRoute like '%' + @routeAlpha + '%')
		AND @OrigiSTDistance(geo) <= @Distance
END

GO
/****** Object:  StoredProcedure [dbo[GetRoutesByLocation]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC [dbo[GetRoutesByLocation] 37.8052776707191, -122.26944573292695

CREATE   PROCEDURE [dbo[GetRoutesByLocation]
	@LocationLat AS DECIMAL(9,6),
	@LocationLong AS DECIMAL(9,6),
	@SearchRadiusFeet AS FLOAT = 600
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @SRID INT = 4326
	DECLARE @Location GEOGRAPHY = geography::STPointFromText(CONCAT('POINT (', CONVERT(VARCHAR(MAX), @LocationLong), ' ',  CONVERT(VARCHAR(MAX), @LocationLat), ')'), @SRID);  
	DECLARE @SeachRadiusMeters FLOAT = @SearchRadiusFeet / 3.28
	DECLARE @CurrenBookingStartDate DATE = NULL

	SELECT @CurrenBookingStartDate = StartDate
	FROM SchedulingDW.HastuBooking
	WHERE StartDate <= CONVERT(DATE, SYSDATETIME()) 
		AND EndDate >= CONVERT(DATE, SYSDATETIME())

	--;WITH RouteWaypoint
	--AS
	DROP TABLE IF EXISTS #RouteWaypoint
	(SELECT RouteAlpha, 
			RouteVarID, 
			geography::STGeomFromText(
				CONCAT('LINESTRING(', STRING_AGG(CONVERT(VARCHAR(MAX), Longitude) + ' ' + CONVERT(VARCHAR(MAX), Latitude), ',') WITHIN GROUP (ORDER BY OrderID), ')')
				,@SRID)
		   .MakeValid() AS WaypointLine
	INTO #RouteWaypoint
	FROM SchedulingDW.dbo.Waypoints
	WHERE Booking IN
		 (SELECT BookingId
		  FROM SchedulingDW.HastuBooking
		  WHERE StartDate >= @CurrenBookingStartDate)
	GROUP BY RouteAlpha, RouteVARID)

	SELECT DISTINCT RW.RouteAlpha
	FROM #RouteWaypoint RW
	WHERE @LocatioSTDistance(RW.WaypointLine) < @SeachRadiusMeters
   
END
GO
/****** Object:  StoredProcedure [dbo[GetRouteSuggestions]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC GetRouteSuggestions

CREATE   PROC [dbo[GetRouteSuggestions]
	@SearchRadiusFeet FLOAT = 600
AS

BEGIN

	SET NOCOUNT ON

	DECLARE @SearchRadiusMeters FLOAT = @SearchRadiusFeet / 3.28

	DROP TABLE IF EXISTS #RouteWaypoint
	DROP TABLE IF EXISTS #RestroomRoute

	;WITH CurrentBooking
	AS
	(SELECT BookingId
	FROM SchedulingDW.HastuBooking
	WHERE StartDate <= CONVERT(DATE, SYSDATETIME()) 
		AND EndDate >= CONVERT(DATE, SYSDATETIME()))

	--Build geography - line for waypoints
	SELECT RouteAlpha, 
			RouteVarID, 
			geography::STGeomFromText(
				CONCAT('LINESTRING(', STRING_AGG(CONVERT(varchar(MAX), Longitude) + ' ' + CONVERT(varchar(MAX), Latitude), ',') WITHIN GROUP (ORDER BY OrderId ASC), ')')
				,4326)
		   .MakeValid() AS WaypointLine
	INTO #RouteWaypoint
	FROM SchedulingDW.dbo.Waypoints
	WHERE Booking IN 
		(SELECT BookingId
		 FROM CurrentBooking)
	GROUP BY RouteAlpha, RouteVARID

	--List restrooms broken down by route
	SELECT R.RestroomId, TRIM(T.RestroomRoute) AS RestroomRoute, R.Geo
	INTO #RestroomRoute
	FROM dbo.ApprovedRestroom R
		CROSS APPLY (SELECT RR.[value] AS [RestroomRoute]
					 FROM STRING_SPLIT(R.ACTRoute, ',') RR) AS T

	--Recommendations for current route selection
	SELECT R.RestroomId, R.RestroomName, T.RestroomRoute, R.RestroomType, R.[Address], R.City, R.Zip,T.[Action]
	FROM dbo.ApprovedRestroom R
		INNER JOIN 
		(SELECT DISTINCT RR.RestroomId, 
						RR.RestroomRoute,
					   CASE 
						WHEN RW.RouteAlpha IS NULL THEN 'Remove - Route is no longer in use'
						WHEN RR.Geo.STDistance(RW.WaypointLine) > @SearchRadiusMeters THEN CONCAT('Remove - Distance exceeds',  @SearchRadiusFeet ,' feet')
						ELSE 'Keep'
					   END AS [Action]
		FROM #RestroomRoute RR
			LEFT JOIN #RouteWaypoint RW ON RR.RestroomRoute = RW.RouteAlpha

		UNION

		--New route recommendations
		SELECT RecommendedRoute.*, 'Add' AS [Action]
		FROM
			(SELECT RR.RestroomId, 
					T.RouteAlpha AS [RestroomRoute]
			FROM ApprovedRestroom RR
				OUTER APPLY 
				(SELECT DISTINCT RW.RouteAlpha
				 FROM #RouteWaypoint RW
				 WHERE RR.Geo.STDistance(RW.WaypointLine) < @SearchRadiusMeters
				) T
			WHERE T.RouteAlpha IS NOT NULL

			EXCEPT

			SELECT RR.RestroomId, RR.RestroomRoute
			FROM #RestroomRoute RR) AS RecommendedRoute)
		AS T ON R.RestroomId = T.RestroomId

END
GO
/****** Object:  StoredProcedure [dbo[RefreshRestroomDivision]    Script Date: 3/9/2022 8:54:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo[RefreshRestroomDivision]
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @CurrentDate AS Datetime = GETDATE()
	DECLARE @BookingId AS Varchar(20) = NULL --'1912WR'

	-- Get the current booking from the booking table
	SELECT @BookingId = BookingId 
	FROM [SchedulingDW[HASTUS[Booking]
	WHERE StartDate <= @CurrentDate and EndDate > @CurrentDate

	;WITH RouteByDivision 
	AS
	(SELECT DISTINCT Garage AS Division, TRIM(r.[value]) AS [Route_Alpha]
	 FROM [SchedulingDWHASTU[Block] h
		CROSS APPLY STRING_SPLIT(TRIM('/' FROM REPLACE(h.AllRoutes, ' ', '')),'/')  r
	 WHERE h.BookingId = @BookingId
	),		

	RestroomByRoute
	AS
	(SELECT TRIM(Ro.[value]) AS [Route], R.*
	FROM Restroom R
		CROSS APPLY STRING_SPLIT(TRIM(',' FROM REPLACE(R.ACTRoute, ' ', '')), ',') Ro
	),

	RestroomDivision
	AS
	(SELECT RD.RestroomId, STRING_AGG(RD.Division, ',') AS Divisions
	 FROM 
		(SELECT RR.RestroomId, TDR.Division
		FROM RestroomByRoute RR
			INNER JOIN RouteByDivision TDR ON RR.[Route] = TDR.[Route_Alpha] 
		GROUP BY RR.RestroomId, TDR.Division) AS RD
	 GROUP BY RD.RestroomId
	)
	
	UPDATE R
	SET R.Division = RD.Divisions, 
	    R.UpdUserId = SUSER_NAME(), 
		R.UpdDateTime = SYSDATETIME()
	FROM RestroomDivision RD
		INNER JOIN Restroom R ON RD.RestroomId = R.RestroomId
       
END
GO
EXEC sysp_addextendedproperty @name=N'ACT_Desc', @value=N'Lists Restroom feedback from the Restroom Finder database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'GetRestroomFeedback'
GO
EXEC sysp_addextendedproperty @name=N'ACT_InternalApp', @value=N'Not found in TFS application' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'GetRestroomFeedback'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Note', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'GetRestroomFeedback'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SSISPackage', @value=N'Not Directly Called from SSIS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'GetRestroomFeedback'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SSRS', @value=N'SSRS Restroom Feedback uses this procedure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'GetRestroomFeedback'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Desc', @value=N'Lists Restroom details from the Restroom Finder database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'GetRestroomList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_InternalApp', @value=N'Not found in TFS application' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'GetRestroomList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Note', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'GetRestroomList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SSISPackage', @value=N'Not Directly Called from SSIS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'GetRestroomList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SSRS', @value=N'SSRS Restroom List uses this procedure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'GetRestroomList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Desc', @value=N'Converts a single symbol delimited string into a list of value For example "abc,def,ghi" will be returned as "abc" (1st row), "def" (2nd row), and "ghi" (3th row) in one single colum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'CharToTable'
GO
EXEC sysp_addextendedproperty @name=N'ACT_InternalApp', @value=N'Not found in TFS application' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'CharToTable'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Note', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'CharToTable'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SSISPackage', @value=N'Not Directly Called from SSIS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'CharToTable'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SSRS', @value=N'Not Found in TFS Report Solution' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'FUNCTION',@level1name=N'CharToTable'
GO
EXEC sysp_addextendedproperty @name=N'MS_Description', @value=N'SessionId is here for compatibility! Should be removed later after every one migrated to the new versio' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Confirmation'
GO
USE [master]
GO
ALTER DATABASE [RestroomFinder2] SET  READ_WRITE 
GO

