SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 15/04/2015
-- Description:	displaying all production manual stock
-- =============================================

-- exec [HR_GetManualQTY] 116703, 1, 982, 1

-- select top 100 * from [HR_Order_Allocation] where [InProductionStock] = 1 order by 1 desc

CREATE PROCEDURE [dbo].[HR_GetManualQTY] 
	-- Add the parameters for the stored procedure here
	 @OrderNo bigint,
	 @SubOrderNo int,
	 @HR_Box_No nvarchar(10),
	 @SiteId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	select 
		count(*) as Qty, 
		OrderNo,
		SubOrderNo,
		ProductCode,
		SiteID,
		DNOB,
		UseBy,
		InProductionStock,
		HR_BoxNo
	from
		[FFG_DW].[dbo].[HR_Order_Allocation] with (nolock)
	where 
		OrderNo=@OrderNo
		and 
		SubOrderNo=@SubOrderNo
		and 
		HR_BoxNo= @HR_Box_No
		and 
		SiteID = @SiteId
		and 
		[InProductionStock] =1
	group by 
		ProductCode, 
		OrderNo,
		SubOrderNo,
		SiteID,
		DNOB,
		UseBy,
		InProductionStock,
		HR_BoxNo
	
END
GO
