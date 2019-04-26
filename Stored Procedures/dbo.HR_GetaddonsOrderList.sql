SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 05/06/2015
-- Description:	get the list for the add ons
-- =============================================

-- exec HR_GetaddonsOrderList 101923
CREATE PROCEDURE [dbo].[HR_GetaddonsOrderList]
	-- Add the parameters for the stored procedure here
	@OrderNo Bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT 
		Group_Order_No as OrderNo,
		Sub_Order_no as SubOrderno,
		Box_No as BoxNo,
		Product_Name as Productname,
		Delivery_Date as DeliveryDate, 
		Ordered_Qty as totalqty
	FROM 
		dbo.HR_Order_Summary_import with (nolock)
	WHERE 
		Group_Order_No = @OrderNo
		and 
		Box_No is not null 
		and 
		Product_Name is not null
		
END
GO
