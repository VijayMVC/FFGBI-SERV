SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Tommy Thomson
-- Create date: 15/09/2015
-- Description:	New Frozen report for group reporting
-- =============================================
--exec [dbo].[Group_Frozen_Weekly_Snapshot_Daily]
CREATE PROCEDURE [dbo].[Group_Frozen_Weekly_Snapshot_Daily]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
--declare @Weekno as int

--set @Weekno = (DATEPART(WEEK,GETDATE()))-1
declare @currentDate as datetime
declare @ExRate as float

set @currentDate = (cast(getdate() as date))

--select @LastWeekDate
set @ExRate = (select top 1 [Exchange Rate Amount] from [FFGSQL01].[FFG-Production].DBO.[FFG LIVE$Currency Exchange Rate] where [Currency Code]='EUR' order by [Starting Date] desc)


--select  @ExRate
--select @Weekno


--delete From dbo.Group_Frozen_Stock_Snapshot where weekno = @Weekno


select sp.prday, S.SiteID,SP.ProductCode,SUM(sp.Weight) [Weight],  GETDATE() as RegTime, 
(select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid))  AS PricePerKg,

case when sp.siteid in (1,2,3,5,6,7) then SUM(sp.Weight) * (select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid)) 
	when sp.siteid in (4) then SUM(sp.Weight) * ((select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid))/@ExRate)
	else 0 end as convertedTotalValue

into #TMP
from Stock_Packs SP
left join [Sites] S (nolock) on SP.SiteID = S.SiteID
left join [Products] P (nolock) on SP.ProductCode = p.ProductCode
inner join Inventories pr (nolock) ON pr.InventoryID = sp.InventoryID and sp.siteid = pr.[site] 
where p.StorageType = 2  and pr.description1 like ('%FROZEN%') and pr.description2 = 'STOCK' and sp.Productnum is null
and sp.Regtime <> GETDATE()
group by S.SiteID,PRDay,SP.ProductCode, SP.SiteID, P.ProductCode
order by  SP.ProductCode

select SiteID, ProductCode ,sum([Weight]) as [weight], RegTime,@currentDate as Currentdate, avg(PricePerKg) as AvgPPK,convertedTotalValue
into #TMP1
from #TMP
--where  DATEPART(WEEK,prday) = @Weekno
group by SiteID,RegTime,prday,ProductCode,PricePerKg,convertedTotalValue
order by Currentdate


insert into dbo.[Group_Frozen_Stock_Snapshot_daily]
select distinct Currentdate,SiteID,ProductCode,sum([weight]) as [weight],regtime, AvgPPK,sum(convertedTotalValue) as [convertedTotalValue]
from #TMP1
group by --
ProductCode,siteid,Currentdate,regtime, AvgPPK


drop table #TMP1
drop table #TMP

END

GO
