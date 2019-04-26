SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason mcDevitt
-- Create date: 11.06.2014
-- Description:	Create a New Product Price List for the current week
-- =============================================
--exec  [NewPriceList] '10/13/2014',0
Create PROCEDURE [dbo].[StockPricing_NewPriceList]
@StartDate Datetime	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--Site 7 is used a temporary site id 
	--untill all the Prices are merged across the group
 if (select count(*)
	  FROM [FFG_DW].[dbo].[Product_Price]
	  where siteID = 7 and [Valuefrom] = @StartDate ) = 0 
	Begin
		
	  Insert into Product_Price
	  (ProductCode,SiteID,ValueFrom,ValueTo)
	  select distinct productcode,7,@StartDate,@StartDate + 6 from Stock_Packs
		
		Update  PP
		set PP.value = PP2.Value, PP.EuroValue = PP2.EuroValue
		from Product_Price PP
		inner Join Product_Price PP2 
		on PP.ProductCode = PP2.ProductCode and PP.SiteID = PP2.SiteID   
		where PP2.ValueFrom = @StartDate -7
		and PP.ValueFrom = @StartDate and PP.SiteID = 7
		
		Update Product_Price
		set value = 0
		where Value is Null and ValueFrom = @StartDate and SiteID = 7
		
		Update Product_Price
		set EuroValue = 0
		where EuroValue is Null and ValueFrom = @StartDate and SiteID = 7
	end
	
END
GO
