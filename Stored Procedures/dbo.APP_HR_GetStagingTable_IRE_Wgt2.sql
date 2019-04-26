SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		David Bogues
-- Create date: 2017-02-09
-- Description:	Gets the Contents of the HR IRE Staging Table
-- =============================================
CREATE PROCEDURE [dbo].[APP_HR_GetStagingTable_IRE_Wgt2]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- exec [APP_HR_GetStagingTable_IRE_Wgt2]

	--Update [FFG_DW].[dbo].[HR_Order_Summary_Import_IRE] 
	--Set [Org_Ordered_Qty]=[Ordered_Qty]
	--Where [Ordered_Qty]>0 And Not Box_No Is Null

	--Update i
	--Set i.Ordered_Qty=CEILING(i.Org_Ordered_Qty/b.AvgCaseWgt)
	--From [FFG_DW].[dbo].[HR_Order_Summary_Import_IRE] i
	--Left Join [FFGSQL03].[FFGData].[dbo].[HRBoxWgtAvg] b On i.Box_No=b.BoxNo
	--Where Not i.Box_No Is Null And i.Ordered_Qty>0

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
	[FFG_DW].[dbo].[HR_Order_Summary_Import_IRE]  with (nolock)
Order By 
	RowNo asc
END
GO
