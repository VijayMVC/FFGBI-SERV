SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Glen DUncan
-- Create date: 12/06/2018
-- Description:	Get Weekly Boned Data
-- =============================================
CREATE PROCEDURE [dbo].[Get_Usr_Boned_Weekly] 
AS
BEGIN
	--Boned
	SELECT 
	*
FROM
	(
	SELECT 
		BONED.FiscalYear,
		BONED.FiscalMonth,
		BONED.FiscalWeekOfYear,
		--cast(BONED.FiscalYear as varchar) + RIGHT('0'+cast(BONED.FiscalWeekOfYear as varchar),2)fiscalyearweek,
	--	BONED.FiscalFirstDayOFWeek ,
		BONED.FiscalFirstDayOfMonth,
		BONED.FFGSite,
		sum([Cold Weight])cold_weight,
		sum([quarter_weight]) kilos_boned,
		sum([quarter_weight])/sum([Quarters Boned]) weekly_avg_weight_per_kilo,
		sum([Quarters Boned])quarters_boned,
		--sum([Quarters Boned])/4 cattle_count,
		--COUNT(DISTINCT KillNo)cattle_count,
		SUM([Paid Price £]) [Paid Price £],
		SUM([Paid Animal Price £])[Paid Animal Price £]
	FROM
		(
		SELECT 
			DATES.[FiscalYear],				
			DATES.[FiscalMonth],
			DATES.FiscalFirstDayOfMonth,
			DATES.FiscalWeekOfYear,
		--	MIN(DATES.Date)FiscalFirstDayOFWeek,
			--CAST(COST_DATA.txdate as date) as [Date],
			CASE WHEN COST_DATA.FFGSite = 'FG' THEN 'FGL' ELSE COST_DATA.FFGSite END FFGSite,
			LTRIM(rtrim(COST_DATA.sex)) as [Sex],
			COST_DATA.KillNo,
			COST_DATA.PaidPrice,
			COST_DATA.PaidPrice*(COST_DATA.NavHotWeight*0.98) as [Paid for animal],
			COST_DATA.AvgPrice,
			case when COST_DATA.Curr <>'STG' then (COST_DATA.PaidPrice/EX_RATE.[exchange rate amount]) else COST_DATA.[PaidPrice] end as [Paid Price £],
			case when COST_DATA.Curr <>'STG' then (COST_DATA.PaidPrice/EX_RATE.[exchange rate amount])*(COST_DATA.NavHotWeight*0.98) else COST_DATA.[PaidPrice]*(COST_DATA.NavHotWeight*0.98)  end as [Paid Animal Price £],
			(COST_DATA.NavHotWeight*0.98) as [Cold Weight],
			count(COST_DATA.qtr) as [Quarters Boned],
			SUM(ISNULL(HqWgt,0)) +SUM(ISNULL(FqWgt,0))quarter_weight
		FROM 
			[ffgUtilities].[dbo].[usr_CostData_DW] COST_DATA with (nolock)
			LEFT JOIN FFG_DW.dbo.DimDate DATES on DATES.Date = CAST(COST_DATA.txdate as date)
			LEFT JOIN FFG_DW.dbo.DimExchangeRate EX_RATE with(nolock) on DATES.Datekey  = EX_RATE.Datekey
				and EX_RATE.[Currency Code]='eur'
		WHERE
			CAST(COST_DATA.txdate as date) >= '2016-12-31'
			--and KillNo = 12740
		GROUP BY 
			--CAST(COST_DATA.txdate as date),
			COST_DATA.FFGSite,
			LTRIM(rtrim(COST_DATA.sex)), 
			COST_DATA.KillNo,
			COST_DATA.PaidPrice,
			COST_DATA.AvgPrice,
			COST_DATA.NavHotWeight*0.98,
			COST_DATA.Curr,
			EX_RATE.[exchange rate amount],
			DATES.[FiscalYear],				
			DATES.[FiscalMonth],
			DATES.FiscalFirstDayOfMonth,
			DATES.FiscalWeekOfYear
		)Boned
	WHERE
		1=1
	GROUP BY
		BONED.fiscalyear,
		BONED.FiscalMonth,
		BONED.FiscalFirstDayOfMonth,
		BONED.FiscalWeekOfYear,
		--BONED.FiscalFirstDayOFWeek,
		BONED.FFGSite
	) MAIN
	LEFT JOIN  
	( 
		SELECT 
			DATES.[FiscalYear],				
			DATES.[FiscalMonth],
			DATES.FiscalFirstDayOfMonth,
			DATES.FiscalWeekOfYear,
			CASE WHEN COST_DATA.FFGSite = 'FG' THEN 'FGL' ELSE COST_DATA.FFGSite END FFGSite,
			COUNT(DISTINCT COST_DATA.KillNo) cattle_count
		FROM 
			[ffgUtilities].[dbo].[usr_CostData_DW] COST_DATA with (nolock)
			LEFT JOIN FFG_DW.dbo.DimDate DATES on DATES.Date = CAST(COST_DATA.txdate as date)
			LEFT JOIN FFG_DW.dbo.DimExchangeRate EX_RATE with(nolock) on DATES.Datekey  = EX_RATE.Datekey
				and EX_RATE.[Currency Code]='eur'
		WHERE
			CAST(COST_DATA.txdate as date) >= '2016-12-31'
		GROUP BY 
			COST_DATA.FFGSite,
			DATES.[FiscalYear],				
			DATES.[FiscalMonth],
			DATES.FiscalFirstDayOfMonth,
			DATES.FiscalWeekOfYear
		)CC on MAIN.[FiscalYear] = CC.[FiscalYear]		
			AND MAIN.[FiscalMonth] = CC.[FiscalMonth]
			AND MAIN.FiscalFirstDayOfMonth = CC.FiscalFirstDayOfMonth
			AND MAIN.FiscalWeekOfYear = CC.FiscalWeekOfYear
			AND MAIN.FFGSite= CC.FFGSite
			
--SELECT 
--	BONED.FiscalYear,
--	BONED.FiscalMonth,
--	BONED.FiscalWeekOfYear,
--	--cast(BONED.FiscalYear as varchar) + RIGHT('0'+cast(BONED.FiscalWeekOfYear as varchar),2)fiscalyearweek,
--	BONED.FiscalFirstDayOFWeek ,
--	BONED.FiscalFirstDayOfMonth,
--	BONED.FFGSite,
--	sum([Cold Weight])cold_weight,
--	sum([quarter_weight]) kilos_boned,
--	sum([quarter_weight])/sum([Quarters Boned]) weekly_avg_weight_per_kilo,
--	sum([Quarters Boned])quarters_boned,
--	--sum([Quarters Boned])/4 cattle_count,
--	COUNT(DISTINCT KillNo)cattle_count,
--	SUM([Paid Price £]) [Paid Price £],
--	SUM([Paid Animal Price £])[Paid Animal Price £]
--FROM
--	(
--	SELECT 
--		DATES.[FiscalYear],				
--		DATES.[FiscalMonth],
--		DATES.FiscalFirstDayOfMonth,
--		DATES.FiscalWeekOfYear,
--		MIN(DATES.Date)FiscalFirstDayOFWeek,
--		--CAST(COST_DATA.txdate as date) as [Date],
--		CASE WHEN COST_DATA.FFGSite = 'FG' THEN 'FGL' ELSE COST_DATA.FFGSite END FFGSite,
--		LTRIM(rtrim(COST_DATA.sex)) as [Sex],
--		COST_DATA.KillNo,
--		COST_DATA.PaidPrice,
--		COST_DATA.PaidPrice*(COST_DATA.NavHotWeight*0.98) as [Paid for animal],
--		COST_DATA.AvgPrice,
--		case when COST_DATA.Curr <>'STG' then (COST_DATA.PaidPrice/EX_RATE.[exchange rate amount]) else COST_DATA.[PaidPrice] end as [Paid Price £],
--		case when COST_DATA.Curr <>'STG' then (COST_DATA.PaidPrice/EX_RATE.[exchange rate amount])*(COST_DATA.NavHotWeight*0.98) else COST_DATA.[PaidPrice]*(COST_DATA.NavHotWeight*0.98)  end as [Paid Animal Price £],
--		(COST_DATA.NavHotWeight*0.98) as [Cold Weight],
--		count(COST_DATA.qtr) as [Quarters Boned],
--		SUM(ISNULL(HqWgt,0)) +SUM(ISNULL(FqWgt,0))quarter_weight
--	FROM 
--		[ffgUtilities].[dbo].[usr_CostData_DW] COST_DATA with (nolock)
--		LEFT JOIN FFG_DW.dbo.DimDate DATES on DATES.Date = CAST(COST_DATA.txdate as date)
--		LEFT JOIN FFG_DW.dbo.DimExchangeRate EX_RATE with(nolock) on DATES.Datekey  = EX_RATE.Datekey
--			and EX_RATE.[Currency Code]='eur'
--	WHERE
--		CAST(COST_DATA.txdate as date) >= '2016-12-31'
--		--and KillNo = 12740
--	GROUP BY 
--		--CAST(COST_DATA.txdate as date),
--		COST_DATA.FFGSite,
--		LTRIM(rtrim(COST_DATA.sex)), 
--		COST_DATA.KillNo,
--		COST_DATA.PaidPrice,
--		COST_DATA.AvgPrice,
--		COST_DATA.NavHotWeight*0.98,
--		COST_DATA.Curr,
--		EX_RATE.[exchange rate amount],
--		DATES.[FiscalYear],				
--		DATES.[FiscalMonth],
--		DATES.FiscalFirstDayOfMonth,
--		DATES.FiscalWeekOfYear
--	)Boned
--WHERE
--	1=1
--GROUP BY
--	BONED.fiscalyear,
--	BONED.FiscalMonth,
--	BONED.FiscalFirstDayOfMonth,
--	BONED.FiscalWeekOfYear,
--	BONED.FiscalFirstDayOFWeek,
--	BONED.FFGSite
END

GO
