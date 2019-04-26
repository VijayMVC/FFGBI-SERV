SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dbo].[Z_DimDate_Allocation_V]
AS


SELECT 
	[DateKey],
    [Date],
    [Day],
    [DayName],
    [DayOfWeek],
    [DayOfWeekInMonth],
    [DayOfYear],
    [WeekOfMonth],
    [WeekOfYear],
    [Month],
    [MonthName],
    [Year],
    [MonthYear],
    [MMYYYY]
FROM 
	[FFG_DW].[dbo].[DimDate]


GO
