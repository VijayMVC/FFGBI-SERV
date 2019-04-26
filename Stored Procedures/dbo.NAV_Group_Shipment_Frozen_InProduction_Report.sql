SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 18/05/2015
-- Description:	Display total of production of frozen
-- =============================================

--exec [NAV_Group_Shipment_Frozen_InProduction_Report] 
CREATE PROCEDURE [dbo].[NAV_Group_Shipment_Frozen_InProduction_Report] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--exec [dbo].[NAV_Group_Shipment_Frozen_InProduction_total_insert]
--exec dbo.[NAV_Group_Shipment_Frozen_Total]

declare @WeekStart date , @endWeek date
set @WeekStart =(SELECT DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0))
set @endWeek =(SELECT DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0)+4)

--select * from NAV_Frozen_Production_total


select PT.[site],PT.[Type],cast(PT.[date] as date)as date,[total]
--isnull((select [total] from NAV_Frozen_Production_total where type = 'Boneless Beef' and [site] = PT.[site] and [date] = PT.[date]),0) as [Beef Summary],
--isnull((select [total] from NAV_Frozen_Production_total where type = 'Beef shipment' and [site] = PT.[site] and [date] = PT.[date]),0) as [Beef shipment],
--isnull((select [total] from NAV_Frozen_Production_total where type = 'Offal Summary' and [site] = PT.[site] and [date] = PT.[date]),0) as [Offal Summary],
--isnull((select [total] from NAV_Frozen_Production_total where type = 'Offal Summary' and [site] = PT.[site] and [date] = PT.[date]),0) as [offal shipment]

from NAV_Frozen_Production_total PT where cast([date] as date) between @WeekStart and @endWeek
order by [date]

END
GO
