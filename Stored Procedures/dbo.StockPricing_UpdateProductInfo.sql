SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason mcDevitt
-- Create date: 11.06.2014
-- Description:	Update Group product Price
-- =============================================
--[StockPricing_UpdateProductInfo] '100110015',0,1,'STG'
CREATE PROCEDURE [dbo].[StockPricing_UpdateProductInfo]
	@ProductCode nvarchar(15),
	@SalesTeamID int,
	@UpDateNav bit,
	@PricedCurrency nvarchar(10)  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Declare @count int
	
	select @count = count(*) from Product_Info where ProductCode = @ProductCode
	
	If(@count > 0 )
		begin
			
			Update Product_Info
			set  SalesTeamID = Case when @SalesTeamID = 0 then null else @SalesTeamID end , UpdateNav = @UpDateNav,PricedCurrency = @PricedCurrency
			where ProductCode = @ProductCode 
		end
	else
		begin
			Insert Into Product_Info
			select @ProductCode, @SalesTeamID,@UpDateNav,@PricedCurrency
		end
END
GO
