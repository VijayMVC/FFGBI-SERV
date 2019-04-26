SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason mcDevitt
-- Create date: 11.06.2014
-- Description:	Get FFG Exchange Rate from FFG Group Company in Nav
-- =============================================
--exec  [StockPricing_GetExchangeRate] '11/10/2014'
CREATE PROCEDURE [dbo].[StockPricing_GetExchangeRate]
@StartDate Datetime	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--Site 7 is used a temporary site id 
	--untill all the Prices are merged across the group
 select cast([Exchange Rate Amount] as decimal (18,3))
 --, *
 FROM [FM_NAVSERV].[FM-Production].[dbo].[FOYLE GROUP - LIVE$Currency Exchange Rate]
 where  [starting Date] = @StartDate - 2 
 and [Currency Code] = 'EUR'
END
GO
