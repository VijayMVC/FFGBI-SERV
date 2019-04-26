SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 19/06/2014
-- Description:	Frozen Report of Omagh
-- =============================================
CREATE PROCEDURE [dbo].[Frozen_Report_Omagh] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @today as datetime
set @Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))




SELECT     pk.OrgSite,
pk.DeviceID, 
pk.InventoryID AS Inventory, 
pr.Name AS Stock, 
CASE WHEN len(mat1.ProductCode) <> 9 THEN 'x'+RIGHT(mat1.ProductCode, 3) ELSE isnull(mat1.ProductCode, 'NONE') END AS BaseProd, 
pk.LotID as CodeLot,
ISNULL(mat1.name, 'NONE') AS BaseDesc, 
pk.KillDate AS Killdate, 
pk.prday AS PackDate, 
DATEDIFF(d, pk.prday, @Today) AS Age, 

  case when DATEDIFF(d, pk.prday, @Today) >= 0 and  DATEDIFF(d, pk.prday, @Today) <= 7 then DATEDIFF(d, pk.prday, @Today) else null end as Age0to7,
					  case when DATEDIFF(d, pk.prday, @Today) >= 8 and  DATEDIFF(d, pk.prday, @Today) <= 30 then DATEDIFF(d, pk.prday, @Today) else null end as Age8to30,
					  case when DATEDIFF(d, pk.prday, @Today) >= 31 and  DATEDIFF(d, pk.prday, @Today) <= 60 then DATEDIFF(d, pk.prday, @Today) else null end as Age1to2Months,
					  case when DATEDIFF(d, pk.prday, @Today) >= 61 and  DATEDIFF(d, pk.prday, @Today) <= 180 then DATEDIFF(d, pk.prday, @Today) else null end as Age3to6Months,
					  case when DATEDIFF(d, pk.prday, @Today) >= 181 and  DATEDIFF(d, pk.prday, @Today) <= 365 then DATEDIFF(d, pk.prday, @Today) else null end as Age6to12Months,
					  case when DATEDIFF(d, pk.prday, @Today) >= 366 and  DATEDIFF(d, pk.prday, @Today) <= 730 then DATEDIFF(d, pk.prday, @Today) else null end as Age1to2years,
					  case when DATEDIFF(d, pk.prday, @Today) >= 731 and  DATEDIFF(d, pk.prday, @Today) <= 1825 then DATEDIFF(d, pk.prday, @Today) else null end as Age2to5Months,
					  case when DATEDIFF(d, pk.prday, @Today) > 1825 then DATEDIFF(d, pk.prday, @Today) else null end as AgeGthan5Years,
           

pk.DNOB AS DNOB, 
pk.UseBy AS Useby, 
ISNULL(col.PalletNumber, ' ') AS Pallet, 
(mat1.ProductCode) AS Product,
mat1.name AS ProductName,
--PP.value AS PricePerKg,
 isnull(PP.value,(select top 1 value from Product_Price where ProductCode = mat1.ProductCode and [ValueTo] = (select max([ValueTo]) from Product_Price where ProductCode = mat1.ProductCode)))   AS PricePerKg, 
mat1.description5 AS PLU, 
mat1.description6 as HiltonType,
ISNULL(con.name, 'N/A') AS Category, 
1 AS Qty, 
ISNULL(pk.weight,0) AS Weight, 
pk.tare AS Tare, 
mat1.materialtype AS type, 
PT.name as TypeName, 
S.Name as [Site],
mat1.[DaysTillExpire],
con.[Priority]





FROM         Stock_Packs AS pk WITH (nolock) INNER JOIN
					Sites S WITH (nolock) on pk.SiteID = S.SiteID  INNER JOIN
                      Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode LEFT JOIN
                      Product_Price as PP with (nolock) on mat1.ProductCode = PP.productcode and pk.siteid = pp.siteid and Getdate() between [ValueFrom] and [ValueTo] Inner JOIN
                      Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site INNER JOIN
                      ProductTypes PT ON mat1.materialtype = pt.ProductTypeID LEFT OUTER JOIN
                      Pallets AS col WITH (nolock) ON pk.PalletID = col.PalletID and pk.siteid = col.siteid
                      LEFT OUTER JOIN
                      ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode left outer join
                      CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID
                      left JOIN Lots lts (nolock) ON lts.LotID=pk.LotID and lts.siteid = pk.siteid 
WHERE  S.Siteid = 2 and   
mat1.storageType = 2 and pr.InventoryTypeID in (1,3) and not(pr.description1 like '%FRESH%')
 
END
GO
