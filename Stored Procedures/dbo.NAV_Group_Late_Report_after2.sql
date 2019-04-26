SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 27/01/2015
-- Description:	NaV Late report weekly
-- =============================================
CREATE PROCEDURE [dbo].[NAV_Group_Late_Report_after2] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select SP.[SalesName]
	  ,sum(isnull(LO.[total],0)) as total
      ,sum(isnull(LO.[after2pm],0)) as [after2pm] 
      --,sum(LO.[3monthsTotal]) as [3monthsTotal]
      --,sum(LO.[3monthsAfter2]) as [3monthsAfter2]
	  ,(sum(cast(isnull(LO.[after2pm],0.0)as decimal))/sum(cast(isnull(LO.[total],0.0)as decimal))*100) as percentageafter2
from dbo.[Group - NAV Late orders] LO (nolock)
inner join dbo.[Group - NAV sales person] SP (nolock) on LO.[SalesPersonCode] = SP.[SalesCode]
where (isnull(LO.[total],0) + isnull(LO.[after2pm],0))>0
and cast(snapshotdate as date) = cast(getdate() as date)
group by SP.[SalesName]
order by percentageafter2 desc
END
GO
