SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Thomas Tompson / David Bogues (updated)
-- Create date: 2017-01-27 (updated)
-- Description:	Moved from Tommy's hardcoded SQL in App to SP for HR V2.0
-- =============================================
CREATE PROCEDURE [dbo].[HR_DeleteManualAllocation]
	-- Add the parameters for the stored procedure here
	@OrderNo bigint,
	@SubOrderNo int,
	@ProductCode bigint,
	@SiteId int,
	@BoxNo nvarchar(10),
	@DNOB datetime,
	@UseBy datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete from 
		[HR_Order_Allocation] 
	where 
		OrderNo = @OrderNo 
		and 
		SubOrderNo = @SubOrderNo 
		and 
		ProductCode = @ProductCode 
		and 
		SiteID = @SiteID 
		and 
		HR_BoxNo = @BoxNo 
		and 
		isnull(DNOB,'1960-01-01 00:00:00.000') = @DNOB 
		and 
		isnull(UseBy,'1960-01-01 00:00:00.000') = @UseBy 
		and 
		[InProductionStock] = 1
END
GO
