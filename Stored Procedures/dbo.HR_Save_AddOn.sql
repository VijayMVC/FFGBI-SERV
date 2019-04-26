SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thompson / David Bogues (updated)
-- Create date: 2017-01-20
-- Description:	Tommy had this logic hardcoded inside the App. Moving as SP for migration to new portal
-- =============================================
CREATE PROCEDURE [dbo].[HR_Save_AddOn]
	
	-- Add the parameters for the stored procedure here
	@OrderNo bigint,
	@BoxNo nvarchar(10),
	@TotalQty int,
	@NewQty int,
	@SubOrderNo int,
	@OrderDate datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- exec HR_Save_AddOn 101833, 249, 17, 17, 1, '2015-06-02'

    -- Insert statements for procedure here
	UPDATE
		dbo.HR_Order_Summary_import 
	SET
		Org_Ordered_Qty = @TotalQty,
		Ordered_Qty = @NewQty, 
		Modified = 1, 
		Orderdate = @Orderdate 
	WHERE
		Group_Order_No = @OrderNo 
		and 
		Box_No = @BoxNo 
		and 
		Sub_Order_no = @suborderno
END
GO
