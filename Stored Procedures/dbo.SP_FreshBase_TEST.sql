SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================#
--exec  dbo.SP_FreshBase 'and mat1.description1 like ''%(mus)%'''
--exec  dbo.SP_FreshBase ' and con.[name] = ''COSTCO'' and pk.siteid = 2'
--exec  dbo.SP_FreshBase_TEST ''
CREATE procedure [dbo].[SP_FreshBase_TEST]
	-- Add the parameters for the function here
	@_Where nvarchar(max)
AS
BEGIN

declare @SQL as nvarchar(max)	

set @SQL = convert(nvarchar(max), N'') + N' 
declare @today as datetime
declare @CampsieDate as datetime, @OmaghDate as datetime, @HiltonDate as datetime, @DonegalDate datetime, 
@GloucesterDate datetime, @MeltonDate datetime,@Maxdate as datetime, @FIDate datetime
declare @MaxValueto as datetime
set @MaxValueto = (select max([ValueTo]) from Product_Price where siteid <>7)
set @Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))
set @Campsiedate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 1 and CurrencyCode= ''EUR'' )
set @OmaghDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 2 and CurrencyCode= ''EUR'' )
set @HiltonDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 3 and CurrencyCode= ''EUR'' )
set @DonegalDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 4 and CurrencyCode= ''GBP'' )
set @GloucesterDate =(select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 5 and CurrencyCode= ''EUR'' )
set @MeltonDate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 6 and CurrencyCode= ''EUR''  )
set @FIDate = (select max([StartingDate]) from [Currency Exchange] CE where CE.siteid = 7 and CurrencyCode= ''EUR''  )




SELECT     distinct pk.id,pk.OrgSite,os.orgsitename,sscc,
pk.DeviceID, 
pk.InventoryID AS Inventory, 
--(cast(INVL.code as varchar (15))+'' ''+INVL.description) as InventoryLocation,
(cast(INVL.code as varchar (15))) as InventoryLocation,
INVL.code,
pr.Name AS Stock, 
CASE WHEN len(mat1.ProductCode) <> 9 THEN ''x''+RIGHT(mat1.ProductCode, 3) ELSE isnull(mat1.ProductCode, ''NONE'') END AS BaseProd, 
case when isnumeric(lts.code) = 1 then  cast(lts.code as bigint) else -1 end as CodeLot,
ISNULL(mat1.name, ''NONE'') AS BaseDesc, 
pk.KillDate AS Killdate, 
pk.prday AS PackDate, 
DATEDIFF(d, pk.prday, @Today) AS Age, 

 case when DATEDIFF(d, pk.prday, @Today) >= 0 and  DATEDIFF(d, pk.prday, @Today) <= 7 then DATEDIFF(d, pk.prday, @Today) else null end as Age0to7,
					  case when DATEDIFF(d, pk.prday, @Today) >= 8 and  DATEDIFF(d, pk.prday, @Today) <= 13 then DATEDIFF(d, pk.prday, @Today) else null end as Age8to13,
					  case when DATEDIFF(d, pk.prday, @Today) >= 14 and  DATEDIFF(d, pk.prday, @Today) <= 21 then DATEDIFF(d, pk.prday, @Today) else null end as Age14to21,
					  case when DATEDIFF(d, pk.prday, @Today) >= 22 and  DATEDIFF(d, pk.prday, @Today) <= 30 then DATEDIFF(d, pk.prday, @Today) else null end as Age22to29,
					  case when DATEDIFF(d, pk.prday, @Today) >= 30 and  DATEDIFF(d, pk.prday, @Today) <= 37 then DATEDIFF(d, pk.prday, @Today) else null end as Age30to37,
					  case when DATEDIFF(d, pk.prday, @Today) > 37 then DATEDIFF(d, pk.prday, @Today) else null end as AgeGthan37,
           
pk.DNOB AS DNOB, 
pk.UseBy AS Useby, 
ISNULL(col.PalletNumber, '' '') AS Pallet, 
pk.Productcode as Product,
cast(pk.Productcode as varchar (9)) as Productcode,
mat1.name AS ProductName,

--PP.value AS PricePerKg,
 isnull(PP.value,(select top 1 value from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid and [ValueTo] = (select max([ValueTo]) from Product_Price where ProductCode = mat1.ProductCode and pk.siteid = pp.siteid)))   AS PricePerKg, 
mat1.description5 AS PLU, 
mat1.description6 as HiltonType,

ISNULL(con.name, ''N/A'') AS Category, 
1 AS Qty, 
ISNULL(pk.weight,0) AS Weight, 
pk.tare AS Tare, 
mat1.materialtype AS type, 
PT.name as TypeName, 
Case when pk.siteid = 1 then ''FC''
when pk.siteid = 2 then ''FO''
when pk.siteid = 3 then ''FH''
when pk.siteid = 4 then ''FD''
when pk.siteid = 5 then ''FG''
when pk.siteid = 6 then ''FMM'' 
when pk.siteid = 7 then ''FI''
else null end as [Site],

mat1.[DaysTillExpire],
con.[priority],
pk.siteid,lts.name,PT.description3 as ProductParentType,PT.description4 as productFormatType,

 case when pk.siteid = 1 then @CampsieDate
 when pk.siteid = 2 then @OmaghDate
 when pk.siteid = 3 then @HiltonDate
 when pk.siteid = 4 then @DonegalDate
when pk.siteid = 5 then @gloucesterDate
when pk.siteid = 6 then @MeltonDate
when pk.siteid = 7 then @FIDate
else null end as StartingDate,

-- case when pk.siteid = 1 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @CampsieDate)
-- when pk.siteid = 2 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @OmaghDate)
--when pk.siteid = 3 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @HiltonDate)
-- when pk.siteid = 4 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @DonegalDate)
--when pk.siteid = 5 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @GloucesterDate)
--when pk.siteid = 6 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @MeltonDate)
--else null end as CurrencyCode,

''EUR'' as CurrencyCode,

-- case when pk.siteid = 1 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @CampsieDate and CurrencyCode= ''EUR'' )
-- when pk.siteid = 2 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @OmaghDate and CurrencyCode= ''EUR'')
--when pk.siteid = 3 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @HiltonDate and CurrencyCode= ''EUR'')
-- when pk.siteid = 4 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @DonegalDate and CurrencyCode= ''EUR'')
--when pk.siteid = 5 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @GloucesterDate and CurrencyCode= ''EUR'')
--when pk.siteid = 6 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @MeltonDate and CurrencyCode= ''EUR'')
--else null end as [ExchangeRateAmount]

(select top 1 [Exchange Rate Amount] from [FFGSQL01].[FFG-Production].DBO.[FFG LIVE$Currency Exchange Rate] where [Currency Code]=''EUR'' order by [Starting Date] desc) AS [ExchangeRateAmount]

FROM         
Stock_Packs AS pk WITH (nolock) 
INNER JOIN Sites S WITH (nolock) on pk.SiteID = S.SiteID  
left join Orginal_site_lookup OS with (nolock) on pk.siteid = os.siteid and pk.orgsite = orgsiteid 
INNER JOIN  Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode 
LEFT JOIN Product_Price as PP with (nolock) on mat1.ProductCode = PP.productcode and pk.siteid = pp.siteid and @MaxValueto between valuefrom and valueto
left join [Currency Exchange] CE with (nolock) on pk.siteid = CE.siteid and  CE.startingdate = (select max([StartingDate]) from [Currency Exchange] where CE.siteid = pk.siteid and [CurrencyCode] = ''EURO'' or [CurrencyCode] =''GBP'' )
Inner JOIN Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site 
left join [InventoryLocations] INVL (nolock) on  pk.siteid = INVL.siteid and pk.InventoryID = INVL.InventoryID and pk.InventoryLocationID = INVL.[InventoryLocationID]
INNER JOIN ProductTypes PT ON mat1.materialtype = pt.ProductTypeID 
LEFT OUTER JOIN Pallets AS col WITH (nolock) ON pk.PalletID = col.PalletID and pk.siteid = col.siteid
LEFT OUTER JOIN ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode 
left outer join CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID
left JOIN Lots lts (nolock) ON cast((case when isnumeric(lts.code) = 1 then  cast(lts.code as bigint) else -1 end) as bigint)=pk.LotID and lts.siteid = pk.siteid

WHERE  
 pr.InventoryTypeID = 1 and (mat1.StorageType <> 2) and (pr.description1 like ''%FROZEN%'')
and pk.weight > 0.1 
and PT.ProductTypeID <> 140 
and pr.description2 = ''STOCK''' + @_Where
-- and not(pr.description1 like ''%FROZEN%'') 
exec(@SQL)

END

GO
