SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <08/03/2017>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Hilton_Total_Weight_Weekly_ALL_Export] 

--exec [Hilton_Total_Weight_Weekly_ALL_Export] '4057'
@Customer int

AS

BEGIN

Select 

Case when [site] = '1' then 'Foyle Campsie'
	 when [site] = '2' then 'Foyle Omagh'
	 when [site] = '3' then 'Foyle Hilton'
	 when [site] = '4' then 'Foyle Donegal'
	 when [site] = '5' then 'Foyle Gloucester'
	 when [site] = '6' then 'Foyle Melton Mowbray'
	 ELSE 'ERROR'
	 END AS [Site]
,[date], [totalweight], [weekno], [period], [producttype], 

Case when [customerno] = '2640' then 'Hilton Ireland'
	 when [customerno] = '4057' then 'Hilton Foods UK'
	 when [customerno] = '2125' then 'Hilton Meats Zandam'
	 when [customerno] = '2751' then 'Hilton Sweden'
	 when [customerno] = '3593' then 'Hilton Denmark'
	 when [customerno] = '3035' then 'Hilton Poland'
	 ELSE 'ERROR'
	 END AS Customer

FROM [FFG_DW].[dbo].[Hilton_Dispatch_Weight_ALL] HDWA

where HDWA.CustomerNo = @Customer


END

GO
