USE [EmployeeDW]
GO
/****** Object:  Table [dbo[EmployeesLocation]    Script Date: 11/16/2017 3:53:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo[EmployeesLocation] (
    [EmployeesLocationId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [Badge]               VARCHAR (6)   NOT NULL,
    [EmployeeName]        VARCHAR (50)  NULL,
    [BeginEffDate]        DATE          NOT NULL,
    [EndEffDate]          DATE          NOT NULL,
    [Empl_Status]         CHAR (1)      NOT NULL,
    [FirstName]           VARCHAR (50)  NULL,
    [MiddleName]          VARCHAR (30)  NULL,
    [LastName]            VARCHAR (70)  NULL,
    [Location]            VARCHAR (10)  NULL,
    [Per_Org]             VARCHAR (5)   NULL,
    [AddUserId]           VARCHAR (50)  CONSTRAINT [DF_EmployeesLocation_AddUserId] DEFAULT (suser_name()) NOT NULL,
    [AddDateTime]         DATETIME2 (7) CONSTRAINT [DF_EmployeesLocation_AddDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [UpdUserId]           VARCHAR (50)  CONSTRAINT [DF_EmployeesLocation_UpdUserId] DEFAULT (suser_name()) NOT NULL,
    [UpdDateTime]         DATETIME2 (7) CONSTRAINT [DF_EmployeesLocation_UpdDateTime] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [EmployeesLocation_PK] PRIMARY KEY CLUSTERED ([EmployeesLocationId] ASC)
);
GO

CREATE NONCLUSTERED INDEX [IX_EmployeesLocation_Badge]
    ON [dbo[EmployeesLocation]([Badge] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_EmployeesLocation_EndEffDate_Filtered_99991231]
    ON [dbo[EmployeesLocation]([EndEffDate] ASC)
    INCLUDE([Badge], [EmployeeName], [BeginEffDate], [Empl_Status], [FirstName], [LastName], [Location], [Per_Org]) WHERE ([EndEffDate]='9999-12-31');
GO


CREATE TABLE [dbo[Department] (
    [DepartmentId] VARCHAR (10)  NOT NULL,
    [DeptName]     VARCHAR (30)  NOT NULL,
    [Location]     VARCHAR (12)  NOT NULL,
    [KPIReport]    BIT           CONSTRAINT [DF_Department_KPIReport] DEFAULT (NULL) NULL,
    [ValidFrom]    DATE          CONSTRAINT [DF_Department_ValidFrom] DEFAULT (sysdatetime()) NOT NULL,
    [ValidUntil]   DATE          CONSTRAINT [DF_Department_ValidUntil] DEFAULT ('99991231 23:59:59.9999999') NOT NULL,
    [AddUserId]    VARCHAR (50)  CONSTRAINT [DF_Department_AddUserId] DEFAULT (suser_name()) NOT NULL,
    [AddDateTime]  DATETIME2 (7) CONSTRAINT [DF_Department_AddDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [UpdUserId]    VARCHAR (50)  CONSTRAINT [DF_Department_UpdUserId] DEFAULT (suser_name()) NOT NULL,
    [UpdDateTime]  DATETIME2 (7) CONSTRAINT [DF_Department_UpdDateTime] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [Department_PK] PRIMARY KEY CLUSTERED ([DepartmentId] ASC)
);
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo[MSSQL_TemporalHistoryFor_1848497764] (
    [Emp_Id]                      INT            NOT NULL,
    [Badge]                       VARCHAR (6)    NOT NULL,
    [ETLDateTime]                 DATETIME2 (7)  NOT NULL,
    [Name]                        VARCHAR (50)   NOT NULL,
    [FirstName]                   VARCHAR (50)   NULL,
    [LastName]                    VARCHAR (50)   NULL,
    [MiddleName]                  VARCHAR (30)   NULL,
    [Suffix]                      VARCHAR (10)   NULL,
    [Pref_Name]                   VARCHAR (30)   NULL,
    [NTLogin]                     VARCHAR (50)   NULL,
    [Hire_Dt]                     DATETIME       NULL,
    [HireTime]                    TIME (7)       NULL,
    [Rehire_Dt]                   DATETIME       NULL,
    [BusDriverQualDate]           DATETIME       NULL,
    [BusDriverQualTime]           TIME (7)       NULL,
    [LastWorkDate]                DATETIME       NULL,
    [BirthDate]                   DATETIME       NULL,
    [Address01]                   VARCHAR (35)   NULL,
    [Address02]                   VARCHAR (35)   NULL,
    [City]                        VARCHAR (30)   NULL,
    [State]                       VARCHAR (6)    NULL,
    [ZIP]                         VARCHAR (10)   NULL,
    [PreferredPhone]              VARCHAR (24)   NULL,
    [WorkPhone]                   VARCHAR (24)   NULL,
    [CellPhone]                   VARCHAR (26)   NULL,
    [EmailAddress]                VARCHAR (50)   NULL,
    [Empl_Status]                 VARCHAR (1)    NOT NULL,
    [DeptId]                      VARCHAR (10)   NOT NULL,
    [DeptName]                    VARCHAR (30)   NOT NULL,
    [Location]                    VARCHAR (10)   NULL,
    [Company]                     VARCHAR (3)    NOT NULL,
    [JobCode]                     VARCHAR (6)    NOT NULL,
    [PayGroup]                    VARCHAR (3)    NOT NULL,
    [JobTitle]                    VARCHAR (30)   NOT NULL,
    [BusinessTitle]               VARCHAR (30)   NULL,
    [Empl_Type]                   VARCHAR (1)    NOT NULL,
    [RegTempFlag]                 VARCHAR (1)    NULL,
    [FT_PT_Flag]                  VARCHAR (1)    NULL,
    [Per_Org]                     VARCHAR (5)    NULL,
    [SupervisorId]                VARCHAR (11)   NULL,
    [SupervisorName]              VARCHAR (55)   NULL,
    [Action]                      VARCHAR (3)    NULL,
    [ActionDate]                  DATETIME       NULL,
    [ActionReason]                VARCHAR (3)    NULL,
    [TermDate]                    DATETIME       NULL,
    [UnionCode]                   VARCHAR (3)    NULL,
    [EEO4Code]                    VARCHAR (1)    NULL,
    [EEOJobGroup]                 VARCHAR (2)    NULL,
    [CompFrequency]               VARCHAR (1)    NULL,
    [CompRate]                    MONEY          NULL,
    [AnnualRate]                  MONEY          NULL,
    [MonthlyRate]                 MONEY          NULL,
    [HourlyRate]                  MONEY          NULL,
    [Grade]                       VARCHAR (3)    NULL,
    [Step]                        VARCHAR (2)    NULL,
    [PositionNumber]              VARCHAR (8)    NULL,
    [PositionEntryDate]           DATETIME       NULL,
    [Sex]                         VARCHAR (1)    NOT NULL,
    [EthnicGroup]                 VARCHAR (8)    NULL,
    [Veteran]                     VARCHAR (1)    NULL,
    [Citizen]                     VARCHAR (1)    NULL,
    [Disabled]                    VARCHAR (2)    NULL,
    [Marital]                     VARCHAR (1)    NULL,
    [AsOfDate]                    DATETIME       NULL,
    [EffectiveDate]               DATETIME       NULL,
    [VacHoursEntitlement]         DECIMAL (6, 2) NULL,
    [VacHoursCarryover]           DECIMAL (6, 2) NULL,
    [DriverLicenseNumber]         VARCHAR (20)   NULL,
    [DriverLicenseExpirationDate] DATE           NULL,
    [MedicalExpirationDate]       DATE           NULL,
    [StepStartDate]               DATE           NULL,
    [WorkShift]                   VARCHAR (30)   NULL,
    [ScheduledDaysOff]            VARCHAR (27)   NULL,
    [PSBadge]                     VARCHAR (7)    NULL,
    [AddUserId]                   VARCHAR (50)   NULL,
    [AddDateTime]                 DATETIME       NULL,
    [UpdatedBy]                   VARCHAR (75)   NULL,
    [UpdatedOn]                   DATETIME       NULL,
    [SecurityCardFormatted]       VARCHAR (10)   NULL,
    [SecurityCardNumber]          VARCHAR (20)   NULL,
    [SecurityCardEnabled]         BIT            NULL,
    [SecurityCardEncoded]         DECIMAL (24)   NULL,
    [SecurityETLDateTime]         DATETIME2 (7)  NULL,
    [ServiceDate]                 DATE           NULL,
    [VTTExpirationDate]           DATE           NULL,
    [FutureSuspensionDate]        DATE           NULL,
    [DMVClearanceDate]            DATE           NULL,
    [ValidFrom]                   DATETIME2 (7)  NOT NULL,
    [ValidUntil]                  DATETIME2 (7)  NOT NULL,
    [BadgeAlpha]                  VARCHAR (6)    NULL,
    [BusDriverFTHireDate]         DATETIME2 (0)  NULL,
    [BusDriverFTHireTime]         TIME (0)       NULL,
    [DMVComment]                  VARCHAR (250)  NULL,
    [EmergencyAlertPhone]         VARCHAR (24)   NULL,
    [EmergencyAlertEmail]         VARCHAR (70)   NULL
);
GO

CREATE CLUSTERED INDEX [ix_MSSQL_TemporalHistoryFor_1848497764]
    ON [dbo[MSSQL_TemporalHistoryFor_1848497764]([ValidUntil] ASC, [ValidFrom] ASC) WITH (DATA_COMPRESSION = PAGE);
GO


CREATE TABLE [dbo[Employees] (
    [Emp_Id]                      INT                                         IDENTITY (1, 1) NOT NULL,
    [Badge]                       VARCHAR (6)                                 NOT NULL,
    [ETLDateTime]                 DATETIME2 (7)                               CONSTRAINT [DF_Employees_ETLDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [Name]                        VARCHAR (50)                                NOT NULL,
    [FirstName]                   VARCHAR (50)                                NULL,
    [LastName]                    VARCHAR (50)                                NULL,
    [MiddleName]                  VARCHAR (30)                                NULL,
    [Suffix]                      VARCHAR (10)                                NULL,
    [Pref_Name]                   VARCHAR (30)                                NULL,
    [NTLogin]                     VARCHAR (50)                                NULL,
    [Hire_Dt]                     DATETIME                                    NULL,
    [HireTime]                    TIME (7)                                    NULL,
    [Rehire_Dt]                   DATETIME                                    NULL,
    [BusDriverQualDate]           DATETIME                                    NULL,
    [BusDriverQualTime]           TIME (7)                                    NULL,
    [LastWorkDate]                DATETIME                                    NULL,
    [BirthDate]                   DATETIME                                    NULL,
    [Address01]                   VARCHAR (35)                                NULL,
    [Address02]                   VARCHAR (35)                                NULL,
    [City]                        VARCHAR (30)                                NULL,
    [State]                       VARCHAR (6)                                 NULL,
    [ZIP]                         VARCHAR (10)                                NULL,
    [PreferredPhone]              VARCHAR (24)                                NULL,
    [WorkPhone]                   VARCHAR (24)                                NULL,
    [CellPhone]                   VARCHAR (26)                                NULL,
    [EmailAddress]                VARCHAR (50)                                NULL,
    [Empl_Status]                 VARCHAR (1)                                 NOT NULL,
    [DeptId]                      VARCHAR (10)                                NOT NULL,
    [DeptName]                    VARCHAR (30)                                NOT NULL,
    [Location]                    VARCHAR (10)                                NULL,
    [Company]                     VARCHAR (3)                                 NOT NULL,
    [JobCode]                     VARCHAR (6)                                 NOT NULL,
    [PayGroup]                    VARCHAR (3)                                 NOT NULL,
    [JobTitle]                    VARCHAR (30)                                NOT NULL,
    [BusinessTitle]               VARCHAR (30)                                NULL,
    [Empl_Type]                   VARCHAR (1)                                 NOT NULL,
    [RegTempFlag]                 VARCHAR (1)                                 NULL,
    [FT_PT_Flag]                  VARCHAR (1)                                 NULL,
    [Per_Org]                     VARCHAR (5)                                 NULL,
    [SupervisorId]                VARCHAR (11)                                NULL,
    [SupervisorName]              VARCHAR (55)                                NULL,
    [Action]                      VARCHAR (3)                                 NULL,
    [ActionDate]                  DATETIME                                    NULL,
    [ActionReason]                VARCHAR (3)                                 NULL,
    [TermDate]                    DATETIME                                    NULL,
    [UnionCode]                   VARCHAR (3)                                 NULL,
    [EEO4Code]                    VARCHAR (1)                                 NULL,
    [EEOJobGroup]                 VARCHAR (2)                                 NULL,
    [CompFrequency]               VARCHAR (1)                                 NULL,
    [CompRate]                    MONEY                                       NULL,
    [AnnualRate]                  MONEY                                       NULL,
    [MonthlyRate]                 MONEY                                       NULL,
    [HourlyRate]                  MONEY                                       NULL,
    [Grade]                       VARCHAR (3)                                 NULL,
    [Step]                        VARCHAR (2)                                 NULL,
    [PositionNumber]              VARCHAR (8)                                 NULL,
    [PositionEntryDate]           DATETIME                                    NULL,
    [Sex]                         VARCHAR (1)                                 NOT NULL,
    [EthnicGroup]                 VARCHAR (8)                                 NULL,
    [Veteran]                     VARCHAR (1)                                 NULL,
    [Citizen]                     VARCHAR (1)                                 NULL,
    [Disabled]                    VARCHAR (2)                                 NULL,
    [Marital]                     VARCHAR (1)                                 NULL,
    [AsOfDate]                    DATETIME                                    NULL,
    [EffectiveDate]               DATETIME                                    NULL,
    [VacHoursEntitlement]         DECIMAL (6, 2)                              NULL,
    [VacHoursCarryover]           DECIMAL (6, 2)                              NULL,
    [DriverLicenseNumber]         VARCHAR (20)                                NULL,
    [DriverLicenseExpirationDate] DATE                                        NULL,
    [MedicalExpirationDate]       DATE                                        NULL,
    [StepStartDate]               DATE                                        NULL,
    [WorkShift]                   VARCHAR (30)                                NULL,
    [ScheduledDaysOff]            VARCHAR (27)                                NULL,
    [PSBadge]                     VARCHAR (7)                                 NULL,
    [AddUserId]                   VARCHAR (50)                                NULL,
    [AddDateTime]                 DATETIME                                    NULL,
    [UpdatedBy]                   VARCHAR (75)                                NULL,
    [UpdatedOn]                   DATETIME                                    NULL,
    [SecurityCardFormatted]       VARCHAR (10)                                NULL,
    [SecurityCardNumber]          VARCHAR (20)                                NULL,
    [SecurityCardEnabled]         BIT                                         NULL,
    [SecurityCardEncoded]         DECIMAL (24)                                NULL,
    [SecurityETLDateTime]         DATETIME2 (7)                               NULL,
    [ServiceDate]                 DATE                                        NULL,
    [VTTExpirationDate]           DATE                                        NULL,
    [FutureSuspensionDate]        DATE                                        NULL,
    [DMVClearanceDate]            DATE                                        NULL,
    [ValidFrom]                   DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_Employees_ValidFrom] DEFAULT (sysdatetime()) NOT NULL,
    [ValidUntil]                  DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_Employees_ValidUntil] DEFAULT ('99991231 23:59:59.9999999') NOT NULL,
    [BadgeAlpha]                  VARCHAR (6)                                 NULL,
    [BusDriverFTHireDate]         DATETIME2 (0)                               NULL,
    [BusDriverFTHireTime]         TIME (0)                                    NULL,
    [DMVComment]                  VARCHAR (250)                               NULL,
    [EmergencyAlertPhone]         VARCHAR (24)                                NULL,
    [EmergencyAlertEmail]         VARCHAR (70)                                NULL,
    CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED ([Emp_Id] ASC),
    CONSTRAINT [UK_Employees_Badge] UNIQUE NONCLUSTERED ([Badge] ASC),
    PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidUntil])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[dbo[MSSQL_TemporalHistoryFor_1848497764], DATA_CONSISTENCY_CHECK=ON));
GO


/****** Object:  View [dbo[EmployeeAll]    Script Date: 11/16/2017 3:53:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo[EmployeeAll]
AS
SELECT 
	/*
		Empl_Status 

		R=Retired  
		A=Active  
		L=Leave   
		U=Terminated with pay
		Q=Retired with pay 
		D=Deceased  
		P=Leave with Pay 
		S=Suspension 
		T=Terminated
	*/
	 Badge 
    ,FirstName + ' ' + ISNULL( NULLIF(MiddleName,'') + ' ' ,'') + LastName EmployeeName

	,FirstName 
	,LastName 
	,Location 
	,RTRIM(LEFT(Location,3)) Division
	,Per_Org 
	,e.Suffix 
	,e.NTLogin 
	,Empl_Status  
	,ISNULL(e.DeptName,RTRIM(LEFT(Location,3))) DeptName
	,BeginEffDate
	,EndEffDate
	,EmployeesLocationId
	,CASE WHEN e.Badge IS NOT NULL THEN 1 ELSE 0 END InEmpTable
	,e.JobTitle
	,e.StepStartDate
	,e.WorkShift
	,e.ScheduledDaysOff	
	,e.PSBadge
    ,ISNULL(e.Pref_Name,FirstName) + ' ' + LastName PreferredEmployeeName
	,e.Pref_Name PreferredFirstName
	,e.Pref_Name
	,MiddleName
	,e.Hire_Dt
	,e.HireTime
	,e.Rehire_Dt
	,e.LastWorkDate
	,e.PreferredPhone
	,e.WorkPhone
	,e.EmailAddress
	,e.DeptId
	,e.JobCode
	,e.BusinessTitle
	,e.Empl_Type
	,e.RegTempFlag
	,e.FT_PT_Flag
	,e.SupervisorId
	,e.SupervisorName
	,e.BadgeAlpha

FROM dbo.EmployeesLocation l
LEFT JOIN dbo.Employees e ON Badge = e.Badge
WHERE EndEffDate = '9999-12-31';
GO


