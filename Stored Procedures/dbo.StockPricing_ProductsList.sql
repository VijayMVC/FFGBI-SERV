SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason mcDevitt
-- Create date: 11.06.2014
-- Description:	Get product List for Price changes and Admin
-- =============================================
CREATE PROCEDURE [dbo].[StockPricing_ProductsList]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Select P.ProductCode,P.Name,P.FabCode1 as MeatType,P.FabCode2 as ProductType, PP.Value, PP.[ValueFrom], PP.[ValueTo]

	from Products P
	inner join Product_Price PP on P.ProductCode = PP.ProductCode and (select max([ValueFrom]) from Product_Price where ProductCode = PP.ProductCode) between valuefrom and valueto
	where pp.siteid = 2
END
GO
