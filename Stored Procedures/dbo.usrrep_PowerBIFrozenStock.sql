SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<kelsey brennan>
-- Create date: <21/07/2017>
-- Description:	<frozen stock on a sunday>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_PowerBIFrozenStock]
	-- Add the parameters for the stored procedure here
--exec 	[dbo].[usrrep_PowerBIFrozenStock]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT 
  ds.[Date]
      ,DATEPART(wk,[Date]) as 'Week'
	  --,DATENAME(ISO_WEEK,[Date]) as 'Week' 
	  ,DATEPART(YYYY,[Date]) as'Year'
	  ,DATENAME(DW,[date]) as'Day'
	 

	  ,case when  s.[name]='FFG Group Site for Pricing'
	  then'Foyle Ingredients'
	  else s.[name]
	  end as [name]


      --,ds.[ProductCode]
      ,Sum([Total]) as 'Total Weight'
      
	  ,max([Regtime]) 'Time'
     -- ,[AvgPPK]
      ,round(Sum([CovertedTotalValue]),2)as'Total Value GBP'
	  ,p.[Conservation_Name]
	 -- ,p.Conservation
	  
  FROM [FFG_DW].[dbo].[Group_Frozen_Stock_Snapshot_daily] ds
  left outer join [FFG_DW].[dbo].[Products] p on ds.ProductCode=p.ProductCode
  left outer join [FFG_DW].[dbo].[Sites] s on ds.[siteid] =s.[siteid]
  where p.[Conservation_Name] is not null
  and DATENAME(DW,[date])='friday'

  group by 
   p.[Conservation_Name]
   ,ds.[Date]
 -- ,ds.[ProductCode]
 ,s.[name]
  --,p.Conservation
   
  order by [Year] desc


END
GO
