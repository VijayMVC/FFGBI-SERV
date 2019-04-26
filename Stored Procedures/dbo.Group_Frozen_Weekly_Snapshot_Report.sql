SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 15/09/2015
-- Description:	New Frozen report for group reporting
-- =============================================
--exec [Group_Frozen_Weekly_Snapshot_Report]
CREATE PROCEDURE [dbo].[Group_Frozen_Weekly_Snapshot_Report] 

AS

declare @Weekno as int
set @Weekno =  (DATEPART(WEEK,GETDATE()))
declare @ExRate as float
set @ExRate = (select top 1 [Exchange Rate Amount] from [FFGSQL01].[FFG-Production].DBO.[FFG LIVE$Currency Exchange Rate] where [Currency Code]='EUR' order by [Starting Date] desc)

--select @ExRate

select distinct
	p.ProductCode,pt.Name ,cs.Name as [Customer Brand], p.description1 as Product,pt.Description3, p.Dimension1
	,SUM(sp.Weight) as [weight],sp.SiteID,
	(select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid))  AS PricePerKg,
	--isnull(PP.value,(select top 1 value from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid and [ValueTo] = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid)))   AS PricePerKg, 
	

	case when sp.siteid in (1,2,3,5,6) then SUM(sp.Weight) * (select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid)) 
	when sp.siteid in (4) then SUM(sp.Weight) * ((select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid))/@ExRate)
	else 0 end as convertedTotalValue,

	isnull((select sum(total) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -1 and FS.[ProductCode] =p.ProductCode ),0) as w1,
	isnull((select sum(total) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -2 and FS.[ProductCode] =p.ProductCode),0)as w2,
	isnull((select sum(total) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -3 and FS.[ProductCode] =p.ProductCode),0)as w3,
	isnull((select sum(total) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -4 and FS.[ProductCode] =p.ProductCode),0)as w4,

	isnull((select Avg(AvgPPK) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -1 and FS.[ProductCode] =p.ProductCode ),0) as w1Avg,
	isnull((select Avg(AvgPPK) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -2 and FS.[ProductCode] =p.ProductCode ),0) as w2Avg,
	isnull((select Avg(AvgPPK) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -3 and FS.[ProductCode] =p.ProductCode ),0) as w3Avg,
	isnull((select Avg(AvgPPK) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -4 and FS.[ProductCode] =p.ProductCode ),0) as w4Avg,
	

		isnull((select Sum([CovertedTotalValue]) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -1 and FS.[ProductCode] =p.ProductCode ),0) as w1CovertedTotalValue,
	isnull((select Sum([CovertedTotalValue]) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -2 and FS.[ProductCode] =p.ProductCode ),0) as w2CovertedTotalValue,
	isnull((select Sum([CovertedTotalValue]) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -3 and FS.[ProductCode] =p.ProductCode ),0) as w3CovertedTotalValue,
	isnull((select Sum([CovertedTotalValue]) from Group_Frozen_Stock_Snapshot FS where FS.SiteID = SP.siteid and FS.WeekNo = @Weekno -4 and FS.[ProductCode] =p.ProductCode ),0) as w4CovertedTotalValue,
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
	when (pt.Description3 = '102 - VL' and p.Dimension1 in (13,83)) or (Dimension1 IN (27) and pt.Description3 = '104 - MINCE') then 'VL INGREDIENTS'

	--filters out the Flank
	when pt.ProductTypeID = 118 and p.Dimension1 IN (27,30,33,37,86) and p.ProductCode <> 330610740 then 'FLANK'

	--filter ou the Chinese Flank
	when p.Dimension1 IN (30,93) AND pt.Description3 = '102 - VL'   then 'CHINESE FLANK'

	--filter out the Pad Trim
	when pt.ProductTypeID = 122 and p.Dimension1 IN (27,30,71) then 'PAD TRIM'
	
	--filter out the offal
	when ((pt.Description3 = '103 - OFFAL' and p.Dimension1 IN (88,45,35,32,31,30,27))or p.Dimension4 =850 )and p.Dimension1 <> 91  then 'OFFAL'
	 

	-- filters out the Petfood
	when pt.Description3 = '103 - OFFAL' and p.Dimension1 IN (30) and p.Dimension2 IN (32) or pt.ProductTypeID = 177 then 'PET FOOD'

	--filter out the frozen fairfax
	when pt.Description3 = '101 - PRIMAL' and p.Dimension1 IN (19) then 'FROZEN FAIRFAX'

	--filter out the frozen HMZ
	when pt.Description3 = '102 - VL' and p.Dimension1 IN (91) then 'FROZEN HMZ' 

	--filters out the cranswick
	when cs.Name = 'CRANSWICK' and p.Dimension1 IN (47,48)  then 'CRANSWICK'

	--filters out the frozen hr hfi
	when p.Dimension1 IN (90) then 'FROZEN HR HFI'

	-- filters out the frozen usa
	when (cs.Name = 'USA' or cs.Name = 'USA YP' or cs.Name = 'TRANFOODS' ) and p.Dimension1 IN (99,96) then 'FROZEN USA'

	-- filters out frozen osi
	when pt.Description3 = '102 - VL' and p.Dimension1 IN (92) then 'FROZEN OSI'

	-- filter out McKey 
	when cs.Name = 'MCKEY' and p.Dimension1 IN (97) then 'McKEY'

	-- filter out Birdseye
	when cs.Name = 'BIRDSEYE' and p.Dimension1 IN (98) then 'BIRDSEYE'

	-- filter out Kepak
	when p.ProductCode = 330610740 then 'KEPAK'
	
	-- filters outy the Eurostock
	when cs.Name ='EUROSTOCK' AND Dimension1 IN (28) THEN 'EUROSTOCK'


	else 'Other' end as CustomerCat
	 
	
from	
	Stock_Packs sp (nolock)
	inner join Products p (nolock) on sp.ProductCode = p.ProductCode
	inner join ProductTypes pt(nolock) on p.MaterialType = pt.ProductTypeID
	inner join ProductSpecs ps(nolock) on sp.ProductCode = ps.ProductCode
	inner join CustomerSpecs cs(nolock) on ps.SpecID = cs.SpecID
	inner join Sites s (nolock) on sp.SiteID = s.SiteID
	
where 
	p.StorageType = 2 
group by 
	sp.SiteID,cs.Name,pt.Name,p.description1,p.[ProductCode],pt.Description3,p.Dimension1,pt.ProductTypeID,p.Dimension2,pt.Code,p.Description3,p.Dimension4
order by 
product
	--CustomerCat
GO
