SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thompson / David Bogues (updated)
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[APP_HR_SaveOrderImport_ToLive_IRE]
	-- Add the parameters for the stored procedure here
	@GroupOrderNo bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into [FFG_DW].dbo.[HR_Order_Summary_Import]
([RowNo]
      ,[OrderDate]
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
   ,[FO_Comments]
      ,[FC_Comments]
      ,[FD_Comments]
      ,[FG_Comments]
      ,[FH_Comments]
      ,[FMM_Comments])


SELECT  
--ROW_NUMBER() OVER(ORDER BY [OrderDate]) 
RowNo AS Rowno,
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
   ,0
   ,0
   ,0
   ,0
   ,0
   ,0
   FROM [FFG_DW].[dbo].[HR_Order_Summary_import_IRE]
   where [Group_Order_No] = @GroupOrderNo
   
    order by [RowNo] asc

END
GO
