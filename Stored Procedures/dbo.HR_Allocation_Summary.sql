SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 26/03/2015
-- Description:	Put all Allocation detail into 1 table for portal page
-- =============================================
--exec [dbo].[HR_Allocation_Summary] '102133',2
CREATE PROCEDURE [dbo].[HR_Allocation_Summary] 
	-- Add the parameters for the stored procedure here
	@OrderNo Bigint
	--@OrderSubNo int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	select  
		OS.[Group_Order_No] as OrderNo,
		OS.Sub_Order_No as SubOrderNo,
	OS.Box_No  as [BoxNo],
	OS.Product_Name as [ProductName], 
	CONVERT(VARCHAR(10), OS.Delivery_Date, 103) as DeliveryDate, 
	round(OS.Ordered_Qty,0) as TotalQty,
	'1' as FCSite,
	Sum(case when OA.siteid = 1 then 1 else 0 end) as FCQty,
	'2' as FOSite,
	Sum(case when OA.siteid = 2 then 1 else 0 end) as FOQty,
	'3' as FHSite,
	Sum(case when OA.siteid = 3 then 1 else 0 end) as FHQty,
	'4' as FDSite,
	Sum(case when OA.siteid = 4 then 1 else 0 end) as FDQty,
	'5' as FGSite,
	Sum(case when OA.siteid = 5 then 1 else 0 end) as FGQty,
	'6' as FMMSite,
	Sum(case when OA.siteid = 6 then 1 else 0 end) as FMMQty,
	(round(OS.Ordered_Qty,0) - Sum(
		case when OA.siteid in(1,2,3,4,5,6) then 1 else 0 end)) as RequiredQty,
	cast(OS.VIP as bit) as VIP,
	OS.Comments,
	cast(OS.FO_Comments as bit) as FO_Comment,
	cast(OS.FC_Comments as bit) as FC_Comment,
	cast(OS.FH_Comments as bit)as FH_Comment,
	cast(OS.FD_Comments as bit) as FD_Comment,
	cast(OS.FG_Comments as bit) as FG_Comment,
	cast(OS.FMM_Comments as bit) as FMM_Comment,
	OS.site_comments,
			case when PT.[Description3] = '101 - PRIMAL' and PM.StorageType ='1' then '101 - PRIMAL'
when PM.StorageType ='2' then '103 - Frozen'
when PT.[Description3] = '102 - VL'  then '102 - VL'
when PT.[Description3] = '103 - OFFAL' then '101 - PRIMAL'
else '101 - PRIMAL' end as [Description3]	


From HR_Order_Summary_Import OS (nolock)
left join dbo.HR_Order_Allocation OA (nolock) on OA.HR_BoxNo = OS.Box_No and OS.Group_Order_No = OA.OrderNo and OS.sub_order_No = OA.Suborderno
left join  [FFGSQL06].[FFGProductionPlan].[dbo].[HR_Product_Subs] PS (nolock) on OS.Box_no = PS.Boxno 
left join  [FFG_DW].[dbo].[ProductTypes] PT (nolock) on PS.[ProductTypeId] = PT.[ProductTypeID]
left join [FFG_DW].[dbo].[Products] PM (nolock) on OA.Productcode = pm.productcode
where (box_no is not null and Product_Name is not null)
and os.Group_Order_No = @OrderNo and round(OS.Ordered_Qty ,0) > 0
--and os.sub_order_no = @OrderSubNo
group by OS.Delivery_Date,OS.Ordered_Qty,OS.Group_Order_No,OS.Box_No,OS.Product_Name,OS.Sub_Order_No,OA.HR_BoxNo,OS.VIP,OS.Comments,PT.[Description3],FO_Comments,FC_Comments,FH_Comments,FD_Comments,FG_Comments,FMM_Comments,OS.site_comments,PM.StorageType
order by [Description3],PT.[Description3]																															 
			
			
																									 
END																																					  
																																					 
																																					  
GO
