SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Daniel
-- Create date: 10/102015
-- Description:	<Description,,>
-- =============================================
--exec  [dbo].[Group_Frozen_Daily_Movement_Report_KH]
CREATE PROCEDURE [dbo].[Group_Frozen_Daily_Movement_Report_KH]
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
p.Conservation_Name as CustomerCat
	,p.Description1,
	case when fs.site in (1,2,3,5,6,7) then SUM(fs.Weight) * (select top 1 value from Product_Price pp where pp.ProductCode = fs.productcode and pp.SiteID = fs.site and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = fs.ProductCode and prdp.siteid = fs.site)) 
	when fs.site in (4) then SUM(fs.Weight) * ((select top 1 value from Product_Price pp where pp.ProductCode = p.productcode and pp.SiteID = fs.site and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = fs.ProductCode and prdp.siteid = fs.site))/@ExRate)
	else 0 end as convertedTotalValue,
	case when fs.site in (1,2,3,5,6,7) then (select top 1 value from Product_Price pp where pp.ProductCode = fs.productcode and pp.SiteID = fs.site and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = fs.ProductCode and prdp.siteid = fs.site))
	when fs.site in (4) then (select top 1 value from Product_Price pp where pp.ProductCode = fs.productcode and pp.SiteID = fs.site and ValueTo = (select max([ValueTo]) from Product_Price prdp where prdp.ProductCode = fs.ProductCode and prdp.siteid = fs.site))/@ExRate
	else 0 end as ppk
into #tmp
from [dbo].[FrozenStockInOut] fs
inner join Products p (nolock) on fs.ProductCode = p.ProductCode 
inner join ProductTypes pt(nolock) on p.MaterialType = pt.ProductTypeID
inner join ProductSpecs ps(nolock) on p.ProductCode = ps.ProductCode
inner join CustomerSpecs cs(nolock) on ps.SpecID = cs.SpecID
where cast(ImportDate as date) = @currentDate 
group by fs.ProductCode,fs.Value , fs.InOrOut,fs.Subjectid,fs.ImportDate,fs.Cat,fs.Customer,fs.[site],pt.Description3,p.Dimension1,cs.Name,pt.ProductTypeID,p.Dimension2,p.ProductCode,p.Dimension4,p.Description1,p.Conservation_Name



select ProductCode, SUM(weight) as [Weight], value, InOrOut, Subjectid,ImportDate,Cat,Customer,qty,CustomerCat,[Site],Description1, convertedTotalValue,ppk
from #tmp
where weight > 0.1
group by ProductCode,value, InOrOut, Subjectid,ImportDate,Cat,Customer,qty,CustomerCat,[site],Description1,convertedTotalValue,ppk

drop table #tmp 
-- exec [Group_Frozen_Daily_Movement_Report]
GO
