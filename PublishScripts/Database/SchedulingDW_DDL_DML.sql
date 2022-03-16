USE [SchedulingDW]
GO
/****** Object:  Table [HASTUS[Booking]    Script Date: 3/14/2022 5:14:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE SCHEMA [HASTUS]
GO

CREATE TABLE [HASTUS[Booking](
	[BookingId] [varchar](10) NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[AddUserId] [nvarchar](50) NOT NULL,
	[AddDateTime] [datetime2](3) NOT NULL,
	[UpdUserId] [nvarchar](50) NULL,
	[UpdDateTime] [datetime2](3) NULL,
	[SysRecNo] [bigint] NOT NULL,
	[BookingDesc] [varchar](25) NOT NULL,
 CONSTRAINT [pk_booking_booking] PRIMARY KEY CLUSTERED 
(
	[BookingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY],
 CONSTRAINT [UK_BookingBookingID] UNIQUE NONCLUSTERED 
(
	[BookingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HASTUS[Route]    Script Date: 3/14/2022 5:14:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HASTUS[Route](
	[BookingId] [varchar](10) NOT NULL,
	[RouteAlpha] [varchar](5) NOT NULL,
	[RouteDescription] [varchar](50) NULL,
	[RouteTypeId] [int] NOT NULL,
	[Color] [varchar](12) NULL,
	[SortOrder] [int] NOT NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
	[SysRecNo] [bigint] NOT NULL,
 CONSTRAINT [PK_Route] PRIMARY KEY CLUSTERED 
(
	[BookingId] ASC,
	[RouteAlpha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HASTUS[RouteList]    Script Date: 3/14/2022 5:14:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HASTUS[RouteList](
	[RouteAlpha] [varchar](5) NOT NULL,
	[SortOrder] [int] NULL,
	[Rapid] [bit] NULL,
	[Transbay] [bit] NULL,
	[LocalPassenger] [bit] NULL,
 CONSTRAINT [PK_RouteList] PRIMARY KEY CLUSTERED 
(
	[RouteAlpha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HASTUS[RouteType]    Script Date: 3/14/2022 5:14:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HASTUS[RouteType](
	[RouteTypeId] [int] IDENTITY(1,1) NOT NULL,
	[RouteTypeName] [varchar](40) NOT NULL,
	[AddUserId] [varchar](50) NOT NULL,
	[AddDateTime] [datetime2](7) NOT NULL,
	[UpdUserId] [varchar](50) NULL,
	[UpdDateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_RouteType] PRIMARY KEY CLUSTERED 
(
	[RouteTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [HASTUS[Booking] ADD  CONSTRAINT [DF_HASTUS_Booking_AddUserId]  DEFAULT (suser_name()) FOR [AddUserId]
GO
ALTER TABLE [HASTUS[Booking] ADD  CONSTRAINT [DF_HASTUS_Booking_AddDateTime]  DEFAULT (sysdatetime()) FOR [AddDateTime]
GO
ALTER TABLE [HASTUS[Booking] ADD  CONSTRAINT [DF_HASTUS_Booking_UpdUserId]  DEFAULT (suser_name()) FOR [UpdUserId]
GO
ALTER TABLE [HASTUS[Booking] ADD  CONSTRAINT [DF_HASTUS_Booking_UpdDateTime]  DEFAULT (sysdatetime()) FOR [UpdDateTime]
GO
ALTER TABLE [HASTUS[Route] ADD  CONSTRAINT [DF_HASTUS_Route_AddUserId]  DEFAULT (suser_name()) FOR [AddUserId]
GO
ALTER TABLE [HASTUS[Route] ADD  CONSTRAINT [DF_HASTUS_Route_AddDateTime]  DEFAULT (sysdatetime()) FOR [AddDateTime]
GO
ALTER TABLE [HASTUS[Route] ADD  CONSTRAINT [DF_HASTUS_Route_UpdUserId]  DEFAULT (suser_name()) FOR [UpdUserId]
GO
ALTER TABLE [HASTUS[Route] ADD  CONSTRAINT [DF_HASTUS_Route_UpdDateTime]  DEFAULT (sysdatetime()) FOR [UpdDateTime]
GO
ALTER TABLE [HASTUS[RouteType] ADD  CONSTRAINT [DF_HASTUS_RouteType_AddUserId]  DEFAULT (suser_name()) FOR [AddUserId]
GO
ALTER TABLE [HASTUS[RouteType] ADD  CONSTRAINT [DF_HASTUS_RouteType_AddDateTime]  DEFAULT (sysdatetime()) FOR [AddDateTime]
GO
ALTER TABLE [HASTUS[RouteType] ADD  CONSTRAINT [DF_HASTUS_RouteType_UpdUserId]  DEFAULT (suser_name()) FOR [UpdUserId]
GO
ALTER TABLE [HASTUS[RouteType] ADD  CONSTRAINT [DF_HASTUS_RouteType_UpdDateTime]  DEFAULT (sysdatetime()) FOR [UpdDateTime]
GO
ALTER TABLE [HASTUS[Route]  WITH CHECK ADD  CONSTRAINT [FK_HASTUS_Route_RouteAlpha] FOREIGN KEY([RouteAlpha])
REFERENCES [HASTUS[RouteList] ([RouteAlpha])
GO
ALTER TABLE [HASTUS[Route] CHECK CONSTRAINT [FK_HASTUS_Route_RouteAlpha]
GO
ALTER TABLE [HASTUS[Route]  WITH CHECK ADD  CONSTRAINT [FK_HASTUS_Route_RouteTypeId] FOREIGN KEY([RouteTypeId])
REFERENCES [HASTUS[RouteType] ([RouteTypeId])
GO
ALTER TABLE [HASTUS[Route] CHECK CONSTRAINT [FK_HASTUS_Route_RouteTypeId]
GO
ALTER TABLE [HASTUS[Booking]  WITH CHECK ADD  CONSTRAINT [ck_booking_StartDateLessThanEndDate] CHECK  (([StartDate]<[EndDate]))
GO
ALTER TABLE [HASTUS[Booking] CHECK CONSTRAINT [ck_booking_StartDateLessThanEndDate]
GO
EXEC sysp_addextendedproperty @name=N'ACT_Desc', @value=N'Bookings that are based on Sign-up period' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Booking'
GO
EXEC sysp_addextendedproperty @name=N'ACT_DescOfProcessFillingTheTable', @value=N'SQL02 proc imports file \\appfs1\EnterpriseDatabase\Transportation\Hastus\Import\Bookingxml' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Booking'
GO
EXEC sysp_addextendedproperty @name=N'ACT_ETLUpdateStrategy', @value=N'UPD_DEL_INS' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Booking'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Note', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Booking'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SPName', @value=N'HASTUPopulateBooking' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Booking'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SQLJobName', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Booking'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SSISPackageName', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Booking'
GO
EXEC sysp_addextendedproperty @name=N'ACT_TableSource', @value=N'Hastus' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Booking'
GO
EXEC sysp_addextendedproperty @name=N'ACT_TFSSolutionPackage', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Booking'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Desc', @value=N'Route information records including description and color, group by different BookingId' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Route'
GO
EXEC sysp_addextendedproperty @name=N'ACT_DescOfProcessFillingTheTable', @value=N'SQL02 proc imports file \\appfs1\EnterpriseDatabase\Transportation\Hastus\Import\Routexml' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Route'
GO
EXEC sysp_addextendedproperty @name=N'ACT_ETLUpdateStrategy', @value=N'UPD_DEL_INS' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Route'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Note', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Route'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SPName', @value=N'HASTUPopulateRoutes' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Route'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SQLJobName', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Route'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SSISPackageName', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Route'
GO
EXEC sysp_addextendedproperty @name=N'ACT_TableSource', @value=N'Hastus' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Route'
GO
EXEC sysp_addextendedproperty @name=N'ACT_TFSSolutionPackage', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'Route'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Desc', @value=N'Distinct route' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_DescOfProcessFillingTheTable', @value=N'SQL02 proc imports file \\appfs1\EnterpriseDatabase\Transportation\Hastus\Import\Routexml' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_ETLUpdateStrategy', @value=N'UPD_DEL_INS_FLTR' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Note', @value=N'It can be a view out of HASTURoute table therefore it is a delete candidate.' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SPName', @value=N'HASTUPopulateRoutes' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SQLJobName', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SSISPackageName', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_TableSource', @value=N'Hastus' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_TFSSolutionPackage', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteList'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Desc', @value=N'Types of Route.' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteType'
GO
EXEC sysp_addextendedproperty @name=N'ACT_DescOfProcessFillingTheTable', @value=N'SQL02 proc imports file \\appfs1\EnterpriseDatabase\Transportation\Hastus\Import\Routexml' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteType'
GO
EXEC sysp_addextendedproperty @name=N'ACT_ETLUpdateStrategy', @value=N'UPD_INS_FLTR' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteType'
GO
EXEC sysp_addextendedproperty @name=N'ACT_Note', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteType'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SPName', @value=N'HASTUPopulateRoutes' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteType'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SQLJobName', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteType'
GO
EXEC sysp_addextendedproperty @name=N'ACT_SSISPackageName', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteType'
GO
EXEC sysp_addextendedproperty @name=N'ACT_TableSource', @value=N'Hastus' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteType'
GO
EXEC sysp_addextendedproperty @name=N'ACT_TFSSolutionPackage', @value=N'' , @level0type=N'SCHEMA',@level0name=N'HASTUS', @level1type=N'TABLE',@level1name=N'RouteType'
GO

