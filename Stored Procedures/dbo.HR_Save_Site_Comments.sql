SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[HR_Save_Site_Comments]
	@OrderNo nvarchar(40),
	@SubOrderNo nvarchar(40),
	@Box_No nvarchar(40),
	@SelectedValues nvarchar(40)
	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


  Update HR_Order_Summary_Import 
  Set Site_Comments =  @SelectedValues  
  where Group_Order_No = @OrderNo  and Sub_Order_No = @SubOrderNo  and Box_No =@Box_No 
 

END
GO
