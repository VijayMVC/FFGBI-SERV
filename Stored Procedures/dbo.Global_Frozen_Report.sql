SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 18/06/2014
-- Description:	Frozen Stock report
-- =============================================
CREATE PROCEDURE [dbo].[Global_Frozen_Report] 
	-- Add the parameters for the stored procedure here
	-- exec [dbo].[Global_Frozen_Report] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @today as datetime
declare @MaxValueto as datetime
set @Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))
set @MaxValueto = (select max([ValueTo]) from Product_Price)




SELECT     pk.SiteID,pk.DeviceID,  pk.InventoryID AS Inventory, pr.Name AS Stock, CASE WHEN len(mat1.ProductCode) <> 9 THEN 'x'+RIGHT(mat1.ProductCode, 3) ELSE isnull(mat1.ProductCode, 'NONE') END AS BaseProd, 
                      ISNULL(mat1.name, 'NONE') AS BaseDesc, pk.KillDate AS Killdate, pk.prday AS PackDate, DATEDIFF(d, pk.prday, @Today) AS Age, 
                      pk.DNOB AS DNOB, 
                      pk.UseBy AS Useby, ISNULL(col.PalletNumber, ' ') AS Pallet, (mat1.ProductCode) AS Product, mat1.name AS ProductName, 
                      --PP.value AS PricePerKg,
					isnull(PP.value,(select top 1 value from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid and [ValueTo] = (select max([ValueTo]) from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid)))   AS PricePerKg, 
                      mat1.description5 AS PLU, mat1.description6 as HiltonType,
                      ISNULL(con.name, 'N/A') AS Category, 1 AS Qty, ISNULL(pk.weight,0) AS Weight, pk.tare AS Tare, mat1.materialtype AS type, PT.name as TypeName, S.Name as [Site], con.[Priority]
					  ,[StartingDate],[CurrencyCode] ,[ExchangeRateAmount]
FROM         Stock_Packs AS pk WITH (nolock) INNER JOIN
					Sites S WITH (nolock) on pk.SiteID = S.SiteID  INNER JOIN
                      Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode LEFT JOIN
                      Product_Price as PP with (nolock) on mat1.ProductCode = PP.productcode and pk.siteid = pp.siteid and @MaxValueto between [ValueFrom] and [ValueTo]
                      left join [Currency Exchange] CE with (nolock) on pk.siteid = CE.siteid and startingdate =(select max([StartingDate]) from [Currency Exchange] where CE.siteid = pk.siteid )  Inner JOIN 
					  Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site INNER JOIN
                      ProductTypes PT ON mat1.materialtype = pt.ProductTypeID LEFT OUTER JOIN
                      Pallets AS col WITH (nolock) ON pk.PalletID = col.PalletID and pk.siteid = col.siteid
                      LEFT OUTER JOIN
                      ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode left outer join
                      CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID
                      left JOIN Lots lts (nolock) ON lts.LotID=pk.LotID and lts.siteid = pk.siteid 
WHERE  --S.Siteid = @SiteId and   
mat1.storageType = 2 and pr.InventoryTypeID in (1,3) and not(pr.description1 like '%FRESH%') --and mat1.ProductCode = 901910939 and S.Name = 'Foyle Campsie'


END
GO
