SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Glen DUncan
-- Create date: 11/06/2018
-- Description:	Get data from [FFGSQL02].[FFG-Production].[dbo].[Usr_NetCost] into Z_Usr_NetCost table in Target
-- =============================================
CREATE PROCEDURE [dbo].[Get_Usr_NetCost_Data] 
AS
BEGIN
	--get Casualty data
	SELECT 
		[primary Key],
		ISNULL(a_weight,0)+ISNULL(b_weight,0) KG_weight
	INTO 
		#tmp_casulaty_weight
	FROM 
		[FFGSQL02].[FFG-Production].[dbo].[FFG LIVE$Producer Payment Line Log]
	WHERE 
		a_weight  = 2 
		or b_weight = 2 
	
	TRUNCATE TABLE 
		[dbo].[Z_Usr_NetCost]
	
	INSERT INTO 
		[dbo].[Z_Usr_NetCost]
	SELECT
		NC.[Site Dimension],
		NC.[factory],
		NC.Sex,
		NC.[Cold Weight (KG)],
		--ISNULL(CAS_WGT.KG_weight*.98,NC.[Cold Weight (KG)])[Cold Weight (KG)],
		NC.[Net Cost],
		NC.[Order],
		NC.[Totally Condemed],
		NC.[Own Kill],
		NC.[Posting Date]
	FROM
		[FFGSQL02].[FFG-Production].[dbo].[Usr_NetCost] NC
		--LEFT JOIN #tmp_casulaty_weight CAS_WGT on NC.[primary Key] = CAS_WGT.[primary Key]
	WHERE
		NC.[Posting Date] >= '2016-12-31'
		--and [order] not like '99%'
		AND [Order] not like '9%'
		--and [Totally Condemed] <> (Finance excluded on 30/08/2018)
		and [Own Kill] <>1
		and [order] <>' '
	IF OBJECT_ID('tempdb..#tmp_casulaty_weight') IS NOT NULL
		DROP TABLE #tmp_casulaty_weight
END


GO
