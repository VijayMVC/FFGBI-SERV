SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Daniel
-- Create date: <Create Date,,>
-- Description:	Frozen Stock summary 
-- =============================================

--exec [Group_Frozen_Weekly_Snapshot_Report_daily_Test] 

CREATE PROCEDURE [dbo].[Group_Frozen_Weekly_Snapshot_Report_daily_Test] 

AS

--declare @Weekno as int
--set @Weekno =  (DATEPART(WEEK,GETDATE()))
declare @currentDate as datetime
set @currentDate = (cast(getdate() as date))
declare @ExRate as float
set @ExRate = (select top 1 [Exchange Rate Amount] from [FFGSQL01].[FFG-Production].DBO.[FFG LIVE$Currency Exchange Rate] where [Currency Code]='EUR' order by [Starting Date] desc)

--select @ExRate
select p.ProductCode
into #tmp
from Products p


select distinct
	p.ProductCode,pt.Name ,cs.Name as [Customer Brand], p.description1 as Product,pt.Description3, p.Dimension1,pt.ProductTypeID,p.Dimension4,p.Dimension2
	,SUM(sp.Weight) as [weight],sp.SiteID,
	--case when sp.SiteID in (4) then
	(select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid))   AS PricePerKg,
	--case when sp.SiteID in (1,2,3,5,6) then (select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid)) end AS PricePerKgUK,
	--isnull(PP.value,(select top 1 value from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid and [ValueTo] = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid)))   AS PricePerKg, 	
	case when sp.siteid in (1,2,3,5,6,7) then SUM(sp.Weight) * (select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid)) 
	when sp.siteid in (4) then SUM(sp.Weight) * ((select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid))/@ExRate)
	else 0 end as convertedTotalValue,
	@currentDate as [date],
		case 
	--Filters out Commercial Primal
	when pt.Description3 = '101 - PRIMAL' and p.Dimension1 IN (30,27,45,63,35) then 'COMMERCIAL PRIMAL' 
	
	--filters out the 85VL
	when pt.ProductTypeID = 114 and p.Dimension1 IN (10,15,27,30,33,37) then '85 VL'

	--filters out the 95VL
	when pt.ProductTypeID = 113 and p.Dimension1 IN (15,27,30,33,37,86) then '95 VL'

	-- filters out the 98VL
	when pt.ProductTypeID = 112 and p.Dimension1 IN (15,27,30,33,37,86) then '98 VL'

	-- filters out the Primal Ingredients
	when pt.Description3 = '101 - PRIMAL' and (cs.Name = 'GREENCORE' or cs.Name = 'SAMWORTH BROS')or p.ProductCode in (881910529,881510683,881910659) then 'PRIMAL INGREDIENTS'

	--filters out the VL Ingredients
	when (pt.Description3 = '102 - VL' and p.Dimension1 in (13,83)) or (p.Dimension1 IN (27) and pt.Description3 = '104 - MINCE') then 'VL INGREDIENTS'

	--filters out the Flank
	when pt.ProductTypeID = 118 and p.Dimension1 IN (27,30,33,37,86) and not (p.ProductCode in(330610740,300110615,300110616,305110611,305110615,305210613,305810613,305810614)) then 'FLANK'

	--filter ou the Chinese Flank
	when p.Dimension1 IN (30,93) AND pt.Description3 = '102 - VL' and  pt.ProductTypeID <> 122 and not (p.ProductCode in(300610850,935710563,935710600,930110868))  then 'CHINESE FLANK'

	--filter out the Pad Trim
	when pt.ProductTypeID = 122 and p.Dimension1 IN (27,30,71) then 'PAD TRIM'
	
	--filter out the offal
	when ((pt.Description3 = '103 - OFFAL' and p.Dimension1 IN (88,45,35,32,31,30,27))or p.Dimension4 =850)and not(p.ProductCode in(303210751,303210661,303210666,303210784,300610746,353210746,913213850))  then 'OFFAL'
	 
	-- filters out the Petfood
	when pt.Description3 = '103 - OFFAL' and p.Dimension1 IN (30) and p.Dimension2 IN (32) or pt.ProductTypeID = 177 or p.productcode in (300610746,353210746) and not(p.ProductCode in(93011633,610121990,930110856,964825672)) then 'PET FOOD'

	--filter out the frozen fairfax
	when pt.Description3 = '101 - PRIMAL' and p.Dimension1 IN (19) then 'FROZEN FAIRFAX'

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

	when p.Dimension1 in (93) then 'ELMGROVE'


	else 'Other' end as CustomerCat

	 into #TMP2	
from		
	 Products p 
	
	inner join Stock_Packs sp (nolock) on sp.ProductCode = p.ProductCode
	inner join ProductTypes pt(nolock) on p.MaterialType = pt.ProductTypeID
	inner join ProductSpecs ps(nolock) on sp.ProductCode = ps.ProductCode
	inner join CustomerSpecs cs(nolock) on ps.SpecID = cs.SpecID
	inner join Sites s (nolock) on sp.SiteID = s.SiteID
	inner join Inventories pr (nolock) ON pr.InventoryID = sp.InventoryID and sp.siteid = pr.[site] 
	--left join #tmp tp (nolock) on sp.ProductCode = tp.ProductCode	
where 
	p.StorageType = 2 and pr.description1 like ('%FROZEN%') and pr.description2 = 'STOCK'
group by 
	sp.SiteID,
	cs.Name,pt.Name,p.description1,p.[ProductCode],pt.Description3,p.Dimension1,pt.ProductTypeID,p.Dimension2,pt.Code,p.Description3,p.Dimension4
order by 
product




select distinct tt.ProductCode,-- tt.name, [Customer Brand],Product,t.Description3,t.Dimension1,sum(isnull(t.[weight],0)) as [weight], avg(isnull(PricePerKg,0)),sum(isnull(convertedTotalValue,0))as convertedTotalValue,[date],

	isnull((select sum(total) from [Group_Frozen_Stock_Snapshot_daily] FS where FS.[Date] = @currentDate -1 and FS.[ProductCode] =tt.ProductCode ),0)as D1,
	isnull((select sum(total) from [Group_Frozen_Stock_Snapshot_daily] FS where FS.[Date] = @currentDate -2 and FS.[ProductCode] =tt.ProductCode ),0)as D2,
	isnull((select sum(total) from [Group_Frozen_Stock_Snapshot_daily] FS where FS.[Date] = @currentDate -3 and FS.[ProductCode] =tt.ProductCode ),0)as D3,
	isnull((select sum(total) from [Group_Frozen_Stock_Snapshot_daily] FS where FS.[Date] = @currentDate -4 and FS.[ProductCode] =tt.ProductCode ),0)as D4,
	isnull((select sum(total) from [Group_Frozen_Stock_Snapshot_daily] FS where FS.[Date] = @currentDate -5 and FS.[ProductCode] =tt.ProductCode ),0)as D5,

	isnull((select Avg(AvgPPK) from [Group_Frozen_Stock_Snapshot_daily] FS where FS.[Date] = @currentDate -1 and FS.[ProductCode] =tt.ProductCode ),0) as D1Avg,
	isnull((select Avg(AvgPPK) from [Group_Frozen_Stock_Snapshot_daily] FS where FS.[Date] = @currentDate -2 and FS.[ProductCode] =tt.ProductCode ),0) as D2Avg,
	isnull((select Avg(AvgPPK) from [Group_Frozen_Stock_Snapshot_daily] FS where FS.[Date] = @currentDate -3 and FS.[ProductCode] =tt.ProductCode ),0) as D3Avg,
	isnull((select Avg(AvgPPK) from [Group_Frozen_Stock_Snapshot_daily] FS where FS.[Date] = @currentDate -4 and FS.[ProductCode] =tt.ProductCode ),0) as D4Avg,
	isnull((select Avg(AvgPPK) from [Group_Frozen_Stock_Snapshot_daily] FS where FS.[Date] = @currentDate -5 and FS.[ProductCode] =tt.ProductCode ),0) as D5Avg,

	isnull((select Sum([CovertedTotalValue]) from [Group_Frozen_Stock_Snapshot_daily] FS where  FS.[Date] = @currentDate -1 and FS.[ProductCode] =tt.ProductCode ),0) as D1CovertedTotalValue,
	isnull((select Sum([CovertedTotalValue]) from [Group_Frozen_Stock_Snapshot_daily] FS where	FS.[Date] = @currentDate -2 and FS.[ProductCode] =tt.ProductCode ),0) as D2CovertedTotalValue,
	isnull((select Sum([CovertedTotalValue]) from [Group_Frozen_Stock_Snapshot_daily] FS where	FS.[Date] = @currentDate -3 and FS.[ProductCode] =tt.ProductCode ),0) as D3CovertedTotalValue,
	isnull((select Sum([CovertedTotalValue]) from [Group_Frozen_Stock_Snapshot_daily] FS where	FS.[Date] = @currentDate -4 and FS.[ProductCode] =tt.ProductCode ),0) as D4CovertedTotalValue,
	isnull((select Sum([CovertedTotalValue]) from [Group_Frozen_Stock_Snapshot_daily] FS where 	FS.[Date] = @currentDate -5 and FS.[ProductCode] =tt.ProductCode ),0) as D5CovertedTotalValue,

			case 
	--Filters out Commercial Primal
	when pt.Description3 = '101 - PRIMAL' and p.Dimension1 IN (30,27,45,63,35) then 'COMMERCIAL PRIMAL' 
	
	--filters out the 85VL
	when pt.ProductTypeID = 114 and p.Dimension1 IN (10,15,27,30,33,37) then '85 VL'

	--filters out the 95VL
	when pt.ProductTypeID = 113 and p.Dimension1 IN (15,27,30,33,37,86) then '95 VL'

	-- filters out the 98VL
	when pt.ProductTypeID = 112 and p.Dimension1 IN (15,27,30,33,37,86) then '98 VL'

	-- filters out the Primal Ingredients
	when pt.Description3 = '101 - PRIMAL' and (cs.Name = 'GREENCORE' or cs.Name = 'SAMWORTH BROS') then 'PRIMAL INGREDIENTS'

	--filters out the VL Ingredients
	when (pt.Description3 = '102 - VL' and p.Dimension1 in (13,83)) or (p.Dimension1 IN (27) and pt.Description3 = '104 - MINCE') then 'VL INGREDIENTS'

	--filters out the Flank
	when pt.ProductTypeID = 118 and p.Dimension1 IN (27,30,33,37,86) and not (p.ProductCode in(330610740,300110615,300110616,305110611,305110615,305210613,305810613,305810614)) then 'FLANK'

	--filter ou the Chinese Flank
	when p.Dimension1 IN (30,93) AND pt.Description3 = '102 - VL' and  pt.ProductTypeID <> 122 and not (p.ProductCode in(300610850))  then 'CHINESE FLANK'

	--filter out the Pad Trim
	when pt.ProductTypeID = 122 and p.Dimension1 IN (27,30,71) then 'PAD TRIM'
	
	--filter out the offal
	when ((pt.Description3 = '103 - OFFAL' and p.Dimension1 IN (88,45,35,32,31,30,27))or p.Dimension4 =850)and not(p.ProductCode in(303210751,303210661,303210666,303210784,300610746,353210746))  then 'OFFAL'
	 
	-- filters out the Petfood
	when pt.Description3 = '103 - OFFAL' and p.Dimension1 IN (30) and p.Dimension2 IN (32) or pt.ProductTypeID = 177 or p.productcode in (300610746,353210746) and not(p.ProductCode in(93011633,610121990,930110856,964825672)) then 'PET FOOD'

	--filter out the frozen fairfax
	when pt.Description3 = '101 - PRIMAL' and p.Dimension1 IN (19) then 'FROZEN FAIRFAX'

	--filter out the frozen HMZ
	when pt.Description3 = '102 - VL' and p.Dimension1 IN (91) then 'FROZEN HMZ' 

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

	when p.Dimension1 in (93) then 'ELMGROVE'

	else 'Other' end as CustomerCat
	into #tmp3
	from #tmp tt
	--left join  #TMP2  t on t.ProductCode = tt.ProductCode
	left join Stock_Packs sp (nolock) on sp.ProductCode = tt.ProductCode
	left join Products p (nolock) on tt.ProductCode = p.ProductCode
	left join ProductTypes pt(nolock) on p.MaterialType = pt.ProductTypeID
	left join ProductSpecs ps(nolock) on sp.ProductCode = ps.ProductCode
	left join CustomerSpecs cs(nolock) on ps.SpecID = cs.SpecID
	left join Sites s (nolock) on sp.SiteID = s.SiteID
	left join Inventories pr (nolock) ON pr.InventoryID = sp.InventoryID and sp.siteid = pr.[site] 

	--cast(tt.date as date) = @currentDate and t.date is not null


--group by t.Name,[Customer Brand],tt.ProductCode,t.Product,t.Description3,t.Dimension1,t.ProductTypeID,t.Dimension2,t.Description3,t.Dimension4,[date],CustomerCat,p.Dimension1,cs.Name,pt.ProductTypeID,p.ProductCode,pt.Description3,p.Dimension4,p.Dimension2


select t3.ProductCode, sum(isnull(t2.[weight],0)) as [weight], avg(isnull(t2.PricePerKg,0)),sum(isnull(t2.convertedTotalValue,0))as convertedTotalValue,t2.[date],t3.CustomerCat,t3.D1,t3.D2,t3.d3,t3.D4,t3.D5,t3.D1Avg,t3.D2Avg,t3.D3Avg,t3.D4Avg,t3.D5Avg,t3.D1CovertedTotalValue,t3.D2CovertedTotalValue,t3.D3CovertedTotalValue,t3.D4CovertedTotalValue,t3.D5CovertedTotalValue
from #tmp3 t3
left join #TMP2 t2 on t3.productcode = t2.ProductCode
group by t3.ProductCode, t2.[date],t3.CustomerCat,t3.D1,t3.D2,t3.D3,t3.D4,t3.D5,t3.D1Avg,t3.D2Avg,t3.D3Avg,t3.D4Avg,t3.D5Avg,t3.D1CovertedTotalValue,t3.D2CovertedTotalValue,t3.D3CovertedTotalValue,t3.D4CovertedTotalValue,t3.D5CovertedTotalValue



--select * from #tmp2
--select * from #tmp3

drop table #tmp
drop table #TMP2
drop table #TMP3
--exec [Group_Frozen_Weekly_Snapshot_Report_daily_Test] 
GO
