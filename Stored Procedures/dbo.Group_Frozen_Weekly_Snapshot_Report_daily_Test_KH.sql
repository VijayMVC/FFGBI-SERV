SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Daniel
-- Create date: <Create Date,,>
-- Description:	Frozen Stock summary 
-- =============================================

--exec [Group_Frozen_Weekly_Snapshot_Report_daily_Test_KH] 

CREATE PROCEDURE [dbo].[Group_Frozen_Weekly_Snapshot_Report_daily_Test_KH] 

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
	p.Conservation_Name as CustomerCat

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
	p.StorageType = 2 and pr.description1 like ('%FROZEN%') and pr.description2 = 'STOCK' and sp.Productnum is null
group by 
	sp.SiteID,p.Conservation_Name,
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

	p.Conservation_Name as CustomerCat
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


select t3.ProductCode, sum(isnull(t2.[weight],0)) as [weight], avg(isnull(t2.PricePerKg,0)),sum(isnull(t2.convertedTotalValue,0))as convertedTotalValue,t2.[date],t3.CustomerCat,t3.D1,t3.D2,t3.d3,t3.D4,t3.D5,t3.D1Avg,t3.D2Avg,t3.D3Avg,t3.D4Avg,t3.D5Avg,t3.D1CovertedTotalValue,t3.D2CovertedTotalValue,t3.D3CovertedTotalValue,t3.D4CovertedTotalValue,t3.D5CovertedTotalValue--, t2.SiteID
from #tmp3 t3
left join #TMP2 t2 on t3.productcode = t2.ProductCode
where t3.CustomerCat NOT IN ('NULL','B B FSH','FROZEN')-- and t2.[weight] > '0.1'
group by t3.ProductCode, t2.[date],t3.CustomerCat,t3.D1,t3.D2,t3.D3,t3.D4,t3.D5,t3.D1Avg,t3.D2Avg,t3.D3Avg,t3.D4Avg,t3.D5Avg,t3.D1CovertedTotalValue,t3.D2CovertedTotalValue,t3.D3CovertedTotalValue,t3.D4CovertedTotalValue,t3.D5CovertedTotalValue--,t2.SiteID



--select * from #tmp2
--select * from #tmp3

drop table #tmp
drop table #TMP2
drop table #TMP3
--exec [Group_Frozen_Weekly_Snapshot_Report_daily_Test_KH] 

GO
