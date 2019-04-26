SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 26/06/2015
-- Description:	created for confirming Qty for hilton donegal
-- =============================================
CREATE PROCEDURE [dbo].[HR_Confirmed_Hilton_Order_QTY_Report_IRE] 
	-- Add the parameters for the stored procedure here
	@OrderNo bigint,
	@SubOrder int
AS

-- exec [HR_Confirmed_Hilton_Order_QTY_Report_IRE] 116947, 1

--declare @SubOrderNo as nvarchar(5)

--if @SubOrder =1
--set @SubOrderNo = '1';
--else if @SubOrder =2
--set @SubOrderNo = '2'


BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
select 
	
	OS.Rowno as RowNo,


	isnull(OS.Box_no,'') as BoxNo, 
	isnull(OS.Product_Name,'')as ProductName,
	isnull(OS.Ordered_Qty,'')OrderedQTY ,
	isnull(isnull(
		cast(( 
		select Sum(
			case when OA.siteid in(1,2,3,4,5,6) then 1 
			else 0 end) as TotalconfirmedQTY 
		from
			dbo.HR_Order_Allocation OA with (nolock)
		where 
			right(OA.productcode,3) = OS.Box_no 
			and 
			datepart(year,oA.OrderDate) = DATEPART(year, getdate())
			and 
			suborderno =@SubOrder--in(@SubOrderNo)
			and 
			OA.OrderNo = Group_Order_No)as nvarchar(max)),OS.Confirmed_Qty),''
		) as TotalconfirmedQTY,

	isnull(isnull(cast(( 
		select 
			Sum(case when OA.siteid in(4) then 1 else 0 end) as DonegalQTY 
		from 
			dbo.HR_Order_Allocation OA with (nolock)
		where
			right(OA.productcode,3) = OS.Box_no 
			and 
			datepart(year,oA.OrderDate) = DATEPART(year, getdate())
			and 
			suborderno in(@SubOrder)
			and 
			OA.OrderNo = Group_Order_No)as nvarchar(max)),OS.Confirmed_Qty),''
		) as DonegalQTY

From 
	dbo.HR_Order_Summary_import OS with (nolock)
		left join [FFGSQL06].FFGProductionPlan.dbo.HR_Product_Subs PS with (nolock)
			on PS.boxno = OS.box_no
where 
	Group_Order_No = @OrderNo 
	and 
	sub_order_no = @SubOrder
--order by OS.Group_Order_No
group by 
	OS.Box_no,
	OS.Product_Name,
	OS.Ordered_Qty,
	OS.Group_Order_No,
	OS.Confirmed_Qty,os.RowNo
order by 
	OS.Rowno asc

--select * from dbo.HR_Order_Allocation OA 

END
GO
