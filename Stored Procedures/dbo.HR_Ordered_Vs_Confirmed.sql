SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 19/05/2015
-- Description:	Compare to what has been ordered to what has been confirmed
-- =============================================
--exec HR_Ordered_Vs_Confirmed 100543
CREATE PROCEDURE [dbo].[HR_Ordered_Vs_Confirmed] 
	-- Add the parameters for the stored procedure here
	@OrderNo Bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select  OS.[Group_Order_No] as OrderNo ,OS.Sub_Order_No as SubOrderNo,
OS.Box_No  as [BoxNo],
OS.Product_Name as [ProductName], 
CONVERT(VARCHAR(10), OS.Delivery_Date, 103) as DeliveryDate, 
round(OS.Ordered_Qty,0) as TotalOrderedQty,
Sum(case when OA.siteid in(1,2,3,4,5,6) then 1 else 0 end) as confirmedQty
From HR_Order_Summary_Import OS (nolock)
left join dbo.HR_Order_Allocation OA (nolock) on OA.HR_BoxNo = OS.Box_No and OS.Group_Order_No = OA.OrderNo
where (box_no is not null and Product_Name is not null)
and os.Group_Order_No = @OrderNo and round(OS.Ordered_Qty ,0) > 0
group by OS.Delivery_Date,OS.Ordered_Qty,OS.Group_Order_No,OS.Box_No,OS.Product_Name,OS.Sub_Order_No,OA.HR_BoxNo,OS.VIP,OS.Comments
order by productname

END
GO
