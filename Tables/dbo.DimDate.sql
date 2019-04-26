CREATE TABLE [dbo].[DimDate]
(
[DateKey] [int] NOT NULL,
[Date] [datetime] NULL,
[StandardDate] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[Day] [varchar] (2) COLLATE Latin1_General_CI_AS NULL,
[DaySuffix] [varchar] (4) COLLATE Latin1_General_CI_AS NULL,
[DayName] [varchar] (9) COLLATE Latin1_General_CI_AS NULL,
[DayOfWeek] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[DayOfWeekInMonth] [varchar] (2) COLLATE Latin1_General_CI_AS NULL,
[DayOfWeekInYear] [varchar] (2) COLLATE Latin1_General_CI_AS NULL,
[DayOfQuarter] [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
[DayOfYear] [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
[WeekOfMonth] [varchar] (1) COLLATE Latin1_General_CI_AS NULL,
[WeekOfQuarter] [varchar] (2) COLLATE Latin1_General_CI_AS NULL,
[WeekOfYear] [varchar] (2) COLLATE Latin1_General_CI_AS NULL,
[Month] [varchar] (2) COLLATE Latin1_General_CI_AS NULL,
[MonthName] [varchar] (9) COLLATE Latin1_General_CI_AS NULL,
[MonthOfQuarter] [varchar] (2) COLLATE Latin1_General_CI_AS NULL,
[Quarter] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[QuarterName] [varchar] (9) COLLATE Latin1_General_CI_AS NULL,
[Year] [char] (4) COLLATE Latin1_General_CI_AS NULL,
[YearName] [char] (7) COLLATE Latin1_General_CI_AS NULL,
[MonthYear] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[MMYYYY] [char] (6) COLLATE Latin1_General_CI_AS NULL,
[FirstDayOfMonth] [date] NULL,
[LastDayOfMonth] [date] NULL,
[FirstDayOfQuarter] [date] NULL,
[LastDayOfQuarter] [date] NULL,
[FirstDayOfYear] [date] NULL,
[LastDayOfYear] [date] NULL,
[IsHoliday] [bit] NULL,
[IsWeekday] [bit] NULL,
[Holiday] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FiscalDayOfYear] [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
[FiscalWeekOfYear] [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
[FiscalMonth] [varchar] (2) COLLATE Latin1_General_CI_AS NULL,
[FiscalQuarter] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[FiscalQuarterName] [varchar] (9) COLLATE Latin1_General_CI_AS NULL,
[FiscalYear] [char] (4) COLLATE Latin1_General_CI_AS NULL,
[FiscalYearName] [char] (7) COLLATE Latin1_General_CI_AS NULL,
[FiscalMonthYear] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[FiscalMMYYYY] [char] (6) COLLATE Latin1_General_CI_AS NULL,
[FiscalFirstDayOfMonth] [date] NULL,
[FiscalLastDayOfMonth] [date] NULL,
[FiscalFirstDayOfQuarter] [date] NULL,
[FiscalLastDayOfQuarter] [date] NULL,
[FiscalFirstDayOfYear] [date] NULL,
[FiscalLastDayOfYear] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimDate] ADD CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED  ([DateKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimDate_Date] ON [dbo].[DimDate] ([Date]) INCLUDE ([DateKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndexDateYearMonth] ON [dbo].[DimDate] ([FiscalYear]) INCLUDE ([Date], [FiscalMonth]) ON [PRIMARY]
GO
CREATE STATISTICS [_dta_stat_153767605_1_38] ON [dbo].[DimDate] ([DateKey], [FiscalYear])
GO
