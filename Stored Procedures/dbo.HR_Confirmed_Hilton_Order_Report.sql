SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 02/06/2015

-- Description:	create a report that allows tesco team send back orders
-- =============================================

--exec [HR_Confirmed_Hilton_Order_Report] 124643,1

CREATE PROCEDURE [dbo].[HR_Confirmed_Hilton_Order_Report] 
	-- Add the parameters for the stored procedure here
	@OrderNo bigint--,
	--@SubOrder int
AS
--declare @SubOrderNo as nvarchar(5)

--if @SubOrder =1
--set @SubOrderNo = '1';
--else if @SubOrder =2
--set @SubOrderNo = '2'


BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
select isnull(OS.Box_no,'')as BoxNo, isnull(OS.Product_Name,'')as ProductName,
 isnull(OS.Ordered_Qty,'')OrderedQTY ,
isnull(isnull(cast(( select Sum(case when OA.siteid in(1,2,3,4,5,6) then 1 else 0 end) as TotalconfirmedQTY 
from dbo.HR_Order_Allocation OA 
where --OA.HR_BoxNO =OS.Box_no 
right(OA.productcode,3) = OS.Box_no 
and suborderno =1--in(@SubOrderNo)
and datepart(year,oA.OrderDate) = DATEPART(year, getdate())
and OA.OrderNo = Group_Order_No)as nvarchar(max)),OS.Confirmed_Qty),'') as TotalconfirmedQTY

--isnull(isnull(cast(( select Sum(case when OA.siteid in(2) then 1 else 0 end) as OmaghQTY 
--from dbo.HR_Order_Allocation OA 
--where --OA.HR_BoxNO =OS.Box_no 
--right(OA.productcode,3) = OS.Box_no 
--and suborderno in(@SubOrderNo)
--and OA.OrderNo = Group_Order_No)as nvarchar(max)),OS.Confirmed_Qty),'') as OmaghQTY,

--isnull(isnull(cast(( select Sum(case when OA.siteid in(1) then 1 else 0 end) as CampsieQTY 
--from dbo.HR_Order_Allocation OA 
--where --OA.HR_BoxNO =OS.Box_no 
--right(OA.productcode,3) = OS.Box_no 
--and suborderno in(@SubOrderNo)
--and OA.OrderNo = Group_Order_No)as nvarchar(max)),OS.Confirmed_Qty),'') as CampsieQTY,

--isnull(isnull(cast(( select Sum(case when OA.siteid in(3) then 1 else 0 end) as HiltonQTY 
--from dbo.HR_Order_Allocation OA 
--where --OA.HR_BoxNO =OS.Box_no 
--right(OA.productcode,3) = OS.Box_no 
--and suborderno in(@SubOrderNo)
--and OA.OrderNo = Group_Order_No)as nvarchar(max)),OS.Confirmed_Qty),'') as HiltonQTY,

--isnull(isnull(cast(( select Sum(case when OA.siteid in(5) then 1 else 0 end) as GloucesterQTY 
--from dbo.HR_Order_Allocation OA 
--where --OA.HR_BoxNO =OS.Box_no 
--right(OA.productcode,3) = OS.Box_no 
--and suborderno in(@SubOrderNo)
--and OA.OrderNo = Group_Order_No)as nvarchar(max)),OS.Confirmed_Qty),'') as GloucesterQTY

From dbo.HR_Order_Summary_import OS
left join [FFGSQL06].FFGProductionPlan.dbo.HR_Product_Subs PS on PS.boxno = OS.box_no
where Group_Order_No = @OrderNo and sub_order_no = 1 --in(@SubOrderNo)
--and datepart(year,os.OrderDate) = DATEPART(year, getdate())
--order by OS.Group_Order_No
order by OS.Rowno asc

--select * from dbo.HR_Order_Allocation OA 

END
GO
