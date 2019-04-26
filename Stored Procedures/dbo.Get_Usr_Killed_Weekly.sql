SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Glen DUncan
-- Create date: 12/06/2018
-- Description:	Get Weekly Killed Data
-- =============================================
CREATE PROCEDURE [dbo].[Get_Usr_Killed_Weekly] 
AS
BEGIN
	SELECT 
		DATES.FiscalYear,
		DATES.FiscalMonth,
		DATES.FiscalWeekOfYear,
		cast(DATES.FiscalYear as varchar) + RIGHT('0'+cast(DATES.FiscalWeekOfYear as varchar),2)fiscalyearweek,
		DATES.FiscalFirstDayOfMonth,
		NC.[Site Dimension],
		count(distinct factory)cattle_count,
--		SUM(CASE WHEN (NC.[Order] not like '99%' and nc.[Totally Condemed] <>1 and nc.[Own Kill] <>1 and NC.[Order] <> '') THEN NC.[Cold Weight (KG)] END)KG_weight
		SUM(NC.[Cold Weight (KG)])KG_weight
		--379790.9
	FROM 
		[Z_Usr_NetCost] NC
		INNER JOIN DimDate DATES on NC.[Posting Date] = DATES.Date
	WHERE
		1=1
	GROUP BY
		DATES.FiscalYear,
		DATES.FiscalMonth,
		DATES.FiscalFirstDayOfMonth,
		DATES.FiscalWeekOfYear,
		NC.[Site Dimension]
		
END

GO
