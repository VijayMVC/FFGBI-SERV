SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 15/08/2014
-- Description:	Group summary total of the snapshot of each site
-- =============================================
CREATE PROCEDURE [dbo].[Group_Stock_Snapshot_Fresh_Summary] 
	-- Add the parameters for the stored procedure here

--@Date datetime,
--@site int
AS
BEGIN
declare @today as datetime
,@Weekno as int


--set @weekno = (datepart(wk,@date) )

set @Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))




SELECT  
Sum(ss.ID) as TotalQTY,
Sum(ss.Weight) as TotalWeight,
Sum(isnull(PP.value,0) * isnull(ss.Weight,0)) as TotalValue,
--PP.value AS PricePerKg,
--SUM( isnull(PP.value,(select top 1 value from Product_Price where ProductCode = mat1.ProductCode and [ValueTo] = (select max([ValueTo]) from Product_Price where ProductCode = mat1.ProductCode))) * isnull(ss.Weight,0))   AS  TotalValue,
mat1.ProductCode, 
mat1.name AS ProductName,
ISNULL(con.name, 'N/A') AS Category, 
S.Name as [Site],
con.[priority],
SS.Date as [SnapshotDate],
datepart(wk,ss.date) as Weekno 





FROM dbo.Global_Stock_Snapshot SS with (nolock) inner join    
 Stock_Packs AS pk WITH (nolock) on ss.id = pk.id INNER JOIN
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
                      
WHERE  
mat1.storageType = 1 and pr.InventoryTypeID = 1 and not(pr.description1 like '%FROZEN%')
     
group by ss.id,pk.InventoryID, pr.Name, mat1.ProductCode, pk.LotID,pk.KillDate,pk.prday,pk.UseBy, (mat1.ProductCode),mat1.name,
PP.value,pk.tare, mat1.materialtype, PT.name, S.Name, con.[priority], SS.Date, col.PalletNumber,con.name,pk.weight

end
GO
