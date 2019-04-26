SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Kevin Hargan
-- Create date: 25/01/2017
-- Description:	Stored procedure for all frozen
-- =============================================
--exec [dbo].[SP_FrozenStockVsSalesPerson] '1,2,3,4,5,6,7' , 'Clerice Auzende,Claire Murphy,Colin Maxwell,Christopher Snow,Commercial Team,David Campbell,Fintan Kelly,Jacqueline Phair,Marie Dibartolo,Nicola Wilson,Philip Robinson,Simon Byrne,Shaun Campbell,Stephen Dunn'
CREATE PROCEDURE [dbo].[SP_FrozenStockVsSalesPerson] 

	@Site NVARCHAR(100),
	@Salesperson NVARCHAR(MAX)

AS
BEGIN
------------------------------------------------------------------------------------------
Declare @SiteParamTable Table ( SiteParaValues Nvarchar(max) )
DECLARE @SQL VARCHAR(MAX)
SELECT  @SQL = 'SELECT ''' + REPLACE  (@site,',',''' UNION SELECT ''') + ''''

INSERT INTO @SiteParamTable
 (SiteParaValues)
 EXEC (@SQL)	

----------------------------------------------------------------------------------------------
 Declare @SalesPersonParamTable Table ( SalesPersonParaValues Nvarchar(max) )

DECLARE @SQL1 VARCHAR(MAX)
SELECT  @SQL1 = 'SELECT ''' + REPLACE  (@Salesperson,',',''' UNION SELECT ''') + ''''

INSERT INTO @SalesPersonParamTable
 (SalesPersonParaValues)
 EXEC (@SQL1)	

 ----------------------------------------------------------------------------------------------

declare @today as datetime
declare @CampsieDate as datetime, @OmaghDate as datetime, @HiltonDate as datetime, @DonegalDate datetime, 
@GloucesterDate datetime, @MeltonDate datetime,@Maxdate as datetime, @FIdate as datetime
declare @MaxValueto as datetime
set @MaxValueto = (select max([ValueTo]) from Product_Price where siteid <>7)
set @Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))
set @Campsiedate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 1  )
set @OmaghDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 2 )
set @HiltonDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 3 )
set @DonegalDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 4 )
set @GloucesterDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 5  )
set @MeltonDate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 6  )
set @FIDate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 7  )



SELECT    distinct pk.OrgSite,os.orgsitename,sscc, SP.SalesPerson,
pk.DeviceID, 
pk.InventoryID AS Inventory, 
(cast(INVL.code as varchar (15))+' '+INVL.description) as InventoryLocation,
INVL.code,
pr.Name AS Stock, 
CASE WHEN len(mat1.ProductCode) <> 9 THEN 'x'+RIGHT(mat1.ProductCode, 3) ELSE isnull(mat1.ProductCode, 'NONE') END AS BaseProd, 
--case when isnumeric(lts.code) = 1 then  cast(lts.code as bigint) else -1 end as CodeLot,
cast(lts.code as bigint) as codeLot,
ISNULL(mat1.name, 'NONE') AS BaseDesc, 
pk.KillDate AS Killdate, 
pk.prday AS PackDate, 
DATEDIFF(d, pk.prday, @Today) AS Age, 

case when DATEDIFF(d, pk.prday, @Today) >= 0 and  DATEDIFF(d, pk.prday, @Today) <= 7 then DATEDIFF(d, pk.prday, @Today) else null end as Age0to7,
					  	  
					  case when DATEDIFF(d, pk.prday, @Today) >= 8 and  DATEDIFF(d, pk.prday, @Today) <= 180 then DATEDIFF(d, pk.prday, @Today) else null end as Age1to6Months,
					  case when DATEDIFF(d, pk.prday, @Today) >= 181 and  DATEDIFF(d, pk.prday, @Today) <= 365 then DATEDIFF(d, pk.prday, @Today) else null end as Age6to12Months,
					  case when DATEDIFF(d, pk.prday, @Today) >= 366 and  DATEDIFF(d, pk.prday, @Today) <= 730 then DATEDIFF(d, pk.prday, @Today) else null end as Age1to2years,
					
					  case when DATEDIFF(d, pk.prday, @Today) > 731 then DATEDIFF(d, pk.prday, @Today) else null end as AgeGthan2Years,                   
pk.DNOB AS DNOB, 
pk.UseBy AS Useby, 
ISNULL(col.PalletNumber, ' ') AS Pallet, 
(mat1.ProductCode) AS Product,
mat1.name AS ProductName,


isnull(PP.value,
(select top 1 value 
from Product_Price 
where	ProductCode = mat1.ProductCode 
		and pk.siteid = pp.siteid 
		and [ValueTo] = (	select max([ValueTo]) 
							from Product_Price 
							where ProductCode = mat1.ProductCode 
							and pk.siteid = pp.siteid)))   AS PricePerKg, 

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
when pk.siteid = 6 then 'FMM'
when pk.siteid = 7 then 'FI'
else null end as [Site],
mat1.[DaysTillExpire],
con.[priority],
pk.siteid,lts.name,PT.description3 as ProductParentType,

 case when pk.siteid = 1 then @CampsieDate
 when pk.siteid = 2 then @OmaghDate
 when pk.siteid = 3 then @HiltonDate
 when pk.siteid = 4 then @DonegalDate
when pk.siteid = 5 then @gloucesterDate
when pk.siteid = 6 then @MeltonDate
when pk.siteid = 7 then @FIDate
else null end as StartingDate,


'EUR' as CurrencyCode,
(select top 1 [Exchange Rate Amount] from [FFGSQL01].[FFG-Production].DBO.[FFG LIVE$Currency Exchange Rate] where [Currency Code]='EUR' order by [Starting Date] desc) AS [ExchangeRateAmount],

										 	
mat1.Conservation_Name as Conservation,

CASE WHEN pr.Site IN (1,2,3,5,6,7) THEN (pk.[Weight]*isnull(PP.value,(select top 1 value from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid and [ValueTo] = (select max([ValueTo]) from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid))) )
	 WHEN pr.Site = 4 THEN (pk.[Weight]*isnull((PP.value/(select top 1 [Exchange Rate Amount] from [FFGSQL01].[FFG-Production].DBO.[FFG LIVE$Currency Exchange Rate] where [Currency Code]='EUR' order by [Starting Date] desc)),((select top 1 value from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid and [ValueTo] = (select max([ValueTo]) from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid))/(select top 1 [Exchange Rate Amount] from [FFGSQL01].[FFG-Production].DBO.[FFG LIVE$Currency Exchange Rate] where [Currency Code]='EUR' order by [Starting Date] desc))) ) END AS [Value],

CASE WHEN pr.Site IN (1,2,3,5,6,7) THEN 'UK'
	WHEN pr.Site = 4 THEN 'IRE' END AS [UK/IRE]

FROM        Stock_Packs AS pk WITH (nolock) 
			INNER JOIN Sites S WITH (nolock) on pk.SiteID = S.SiteID  
			LEFT JOIN Orginal_site_lookup OS with (nolock) on pk.siteid = os.siteid and pk.orgsite = orgsiteid 
            INNER JOIN  Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode 
			LEFT JOIN Product_Price as PP with (nolock) on mat1.ProductCode = PP.productcode and pk.siteid = pp.siteid and @MaxValueto between valuefrom and valueto
            LEFT JOIN [Currency Exchange] CE with (nolock) on pk.siteid = CE.siteid and CE.startingdate = (select max([StartingDate]) from [Currency Exchange] where CE.siteid = pk.siteid and [CurrencyCode] = 'EURO' or [CurrencyCode] ='GBP' )
			INNER JOIN Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site 
            LEFT JOIN [InventoryLocations] INVL (nolock) on  pk.siteid = INVL.siteid and pk.InventoryID = INVL.InventoryID and pk.InventoryLocationID = INVL.[InventoryLocationID]
            INNER JOIN ProductTypes PT ON mat1.materialtype = pt.ProductTypeID 
			LEFT OUTER JOIN Pallets AS col WITH (nolock) ON pk.PalletID = col.PalletID and pk.siteid = col.siteid
            LEFT OUTER JOIN ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode 
			LEFT OUTER join CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID
			LEFT JOIN [FFGSQL03].[FFGData].[dbo].[SalesPersonVsProductGrouping] AS SP WITH (NOLOCK) ON SP.[Grouping] = mat1.[Conservation_Name] AND SP.[Fresh/Frozen] = 'Frozen'
            LEFT JOIN Lots lts (nolock) ON  cast(lts.code as bigint)=pk.LotID and lts.siteid = pk.siteid
			
        
WHERE   
 pr.description1 like '%FROZEN%'
 AND pk.productnum IS NULL 
and pk.weight > 0.1
AND pk.SiteID IN (Select SiteParaValues from @SiteParamTable) 
AND SP.SalesPerson IN (Select SalesPersonParaValues from @SalesPersonParamTable) 	



END

GO
