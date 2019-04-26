SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--exec [dbo].[UW_Product_By_Invoice] '294482'
CREATE PROCEDURE [dbo].[UW_Product_By_Invoice]
@Invoice nvarchar(15)
AS
BEGIN

 Select p.ProductCode,pr.[name] as Product,count(p.SSCC)as Qty, cast(sum(p.[Weight]) as decimal(18,2))as Wgt 
 
 
 FROM [FFG_DW].[dbo].[Stock_Packs] p
 inner join [dbo].[Products] pr on p.ProductCode = pr.ProductCode
 
 
 
 
  where p.Productnum = @Invoice
 group by p.ProductCode,pr.[name]

END
GO
