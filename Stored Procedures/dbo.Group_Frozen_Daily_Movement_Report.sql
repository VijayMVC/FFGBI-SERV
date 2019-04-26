SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Daniel
-- Create date: 10/102015
-- Description:	<Description,,>
-- =============================================
--exec  [dbo].[Group_Frozen_Daily_Movement_Report]
CREATE PROCEDURE [dbo].[Group_Frozen_Daily_Movement_Report]
	-- Add the parameters for the stored procedure here

AS
declare @currentDate as datetime
set @currentDate = (cast(getdate() as date))

declare @ExRate as float
set @ExRate = (select top 1 [Exchange Rate Amount] from [FFGSQL01].[FFG-Production].DBO.[FFG LIVE$Currency Exchange Rate] where [Currency Code]='EUR' order by [Starting Date] desc)

--select * 
--from [OMASQL01].[Innova].[dbo].[Pack_Movement_Snapshot] FO 
--where FO.[Date] = @currentDate-1

select distinct fs.ProductCode,sum(fs.Weight) as [weight], fs.Value, fs.InOrOut,fs.Subjectid,fs.ImportDate,fs.Cat,fs.Customer,count(fs.weight) as qty ,fs.[Site],
case 
	--Filters out Commercial Primal
	when pt.Description3 = '101 - PRIMAL' and p.Dimension1 IN (30,27,45,63,35,83) then 'COMMERCIAL PRIMAL' 
	
	--filters out the 85VL
	when pt.ProductTypeID = 114 and p.Dimension1 IN (10,15,27,30,33,37) then '85 VL'

	--filters out the 95VL
	when pt.ProductTypeID = 113 and p.Dimension1 IN (15,27,30,33,37,86) then '95 VL'

	-- filters out the 98VL
	when pt.ProductTypeID = 112 and p.Dimension1 IN (15,27,30,33,37,86) then '98 VL'

	-- filters out the Primal Ingredients
	when pt.Description3 = '101 - PRIMAL' and (cs.Name = 'GREENCORE' or cs.Name = 'SAMWORTH BROS') or p.ProductCode in (881910529,881510683,881910659) then 'PRIMAL INGREDIENTS'

	--filters out the VL Ingredients
	when (pt.Description3 = '102 - VL' and p.Dimension1 in (13,83)) or (p.Dimension1 IN (27) and pt.Description3 = '104 - MINCE') then 'VL INGREDIENTS'

	--filters out the Flank
	when pt.ProductTypeID = 118 and p.Dimension1 IN (27,30,33,37,86) and not (p.ProductCode in(330610740,300110615,300110616,305110611,305110615,305210613,305810613,305810614)) then 'FLANK'

	--filter ou the Chinese Flank
	when p.Dimension1 IN (30,93) AND pt.Description3 = '102 - VL' and  pt.ProductTypeID <> 122 and not (p.ProductCode in(300610850,935710563,935710600,930110868,305710851))  then 'CHINESE FLANK'

	--filter out the Pad Trim
	when pt.ProductTypeID = 122 and p.Dimension1 IN (27,30,71) then 'PAD TRIM'
	
	--filter out the offal
	when ((pt.Description3 = '103 - OFFAL' and p.Dimension1 IN (88,45,35,32,31,30,27))or p.Dimension4 =850)and not(p.ProductCode in(303210751,303210661,303210666,303210784,300610746,353210746,913213850))  then 'OFFAL'
	 
	-- filters out the Petfood
	when (pt.Description3 = '103 - OFFAL' and p.Dimension1 IN (30) and p.Dimension2 IN (32) and p.ProductCode <> (930110633)) or (pt.ProductTypeID = 177 and not p.ProductCode in (930110633,610121990,930110856,964825672)) or (p.productcode in (300610746,353210746) and not(p.ProductCode in(93011633,610121990,930110856,964825672))) then 'PET FOOD'

	--filter out the frozen fairfax
	when pt.Description3 = '101 - PRIMAL' and p.Dimension1 IN (19,87) then 'FROZEN FAIRFAX'

	--filter out the frozen HMZ
	when pt.Description3 = '102 - VL' and p.Dimension1 IN (91) or p.ProductCode in (913213850) then 'FROZEN HMZ' 

	--filters out the cranswick
	when cs.Name = 'CRANSWICK' and p.Dimension1 IN (47,48)  then 'CRANSWICK'

	--filters out the frozen hr hfi
	when p.Dimension1 IN (90) then 'FROZEN HR HFI'

	-- filters out the frozen usa
	when ((cs.Name = 'USA' or cs.Name = 'USA YP' or cs.Name = 'TRANFOODS' ) and p.Dimension1 IN (99,96)) Or p.productcode in (964825672) then 'FROZEN USA'

	-- filters out frozen osi
	when pt.Description3 = '102 - VL' and p.Dimension1 IN (92) then 'FROZEN OSI'

	-- filter out McKey 
	when cs.Name = 'MCKEY' and p.Dimension1 IN (97) then 'McKEY'

	-- filter out Birdseye
	when cs.Name = 'BIRDSEYE' and p.Dimension1 IN (98) then 'BIRDSEYE'

	-- filter out Kepak
	when p.ProductCode = 330610740 then 'KEPAK'
	
	-- filters outy the Eurostock
	when cs.Name ='EUROSTOCK' AND p.Dimension1 IN (28) THEN 'EUROSTOCK'

	when p.Dimension1 IN (93) then 'ELMGROVE'

	else 'Other' end as CustomerCat
	,p.Description1,
	case when fs.site in (1,2,3,5,6) then SUM(fs.Weight) * (select top 1 value from Product_Price pp where pp.ProductCode = fs.productcode and pp.SiteID = fs.site and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = fs.ProductCode and prdp.siteid = fs.site)) 
	when fs.site in (4) then SUM(fs.Weight) * ((select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = fs.site and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = fs.ProductCode and prdp.siteid = fs.site))/@ExRate)
	else 0 end as convertedTotalValue,
	case when fs.site in (1,2,3,5,6) then (select top 1 value from Product_Price pp where pp.ProductCode = fs.productcode and pp.SiteID = fs.site and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = fs.ProductCode and prdp.siteid = fs.site))
	when fs.site in (4) then (select top 1 value from Product_Price pp where pp.ProductCode = fs.productcode and pp.SiteID = fs.site and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = fs.ProductCode and prdp.siteid = fs.site))/@ExRate
	else 0 end as ppk
into #tmp
from [dbo].[FrozenStockInOut] fs
inner join Products p (nolock) on fs.ProductCode = p.ProductCode 
inner join ProductTypes pt(nolock) on p.MaterialType = pt.ProductTypeID
inner join ProductSpecs ps(nolock) on p.ProductCode = ps.ProductCode
inner join CustomerSpecs cs(nolock) on ps.SpecID = cs.SpecID
where cast(ImportDate as date) = @currentDate 
group by fs.ProductCode,fs.Value , fs.InOrOut,fs.Subjectid,fs.ImportDate,fs.Cat,fs.Customer,fs.[site],pt.Description3,p.Dimension1,cs.Name,pt.ProductTypeID,p.Dimension2,p.ProductCode,p.Dimension4,p.Description1



select ProductCode, SUM(weight) as [Weight], value, InOrOut, Subjectid,ImportDate,Cat,Customer,qty,CustomerCat,[Site],Description1, convertedTotalValue,ppk
from #tmp
where weight > 0.1
group by ProductCode,value, InOrOut, Subjectid,ImportDate,Cat,Customer,qty,CustomerCat,[site],Description1,convertedTotalValue,ppk

drop table #tmp 
-- exec [Group_Frozen_Daily_Movement_Report]
GO
