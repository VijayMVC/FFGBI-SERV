SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 28/01/2015
-- Description:	Nav late order for 3 months
-- =============================================
CREATE PROCEDURE [dbo].[NAV_Group_Late_3Months] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  
select SP.[SalesName]
	  --,sum(isnull(LO.[total],0)) as total
     --,sum(isnull(LO.[after2pm],0)) as [after2pm] 
      ,sum(isnull(LO.[3monthsTotal],0)) as [3monthsTotal]
      ,sum(isnull(LO.[3monthsAfter2],0)) as [3monthsAfter2]
	  ,(sum(cast(isnull(LO.[3monthsAfter2],0.0)as decimal))/sum(cast(isnull(LO.[3monthsTotal],0.0)as decimal))*100) as percentageafter2
from dbo.[Group - NAV Late orders] LO (nolock)
inner join dbo.[Group - NAV sales person] SP (nolock) on LO.[SalesPersonCode] = SP.[SalesCode]
where (isnull(LO.[3monthsTotal],0) + isnull(LO.[3monthsAfter2],0))>0
and cast(snapshotdate as date) = cast(getdate() as date)
group by SP.[SalesName]
order by percentageafter2 desc
END
GO
