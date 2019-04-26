SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 07/08/2014
-- Description:	Tesco Hilton Total weight by week
-- =============================================
CREATE PROCEDURE [dbo].[Hilton_Total_Weight_Weekly] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Select SN.name,HW.Date,isnull(HW.TotalWeight,0) as TotalWeight, HW.Weekno, HW.Period,HW.productType
	
	From Hilton_Dispatch_Weight HW (nolock)
	inner join sites SN (nolock) on HW.Site = SN.SiteId
	where weekno is not null and [date] >= '01/01/2018'

END
--exec [Hilton_Total_Weight_Weekly] 
GO
