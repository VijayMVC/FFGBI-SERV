SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 15/09/2015
-- Description:	New Frozen report for group reporting
-- =============================================
--exec Group_Frozen_Weekly_Snapshot_Weekly
CREATE PROCEDURE [dbo].[Group_Frozen_Weekly_Snapshot_Weekly]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
declare @Weekno as int

set @Weekno = (DATEPART(WEEK,GETDATE()))-1
declare @LastWeekDate as datetime
declare @ExRate as float

set @LastWeekDate = (getdate()-2)

--select @LastWeekDate
set @ExRate = (select top 1 [Exchange Rate Amount] from [FFGSQL01].[FFG-Production].DBO.[FFG LIVE$Currency Exchange Rate] where [Currency Code]='EUR'  and @LastWeekDate between [Starting Date] and [Starting Date] +7  order by [Starting Date] desc)


--select  @ExRate
--select @Weekno


delete From dbo.Group_Frozen_Stock_Snapshot where weekno = @Weekno


select sp.prday, S.SiteID,SP.ProductCode,SUM(Weight) [Weight],  GETDATE() as RegTime, 
(select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid))  AS PricePerKg,

case when sp.siteid in (1,2,3,5,6) then SUM(sp.Weight) * (select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid)) 
	when sp.siteid in (4) then SUM(sp.Weight) * ((select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = SP.siteid and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = p.ProductCode and prdp.siteid = sp.siteid))/@ExRate)
	else 0 end as convertedTotalValue

into #TMP
from Stock_Packs SP
left join [Sites] S (nolock) on SP.SiteID = S.SiteID
left join [Products] P (nolock) on SP.ProductCode = p.ProductCode
where p.StorageType = 2  --and cast(PRDay as DATE) > '12/31/2014'
--and DATEPART(WEEK,prday) = @Weekno
group by S.SiteID,PRDay,SP.ProductCode, SP.SiteID, P.ProductCode
order by  SP.ProductCode


select SiteID, ProductCode ,sum([Weight]) as [weight], RegTime,@Weekno as WeekNO, avg(PricePerKg) as AvgPPK,convertedTotalValue
into #TMP1
from #TMP
--where  DATEPART(WEEK,prday) = @Weekno
group by SiteID,RegTime,prday,ProductCode,PricePerKg,convertedTotalValue
order by WeekNO



insert into dbo.Group_Frozen_Stock_Snapshot
select WeekNO,SiteID,ProductCode,[weight],regtime, AvgPPK,convertedTotalValue
from #TMP1
group by --
ProductCode,siteid,WeekNO,regtime,[weight], AvgPPK,convertedTotalValue


drop table #TMP1
drop table #TMP

END
GO
