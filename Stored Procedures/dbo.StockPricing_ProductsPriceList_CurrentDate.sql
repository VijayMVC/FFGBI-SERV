SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason mcDevitt
-- Create date: 11.06.2014
-- Description:	Get product List for Price changes and Admin
-- =============================================
--exec [ProductsPriceList] '10/13/2014'
Create PROCEDURE [dbo].[StockPricing_ProductsPriceList_CurrentDate]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Select max([ValueFrom]) as PriceListDate
	from Product_Price PP
	where pp.siteid = 7 
	
END
GO
