SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		David Bogues
-- Create date: 2017-02-09
-- Description:	Gets the Contents of the HR UK Staging Table
-- =============================================
CREATE PROCEDURE [dbo].[APP_HR_GetStagingTable_UK]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- exec APP_HR_GetStagingTable_UK

    -- Insert statements for procedure here
	SELECT 
	   [RowNo],
	   [OrderDate]
      ,[Group_Order_No]
      ,[Delivery_Date]
      ,[Sub_Order_no]
      ,[Box_No]
      ,[Product_Name]
      ,[Ordered_Qty]
      ,[Confirmed_Qty]
      ,[Siteid]
      ,[Processed]
      ,[VIP]
      ,[Comments]
      ,[Modified]
      ,[Org_Ordered_Qty]
  FROM 
	[FFG_DW].[dbo].[HR_Order_Summary_Import_UK]  with (nolock)
	Order by [RowNo] asc

END
GO
