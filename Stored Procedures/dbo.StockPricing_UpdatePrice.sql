SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason mcDevitt
-- Create date: 11.06.2014
-- Description:	Update Group product Price
-- =============================================
Create PROCEDURE [dbo].[StockPricing_UpdatePrice]
	@ProductCode nvarchar(15),
	@ProductPrice float,
	@ProductEuroPrice float,
	@Startdate datetime  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Update Product_Price
	set  Value = @ProductPrice, EuroValue = @ProductEuroPrice
	where siteid = 7 and ProductCode = @ProductCode and ValueFrom = @Startdate
	
END
GO
