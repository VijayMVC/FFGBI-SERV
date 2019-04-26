SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 06/10/2014
-- Description:	Stored procedure for all frozen
-- =============================================
--exec [dbo].[SP_FrozenBase_Test_2016_09_06]  '' 
CREATE PROCEDURE [dbo].[ARCHIVED_SP_FrozenBase_Test_2016_09_06] 
@_Where nvarchar(max)
AS
BEGIN

declare @SQL as nvarchar(max)	


set @SQL = convert(nvarchar(max), N'') + N' 
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



SELECT    distinct pk.OrgSite,os.orgsitename,sscc,
pk.DeviceID, 
pk.InventoryID AS Inventory, 
(cast(INVL.code as varchar (15))+'' ''+INVL.description) as InventoryLocation,
INVL.code,
pr.Name AS Stock, 
CASE WHEN len(mat1.ProductCode) <> 9 THEN ''x''+RIGHT(mat1.ProductCode, 3) ELSE isnull(mat1.ProductCode, ''NONE'') END AS BaseProd, 
--case when isnumeric(lts.code) = 1 then  cast(lts.code as bigint) else -1 end as CodeLot,
cast(lts.code as bigint) as codeLot,
ISNULL(mat1.name, ''NONE'') AS BaseDesc, 
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
ISNULL(col.PalletNumber, '' '') AS Pallet, 
(mat1.ProductCode) AS Product,
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
when pk.siteid = 6 then ''FMM'' else null end as [Site],
mat1.[DaysTillExpire],
con.[priority],
pk.siteid,lts.name,PT.description3 as ProductParentType,

 case when pk.siteid = 1 then @CampsieDate
 when pk.siteid = 2 then @OmaghDate
 when pk.siteid = 3 then @HiltonDate
 when pk.siteid = 4 then @DonegalDate
when pk.siteid = 5 then @gloucesterDate
when pk.siteid = 6 then @MeltonDate
else null end as StartingDate,

-- case when pk.siteid = 1 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @CampsieDate)
--when pk.siteid = 2 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @OmaghDate)
--when pk.siteid = 3 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @HiltonDate)
--when pk.siteid = 4 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @DonegalDate)
--when pk.siteid = 5 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @GloucesterDate)
--when pk.siteid = 6 then (select top 1 [CurrencyCode] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @MeltonDate)
--else null end as CurrencyCode,
''EUR'' as CurrencyCode,
(select top 1 [Exchange Rate Amount] from [FFGSQL01].[FFG-Production].DBO.[FFG LIVE$Currency Exchange Rate] where [Currency Code]=''EUR'' order by [Starting Date] desc) AS [ExchangeRateAmount],
--case when pk.siteid = 1 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @CampsieDate)
--when pk.siteid = 2 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @OmaghDate)
--when pk.siteid = 3 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @HiltonDate)
--when pk.siteid = 4 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @DonegalDate)
--when pk.siteid = 5 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @GloucesterDate)
--when pk.siteid = 6 then (select top 1 [ExchangeRateAmount] from [Currency Exchange] CE where CE.siteid = pk.siteid and startingdate = @MeltonDate)
--else null end as [ExchangeRateAmount],
case 
	--Filters out Commercial Primal
	when (
			pt.Description3 = ''101 - PRIMAL''
			and 
			mat1.Dimension1 IN (30,27,45,63,35) 
			and mat1.ProductCode not in (301510640,301510426) 
		) 
		or 
		(
			mat1.ProductCode in 
				(114823472,155210261,155210323,155210324,860110077,155110338,155210228
				-- DBogues 2016 09 05 : Ticket 4485 from Chris Snow. 
				,830610511,833210500
				)
		)  then ''COMMERCIAL PRIMAL''
	
	--filters out the 85VL
	when pt.ProductTypeID = 114 and mat1.Dimension1 IN (10,15,27,30,33,37) then ''85 VL''
	
	--filters out the 95VL
	when pt.ProductTypeID = 113 and mat1.Dimension1 IN (15,27,30,33,37,86) then ''95 VL''
	
	-- filters out the 98VL
	when pt.ProductTypeID = 112 and mat1.Dimension1 IN (15,27,30,33,37,86) or  (mat1.ProductCode in(830123531,670110531)) then ''98 VL''
	
	-- filters out the Primal Ingredients
	when 
		pt.Description3 = ''101 - PRIMAL'' 
		and 
		(con.Name = ''GREENCORE'' or con.Name = ''SAMWORTH BROS'') 
		or 
		mat1.ProductCode 
			in (881910529,881510683,881910659,301510640,301510426
			-- DBogues 2016 09 05 : Ticket 4485 from Chris Snow. 
			,831510529
			) 
		then ''PRIMAL INGREDIENTS''
	
	--filters out the VL Ingredients
	when 
		(
			pt.Description3 = ''102 - VL'' 
			and 
			mat1.Dimension1 in (13,83)
			and 
			mat1.ProductCode not in 
				(
				-- DBogues 2016 09 05 : Ticket 4485 from Chris Snow. 
				831510529)
		) 
		or 
		(
			mat1.Dimension1 IN (27) 
			and 
			pt.Description3 = ''104 - MINCE''
		) 
		then ''VL INGREDIENTS''
	
	--filters out the Flank
	when 
		(
			pt.ProductTypeID = 118 
			and 
			mat1.Dimension1 IN (27,30,33,37,86) 
			and not 
			(mat1.ProductCode in
				(330610740,300110615,300110616,305110611,305110615,305210613,305810613,305810614,7160610601
				-- DBogues 2016 09 05 : Ticket 4485 from Chris Snow. 
				,303220611
				)
			)
		)
		OR
		(
			mat1.ProductCode in (
				-- DBogues 2016 09 05 : Ticket 4485 from Chris Snow. 
				710610601)
		)
		then ''FLANK''
	
	
	--filter ou the Chinese Flank	
	when 
	(
		mat1.Dimension1 IN (30,93) 
		AND pt.Description3 = ''102 - VL'' 
		and  pt.ProductTypeID <> 122 
		and not (mat1.ProductCode in
			(300610850,935710563,935710600,930110868,305710851
				-- DBogues 2016 09 05 : Ticket 4485 from Chris Snow. 
				,303220611
			)
		)
	)
	OR
	(
		mat1.ProductCode in (
		-- DBogues 2016 09 05 : Ticket 4485 from Chris Snow. 
		381710616,381810612,381810613,381810614,381810615)
	)
	then ''CHINESE FLANK''
		
	--filter out the Pad Trim
	when pt.ProductTypeID = 122 and mat1.Dimension1 IN (27,30,71) then ''PAD TRIM''		
	
	--filter out the offal
	when ((pt.Description3 = ''103 - OFFAL'' and mat1.Dimension1 IN (88,45,35,32,31,30,27)) or mat1.dimension4 = 850) and not(mat1.ProductCode in(303210751,303210661,303210666,303210784,300610746,353210746,913213850,305710851,305710851 ))  then ''OFFAL''		 	
	
	-- filters out the Petfood
	when (pt.Description3 = ''103 - OFFAL'' and mat1.Dimension1 IN (30) and mat1.Dimension2 IN (32)  and mat1.ProductCode <> (930110633)) or pt.ProductTypeID = 177 and not mat1.ProductCode in (930110633,610121990,930110856,964825672) or mat1.productcode in (300610746,353210746)  and not mat1.ProductCode in (930110633,610121990,930110856,964825672) then ''PET FOOD''
	
	--filter out the frozen fairfax
	when pt.Description3 = ''101 - PRIMAL'' and mat1.Dimension1 IN (19) then ''FROZEN FAIRFAX''
	
	--filter out the frozen HMZ
	when pt.Description3 = ''102 - VL'' and mat1.Dimension1 IN (91) or mat1.productCode in (913213850) then ''FROZEN HMZ'' 
	
	--filters out the cranswick
	when con.Name = ''CRANSWICK'' and mat1.Dimension1 IN (47,48)  then ''CRANSWICK''
	
	--filters out the frozen hr hfi
	when mat1.Dimension1 IN (90) then ''FROZEN HR HFI''
	
	-- filters out the frozen usa
	when ((con.Name = ''USA'' or con.Name = ''USA YP'' or con.Name = ''TRANFOODS'' ) and mat1.Dimension1 IN (99,96)) or mat1.productcode in (964825672) then ''FROZEN USA''
	
	-- filters out frozen osi
	when pt.Description3 = ''102 - VL'' and mat1.Dimension1 IN (92) then ''FROZEN OSI''
	
	-- filter out McKey 
	when con.Name = ''MCKEY'' and mat1.Dimension1 IN (97) then ''McKEY''
	
	-- filter out Birdseye
	when (
		
			(mat1.ProductCode in (
				-- DBogues 2016 09 05 : Ticket 4485 from Chris Snow. The correct way to do this is to address underlying product types but Chris said this could cause problems in boning hall so have to do this hacky way of fixing. When Stock is in Nav these reports will all change and we will enforce that they are done correctly then.
				303220611) )
			OR
			(con.Name = ''BIRDSEYE'' and mat1.Dimension1 IN (98))
		) then ''BIRDSEYE''
	
	
	-- filter out Kepak
	when mat1.ProductCode = 330610740 then ''KEPAK''	
	
	-- filters outy the Eurostock
	when con.Name =''EUROSTOCK'' AND mat1.Dimension1 IN (28) THEN ''EUROSTOCK''
	
	when mat1.Dimension1 IN (93) then ''ELMGROVE''

	else ''Other'' end as CustomerCat,
	case
	  when (SUBSTRING(cast(lts.code as nvarchar(20)),10,2) =11) then ''IRL''
      else ''UK''
	  end as CattleOrigin


FROM        Stock_Packs AS pk WITH (nolock) 
			INNER JOIN Sites S WITH (nolock) on pk.SiteID = S.SiteID  
			LEFT JOIN Orginal_site_lookup OS with (nolock) on pk.siteid = os.siteid and pk.orgsite = orgsiteid 
            INNER JOIN  Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode 
			LEFT JOIN Product_Price as PP with (nolock) on mat1.ProductCode = PP.productcode and pk.siteid = pp.siteid and @MaxValueto between valuefrom and valueto
            LEFT JOIN [Currency Exchange] CE with (nolock) on pk.siteid = CE.siteid and CE.startingdate = (select max([StartingDate]) from [Currency Exchange] where CE.siteid = pk.siteid and [CurrencyCode] = ''EURO'' or [CurrencyCode] =''GBP'' )
			INNER JOIN Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site 
            LEFT JOIN [InventoryLocations] INVL (nolock) on  pk.siteid = INVL.siteid and pk.InventoryID = INVL.InventoryID and pk.InventoryLocationID = INVL.[InventoryLocationID]
            INNER JOIN ProductTypes PT ON mat1.materialtype = pt.ProductTypeID 
			LEFT OUTER JOIN Pallets AS col WITH (nolock) ON pk.PalletID = col.PalletID and pk.siteid = col.siteid
            LEFT OUTER JOIN ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode 
			LEFT OUTER join CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID
            LEFT JOIN Lots lts (nolock) ON  cast(lts.code as bigint)=pk.LotID and lts.siteid = pk.siteid
			
        
WHERE   
 (pr.description1 like ''%FROZEN%'')  
and pk.weight > 0.1'

 --and mat1.productcode in(980610243, 303220611)'
+ @_Where
exec(@SQL)

END
--exec [dbo].[SP_FrozenBase_Test_2016_09_06] ''

GO
