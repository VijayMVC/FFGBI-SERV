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
CREATE PROCEDURE [dbo].[StockPricing_GetNewProducts]
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
	  where siteID = 7 and [Valuefrom] = @StartDate ) > 0 
	Begin
		
	  Insert into Product_Price
	  (ProductCode,SiteID,ValueFrom,ValueTo)
	  select distinct SP.productcode,7,@StartDate,@StartDate + 6 
		from Stock_Packs SP
		where not exists (select * from Product_Price PP 
					where PP.SiteID = 7 and PP.ProductCode = SP.ProductCode and PP.ValueFrom = @StartDate)
		
		Update Product_Price
		set value = 0
		where Value is Null and ValueFrom = @StartDate and SiteID = 7
		
		Update Product_Price
		set EuroValue = 0
		where EuroValue is Null and ValueFrom = @StartDate and SiteID = 7
	end
	
END
GO
