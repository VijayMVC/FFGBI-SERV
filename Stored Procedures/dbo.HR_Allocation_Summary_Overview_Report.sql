SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 09/06/2015
-- Description:	Report created for Management that show summary of order
-- =============================================
--exec [dbo].[HR_Allocation_Summary_Overview_Report]102343
CREATE PROCEDURE [dbo].[HR_Allocation_Summary_Overview_Report]
	-- Add the parameters for the stored procedure here
	@OrderNo Bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select  OS.[Group_Order_No] as OrderNo ,OS.Sub_Order_No as SubOrderNo,
cast(OS.Box_No as nvarchar(10))  as [BoxNo],
oA.ProductCode,
isnull(cast((select product_name from dbo.HR_Order_Summary_import where Group_Order_No = OA.OrderNo and  Sub_Order_No = OA.SubOrderNo and box_no = right(OA.productCode,3))as nvarchar(100)),os.product_name)	 as Product_name,
--OS.Product_Name as [ProductName], 
CONVERT(VARCHAR(10), OS.Delivery_Date, 103) as DeliveryDate, 
round(OS.Ordered_Qty,0) as OrderedQty,

(Select isnull(sum(round(Ordered_Qty,0)),0) from HR_Order_Summary_Import where Group_Order_No = cast(@OrderNo as nvarchar(max))and  (box_no is not null and round(Ordered_Qty,0) is not null)) as totalOrderedQty,

Sum(case when OA.siteid = 1 then 1 else 0 end) as FCQty,
--(select count(*) from stock_packs pk  LEFT JOIN Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site where Pk.ProductCode = OA.ProductCode and  pr.InventoryTypeID = 1 and pk.DNOB >= (OS.Delivery_Date - 1) and pk.UseBy >= (OS.Delivery_Date + 5) and siteid =1) as FCTotal,
Sum(case when OA.siteid = 2 then 1 else 0 end) as FOQty,
--(select count(*) from stock_packs pk  LEFT JOIN Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site where Pk.ProductCode = OA.ProductCode and  pr.InventoryTypeID = 1 and pk.DNOB >= (OS.Delivery_Date - 1) and pk.UseBy >= (OS.Delivery_Date + 5) and siteid =2) as FOTotal,
Sum(case when OA.siteid = 3 then 1 else 0 end) as FHQty,
--(select count(*) from stock_packs pk  LEFT JOIN Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site where Pk.ProductCode = OA.ProductCode and  pr.InventoryTypeID = 1 and pk.DNOB >= (OS.Delivery_Date - 1) and pk.UseBy >= (OS.Delivery_Date + 5) and siteid =3) as FHTotal,
--'4' as FDSite,
Sum(case when OA.siteid = 4 then 1 else 0 end) as FDQty,
--(select count(*) from stock_packs pk  LEFT JOIN Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site where Pk.ProductCode = OA.ProductCode and  pr.InventoryTypeID = 1 and pk.DNOB >= (OS.Delivery_Date - 1) and pk.UseBy >= (OS.Delivery_Date + 5) and siteid =4) as FDTotal,

Sum(case when OA.siteid = 5 then 1 else 0 end) as FGQty,
--(select count(*) from stock_packs pk  LEFT JOIN Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site where Pk.ProductCode = OA.ProductCode and  pr.InventoryTypeID = 1 and pk.DNOB >= (OS.Delivery_Date - 1) and pk.UseBy >= (OS.Delivery_Date + 5) and siteid =5) as FGTotal,

Sum(case when OA.siteid = 6 then 1 else 0 end) as FMMQty,
--(select count(*) from stock_packs pk  LEFT JOIN Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site where Pk.ProductCode = OA.ProductCode and  pr.InventoryTypeID = 1 and pk.DNOB >= (OS.Delivery_Date - 1) and pk.UseBy >= (OS.Delivery_Date + 5) and siteid =6) as FMMTotal,
 Sum(case when OA.siteid in(1,2,3,4,5,6) then 1 else 0 end) as totalqty
--cast(OS.VIP as bit) as VIP,
--OS.Comments,
,PT.[Description3]
Into #tmp
From HR_Order_Summary_Import OS (nolock)
left join dbo.HR_Order_Allocation OA (nolock) on OA.HR_BoxNo = OS.Box_No and OS.Group_Order_No = OA.OrderNo and OS.Sub_Order_No = OA.SubOrderNo
left join  [FFGSQL06].[FFGProductionPlan].[dbo].[HR_Product_Subs] PS (nolock) on OS.Box_no = PS.Boxno 
left join  [FFG_DW].[dbo].[ProductTypes] PT (nolock) on PS.[ProductTypeId] = PT.[ProductTypeID]
where (box_no is not null and Product_Name is not null)
and os.Group_Order_No = @OrderNo and round(OS.Ordered_Qty ,0) > 0
group by OS.Delivery_Date,OS.Ordered_Qty,OS.Group_Order_No,OS.Box_No,OS.Product_Name,OS.Sub_Order_No,OA.HR_BoxNo,OS.VIP,OS.Comments,PT.[Description3],oA.ProductCode,OA.OrderNo,OA.siteid,OA.SubOrderNo 
order by PT.[Description3]


select OrderNo,SubOrderNo,[BoxNo],ProductCode,Product_name,DeliveryDate,OrderedQty,sum(FCQty) as FCQty,sum(FOQty) as FOQty,sum(FHQty) as FHQty
,sum(FDQty) as FDQty,sum(FGQty) as FGQty,sum(FMMQty) as FMMQty,sum(totalqty) as totalqty,totalOrderedQty
from #tmp
group by productcode,[BoxNo],Product_name,OrderNo,SubOrderNo,DeliveryDate,OrderedQty,[Description3],totalOrderedQty--,FCQty,FOQty,FHQty,FDQty,FGQty,FMMQty,totalqty
order by [Description3]


END
GO
