SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason McDevitt
-- Create date: 16/04/2015
-- Description:	Allocate STock to HR Order
-- =============================================
--exec [dbo].[HR_AllocateStockToOrder] '102133','5','982',0
CREATE PROCEDURE [dbo].[HR_AllocateStockToOrder] 
	-- Add the parameters for the stored procedure here
	@OrderNo Bigint,
	@OrderSubNo int,
	@BoxNo nvarchar(20),
	@Modified int
AS
BEGIN
declare @today as datetime
set @Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))
declare @OrderAllocationTemp TABLE
(
	[OrderNo] [bigint] NOT NULL,
	[SubOrderNo] [int] NOT NULL,
	[ProductCode] [nvarchar](15) NOT NULL,
	[PalletNo] [bigint] NOT NULL,
	[BoxNo] nvarchar(20) NOT NULL,
	[SiteID] [int] NOT NULL,
	[Allocate] bit,
	[PalletID] [bigint] NULL,
	[DNOB] [datetime] NULL,
	[UseBy] [datetime] NULL,
	[HR_BoxNo] nvarchar(10)	,
	[OrderDate] date,
	PalletQty int
)


-------------------------------------------------------------------------------------------
--Allocate 1St Choice Products with atleast 2 days life left but no greater than 7
-------------------------------------------------------------------------------------------
--insert into @OrderAllocationTemp
--SELECT    --HR.OrderNO, 
--Hr.Group_Order_No as [OrderNo],
--HR.Sub_Order_No as [SubOrderNo],
--pk.ProductCode, 
--ISNULL(col.PalletNumber, ' ') AS Pallet,  
--pk.SSCC,
--pk.SiteID,
--case when  (round(HR.[Ordered_Qty],0) - (select count(*) from HR_Order_Allocation OA2 where OA2.[ProductCode] = mat1.ProductCode and [OrderNo] = @OrderNo)) >= ROW_NUMBER() OVER (PARTITION BY mat1.ProductCode ORDER By mat1.ProductCode)  then 1 else    0 end as Allocate,
--Col.PalletId as  PalletId,
--pk.DNOB as DNOB,
--pk.UseBy as Useby,
--HR.Box_No
--FROM	HR_Order_Summary_import AS HR  INNER JOIN
-- [FFGProductionPlan].[dbo].HR_Product_Subs AS HPS  ON HR.Box_No = HPS.BoxNo INNER JOIN
--		Stock_Packs AS pk WITH (nolock) ON pk.ProductCode = HPS.ProductCode Inner Join
--		Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode Inner Join
--		Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site INNER JOIN
--		--had to put isnull with 9999 to collect packs that are not on pallets. 
--		Pallets AS col WITH (nolock) ON isnull(pk.PalletID,9999) = isnull(col.PalletID,9999) and pk.siteid = col.siteid LEFT OUTER JOIN
--		ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode left outer join
--		CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID 
		
--WHERE  HR.Box_No = @BoxNo and pk.siteid <>4 and 
--HR.Group_Order_no = @OrderNo and Hr.Sub_Order_no =  @OrderSubNo 
----and mat1.storageType = 1 
--and not(pr.name like '%Gran%')
--and pr.InventoryTypeID = 1 
--and ISNULL(con.name, 'N/A') like '%HILTON%'
--and round(HR.[Ordered_Qty],0) > 0
--and(HR.box_no is not null and Hr.Ordered_Qty is not null)
--and pk.DNOB <= (HR.Delivery_Date + 1) and pk.UseBy >= (HR.Delivery_Date + 5)
--and NOT EXISTS (select * FROM [FFG_DW].[dbo].[HR_Order_Allocation] oA3 where oA3.BoxNo  = pk.SSCC and [OrderNo] = @OrderNo and oA3.[SiteID] = pk.SiteID)
--order by datediff("d", @Today, pk.UseBy), mat1.ProductCode
------------------------------------------------------------------------------------------------------------------------
--Insert into HR_Order_Allocation
--([OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby, [HR_BoxNo] )
--select [OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby, [HR_BoxNo] 
--from @OrderAllocationTemp
--where allocate = 1
---------------------------------------------------------------------------------------------------------------------------
--delete from @OrderAllocationTemp
-------------------------------------------------------------------------------------------
--Allocate Substitute Products
-------------------------------------------------------------------------------------------
insert into @OrderAllocationTemp
SELECT     
Hr.Group_Order_No as [OrderNo],
HR.Sub_Order_No as [SubOrderNo],
pk.ProductCode, 
ISNULL(col.PalletNumber, ' ') AS Pallet,  
pk.SSCC,
pk.SiteID,
--round(HR.[Ordered_Qty],0) as Ordered,
--(select count(*) from HR_Order_Allocation OA2 where OA2.[HR_BoxNo] = HR.Box_No and [OrderNo] = @OrderNo) as Allocated,
Case when (round(HR.[Ordered_Qty],0) - (select count(*) from HR_Order_Allocation OA2 where OA2.[HR_BoxNo] = HR.Box_No and [OrderNo] = @OrderNo and SubOrderNo =@OrderSubNo )) >= 
ROW_NUMBER() OVER (PARTITION BY HR.Box_No ORDER By HR.Box_No,datediff("d", @Today, pk.UseBy)) then 1 else 0 end as Allocate ,
Col.PalletId as  PalletId,
pk.DNOB as DNOB,
pk.UseBy as Useby,
HR.Box_No,
cast(HR.OrderDate as date) as OrderDate,
(select Count(*) from Stock_Packs SP (nolock) where SP.Palletid = pk.palletid and SP.DNOB = Pk.DNOB and SP.useby = pk.useby) as qty 
FROM	HR_Order_Summary_import AS HR  INNER JOIN
 [FFGSQL06].[FFGProductionPlan].[dbo].HR_Product_Subs AS HPS  ON HR.Box_No = HPS.BoxNo cross apply
 [dbo].[Split](HPS.Substitues,',') S  INNER JOIN
 Stock_Packs AS pk WITH (nolock) ON cast(pk.ProductCode as Nvarchar(15))  = S.Item Inner Join
		Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode Inner Join
		Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site INNER JOIN
		--had to put isnull with 9999 to collect packs that are not on pallets. 
		Pallets AS col WITH (nolock) ON isnull(pk.PalletID,9999) = isnull(col.PalletID,9999) and pk.siteid = col.siteid LEFT OUTER JOIN
		ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode left outer join
		CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID 
		
WHERE  HR.Box_No = @BoxNo 
and pk.siteid <>4 
AND pk.SiteID <> 7 -- added by KH to remove FI stock getting allocated 21/03/18
and HR.Group_Order_no = @OrderNo and Hr.Sub_Order_no =  @OrderSubNo 
and mat1.storageType = 1 
--and NOT(pr.[site] = 1 and pr.[InventoryID] = '70')		--remvoed by KH 06/09/18 Rory says Chill C in Campsie is now good to use
and not(pr.name like '%Gran%')
and pr.InventoryTypeID = 1 
and pr.Name <> 'Order Returns'
and pr.Name <> 'Beef Returns'
and  pr.Name <> 'Ready to Ship'
and NOT (pr.name like '%QC%')
and pr.name <> 'QC Hold'
and pr.Name <> 'Sawyers Intransit' -- added by Kh to exclude on ROB's request 19/04/18
and pr.Name <> 'Omagh Intransit' -- added by MMG to exclude on ROB's request 18/07/18
and NOT(pr.Name like '%Annesborough Intransit%') -- added by MMG to exclude on ROB's request 18/07/18
and pr.Name <> 'Returns'
and pr.Name <> 'Blast Chill'
and pr.name <> 'Stock on hold'
and pr.name <> 'QC Stock'
and pr.name <> 'Chill D Floor' 
and (ISNULL(con.name, 'N/A') like '%HILTON%' OR ISNULL(con.name, 'N/A') like '%DROGHEDA%' )
and round(HR.[Ordered_Qty],0) > 0
and(HR.box_no is not null and Hr.Ordered_Qty is not null)
and pk.DNOB <= (HR.Delivery_Date + 1) and pk.UseBy >= (HR.Delivery_Date + 2)
and not(pk.siteid =2 and pk.InventoryID = 17)
and NOT EXISTS (select * FROM [FFG_DW].[dbo].[HR_Order_Allocation] oA3 where oA3.BoxNo  = pk.SSCC and oA3.[SiteID] = pk.SiteID and oA3.OrderDate = cast(HR.OrderDate as date))
order by 
datediff("d", @Today, pk.UseBy) asc,qty desc,HR.Box_No,Pallet
----------------------------------------------------------------------------------------------------------------------
Insert into HR_Order_Allocation
([OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby, [HR_BoxNo],OrderDate,Modified)
select [OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby, [HR_BoxNo], Orderdate,@Modified
from @OrderAllocationTemp
where allocate = 1
order by [BoxNo]
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
delete from @OrderAllocationTemp
-------------------------------------------------------------------------------------------
--Allocate P2 Substitute Products
-------------------------------------------------------------------------------------------
--insert into @OrderAllocationTemp
--SELECT     
--Hr.Group_Order_No as [OrderNo],
--HR.Sub_Order_No as [SubOrderNo],
--pk.ProductCode, 
--ISNULL(col.PalletNumber, ' ') AS Pallet,  
--pk.SSCC,
--pk.SiteID,
--Case when (round(HR.[Ordered_Qty],0) - (select count(*) from HR_Order_Allocation OA2 where OA2.[HR_BoxNo] = HR.Box_No and [OrderNo] = @OrderNo and SubOrderNo =@OrderSubNo )) >= 
--ROW_NUMBER() OVER (PARTITION BY HR.Box_No ORDER By HR.Box_No,datediff("d", @Today, pk.UseBy)) then 1 else 0 end as Allocate ,
--Col.PalletId as  PalletId,
--pk.DNOB as DNOB,
--pk.UseBy as Useby,
--HR.Box_No,
--cast(HR.OrderDate as date) as OrderDate,
--(select Count(*) from Stock_Packs SP where SP.Palletid = pk.palletid and SP.DNOB = Pk.DNOB and SP.useby = pk.useby) as qty 
--FROM	HR_Order_Summary_import AS HR  INNER JOIN
-- [FFGProductionPlan].[dbo].HR_Product_Subs AS HPS  ON HR.Box_No = HPS.BoxNo Cross Apply
-- [dbo].[Split](HPS.SubstituesP2,',') S  INNER JOIN
-- Stock_Packs AS pk WITH (nolock) ON cast(pk.ProductCode as Nvarchar(15))  = S.Item Inner Join
--		Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode Inner Join
--		Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site INNER JOIN
--		--had to put isnull with 9999 to collect packs that are not on pallets. 
--		Pallets AS col WITH (nolock) ON isnull(pk.PalletID,9999) = isnull(col.PalletID,9999) and pk.siteid = col.siteid LEFT OUTER JOIN
--		ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode left outer join
--		CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID 
		
--WHERE  HR.Box_No = @BoxNo and pk.siteid <>4 and 
--HR.Group_Order_no = @OrderNo and Hr.Sub_Order_no =  @OrderSubNo 
--and mat1.storageType = 1 
--and NOT(pr.[site] = 1 and pr.[InventoryID] = '70')
--and not(pr.name like '%Gran%')
--and pr.InventoryTypeID = 1 
--and pr.Name <> 'Order Returns'
--and ISNULL(con.name, 'N/A') like '%HILTON%'
--and round(HR.[Ordered_Qty],0) > 0
--and(HR.box_no is not null and Hr.Ordered_Qty is not null)
--and pk.DNOB <= (HR.Delivery_Date + 1) and pk.UseBy >= (HR.Delivery_Date + 2)
--and not(pk.siteid =2 and pk.InventoryID = 17)
--and NOT EXISTS (select * FROM [FFG_DW].[dbo].[HR_Order_Allocation] oA3 where oA3.BoxNo  = pk.SSCC and oA3.[SiteID] = pk.SiteID and oA3.OrderDate = cast(HR.OrderDate as date))
--order by 
--datediff("d", @Today, pk.UseBy) asc,qty desc,HR.Box_No,Pallet

------------------------------------------------------------------------------------------------------------------------
Insert into HR_Order_Allocation
([OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby, [HR_BoxNo],orderdate,Modified,VIP )
select [OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby, [HR_BoxNo], Orderdate,@Modified,0 
from @OrderAllocationTemp
where allocate = 1
-------------------------------------------------------------------------------------------------------------------------

end
GO
