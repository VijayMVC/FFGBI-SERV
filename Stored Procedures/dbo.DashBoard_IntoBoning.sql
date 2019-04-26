SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DashBoard_IntoBoning]
	@SiteID int = 1,
	@Week int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select --Mat.Name as Product,
right('0' + Lot.Code,2) as LotNo,Lot.Name as Lot, round(sum(weight),2) as Wgt, count(*) as Qty
from [FM-SQL01].[innova].[dbo].Proc_matxacts  X inner join
 [FM-SQL01].[innova].[dbo].vw_matswithNoXML AS mat ON x.material = mat.material INNER JOIN
 [FM-SQL01].[innova].[dbo].vw_LotswithNoXML as lot ON x.tolot = lot.lot
WHERE  
lot.dimension1 = '1' and (not mat.code In('999999','999998')) and --scale check
 ((x.item IS NULL) AND (x.pack IS NULL)) AND (x.xactpath in( 2,3)) AND (x.rtype IN (1)) 
AND DatePart(wk,x.regtime) = DatePart(wk,getdate())
group By 
--Mat.Name,
right('0' + Lot.Code,2),Lot.Name

--union
--select 'Total',null,null, round(sum(weight),2) as Wgt, count(*) as Qty
--from [FM-SQL01].[innova].[dbo].Proc_matxacts  X inner join
-- [FM-SQL01].[innova].[dbo].vw_matswithNoXML AS mat ON x.material = mat.material INNER JOIN
-- [FM-SQL01].[innova].[dbo].vw_LotswithNoXML as lot ON x.tolot = lot.lot
--WHERE  
--lot.dimension1 = '1' and (not mat.code In('999999','999998')) and --scale check
-- ((x.item IS NULL) AND (x.pack IS NULL)) AND (x.xactpath in( 2,3)) AND (x.rtype IN (1)) 
--AND x.regtime >= getdate() -0.5
order by right('0' + Lot.Code,2)
END
GO
