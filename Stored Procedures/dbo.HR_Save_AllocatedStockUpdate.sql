SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Tompson / David Bogues (updated)
-- Create date: 2017-01-26 (updated)
-- Description:	Saves Hilton Order Allocation. I have moved it here because Tommy had it hardcoded in WebPage
-- =============================================
CREATE PROCEDURE [dbo].[HR_Save_AllocatedStockUpdate] 

	@OrderNo bigint,
	@SubOrderNo int,
	@BoxNo nvarchar(10),
	@VIP bit,
	@Comments nvarchar(500),
	@SiteComments nvarchar(100)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update 
		[HR_Order_Summary_import] 
	set 
		VIP = @VIP, 
		comments = @Comments,
		site_comments = @SiteComments
	where 
		Group_Order_No = @OrderNo 
		and 
		Sub_Order_no = @SubOrderNo 
		and 
		Box_No = @BoxNo
END
GO
