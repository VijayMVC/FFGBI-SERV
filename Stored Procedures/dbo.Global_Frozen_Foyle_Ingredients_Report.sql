SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 10/10/2014
-- Description:	Foyle Ingredients report
-- =============================================
CREATE PROCEDURE [dbo].[Global_Frozen_Foyle_Ingredients_Report] 
	-- Add the parameters for the stored procedure here


AS
BEGIN
declare @today as datetime
declare @CampsieDate as datetime, @OmaghDate as datetime, @HiltonDate as datetime, @DonegalDate datetime, 
@GloucesterDate datetime, @MeltonDate datetime,@Maxdate as datetime
declare @MaxValueto as datetime
set @MaxValueto = (select max([ValueTo]) from Product_Price)
set @Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))
set @Campsiedate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 1  )
set @OmaghDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 2 )
set @HiltonDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 3 )
set @DonegalDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 4 )
set @GloucesterDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 5  )
set @MeltonDate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 6  )



SELECT     distinct pk.id, pk.Siteid,os.orgsitename,sscc,
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
					  case when DATEDIFF(d, pk.prday, @Today) >= 8 and  DATEDIFF(d, pk.prday, @Today) <= 14 then DATEDIFF(d, pk.prday, @Today) else null end as Age8to14,
					  case when DATEDIFF(d, pk.prday, @Today) >= 15 and  DATEDIFF(d, pk.prday, @Today) <= 30 then DATEDIFF(d, pk.prday, @Today) else null end as Age15to30,
					  case when DATEDIFF(d, pk.prday, @Today) >= 31 and  DATEDIFF(d, pk.prday, @Today) <= 90 then DATEDIFF(d, pk.prday, @Today) else null end as Age1to3Months,
					  case when DATEDIFF(d, pk.prday, @Today) >= 91 and  DATEDIFF(d, pk.prday, @Today) <= 180 then DATEDIFF(d, pk.prday, @Today) else null end as Age3to6Months,
					  case when DATEDIFF(d, pk.prday, @Today) >= 181 and  DATEDIFF(d, pk.prday, @Today) <= 365 then DATEDIFF(d, pk.prday, @Today) else null end as Age6to12Months,
					  case when DATEDIFF(d, pk.prday, @Today) >= 366 and  DATEDIFF(d, pk.prday, @Today) <= 730 then DATEDIFF(d, pk.prday, @Today) else null end as Age1to2years,
					  case when DATEDIFF(d, pk.prday, @Today) > 731 then DATEDIFF(d, pk.prday, @Today) else null end as AgeGthan2Years,
           
           
pk.DNOB AS DNOB, 
pk.UseBy AS Useby, 
ISNULL(col.PalletNumber, ' ') AS Pallet, 
(mat1.ProductCode) AS Product,
mat1.name AS ProductName,

--PP.value AS PricePerKg,
 isnull(PP.value,(select top 1 value from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid and [ValueTo] = (select max([ValueTo]) from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid)))   AS PricePerKg, 
mat1.description5 AS PLU, 
mat1.description6 as HiltonType,
ISNULL(con.name, 'N/A') AS Category, 
1 AS Qty, 
ISNULL(pk.weight,0) AS Weight, 
pk.tare AS Tare, 
mat1.materialtype AS type, 
PT.name as TypeName, 
Case when pk.siteid = 1 then 'FC'
when pk.siteid = 2 then 'FO'
when pk.siteid = 3 then 'FH'
when pk.siteid = 4 then 'FD'
when pk.siteid = 5 then 'FG'
when pk.siteid = 6 then 'FMM' else null end as [Site],
mat1.[DaysTillExpire],
con.[priority],
pk.siteid,pp.siteid,PT.description3 as ProductParentType,

 case when pk.siteid = 1 then @CampsieDate
 when pk.siteid = 2 then @OmaghDate
 when pk.siteid = 3 then @HiltonDate
 when pk.siteid = 4 then @DonegalDate
when pk.siteid = 5 then @gloucesterDate
when pk.siteid = 6 then @MeltonDate
else null end as StartingDate,

 case when pk.siteid = 1 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @CampsieDate)
 when pk.siteid = 2 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @OmaghDate)
when pk.siteid = 3 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @HiltonDate)
 when pk.siteid = 4 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @DonegalDate)
when pk.siteid = 5 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @GloucesterDate)
when pk.siteid = 6 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @MeltonDate)
else null end as CurrencyCode,

 case when pk.siteid = 1 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @CampsieDate)
 when pk.siteid = 2 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @OmaghDate)
when pk.siteid = 3 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @HiltonDate)
 when pk.siteid = 4 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @DonegalDate)
when pk.siteid = 5 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @GloucesterDate)
when pk.siteid = 6 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @MeltonDate)
else null end as [ExchangeRateAmount]

FROM         Stock_Packs AS pk WITH (nolock) INNER JOIN
					Sites S WITH (nolock) on pk.SiteID = S.SiteID  
					left join Orginal_site_lookup OS with (nolock) on pk.siteid = os.siteid and pk.orgsite = orgsiteid 
                    INNER JOIN  Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode LEFT JOIN
                      Product_Price as PP with (nolock) on mat1.ProductCode = PP.productcode and pk.siteid = pp.siteid and @MaxValueto between valuefrom and valueto
                       left join [Currency Exchange] CE with (nolock) on pk.siteid = CE.siteid 
                       and  CE.startingdate = (select max([StartingDate]) from [Currency Exchange] where CE.siteid = pk.siteid and [CurrencyCode] = 'EURO' or [CurrencyCode] ='GBP' )

                      Inner JOIN
                      Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site INNER JOIN
                      ProductTypes PT ON mat1.materialtype = pt.ProductTypeID LEFT OUTER JOIN
                      Pallets AS col WITH (nolock) ON pk.PalletID = col.PalletID and pk.siteid = col.siteid
                      LEFT OUTER JOIN
                      ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode left outer join
                      CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID
                      left JOIN Lots lts (nolock) ON lts.LotID=pk.LotID and lts.siteid = pk.siteid 
                      --inner join devices DV (nolock) on pk.deviceid = dv.deviceid and pk.siteid = Dv.siteid
WHERE  mat1.storageType = 2 and pr.InventoryTypeID in (1,3) and not(pr.description1 like '%FRESH%')
and pk.weight > 0.1 
and pk.productcode in ('131910570','131910551','131910560','861510560','301910570','861910531',
'861910531','861910550','861510516','861510530','881510516','881510516','881910659','881910516','301510573','861510573','861510544','881510518','881510381',
'881510440','131510440','131510381','301910531','881910529','301510682','101510572','101510573','861510562','131910562','131910550','131910572')
and not(pr.site = 2 and pr.InventoryId in (94,95))


END
GO
