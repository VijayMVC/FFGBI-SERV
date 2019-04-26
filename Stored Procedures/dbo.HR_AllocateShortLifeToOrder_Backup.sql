SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 05/08/2014
-- Description:	hot products Fresh report with Out of Date Stock
-- =============================================
--exec [dbo].[HR_AllocateShortLifeToOrder] '99343','1'
Create PROCEDURE [dbo].[HR_AllocateShortLifeToOrder_Backup] 
	-- Add the parameters for the stored procedure here
	@OrderNo Bigint,
	@OrderSubNo int
AS
BEGIN

declare @OrderAllocationTemp TABLE
(
	[OrderNo] [bigint] NOT NULL,
	[SubOrderNo] [int] NOT NULL,
	[ProductCode] [nvarchar](15) NOT NULL,
	[PalletNo] [bigint] NOT NULL,
	[BoxNo] [bigint] NOT NULL,
	[SiteID] [int] NOT NULL,
	[Allocate] bit,
	[PalletID] [bigint] NULL,
	[DNOB] [datetime] NULL,
	[UseBy] [datetime] NULL,
	[HR_BoxNo] nvarchar(10)
)
declare @today as datetime
set @Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))

insert into @OrderAllocationTemp
SELECT    --HR.OrderNO, 
Hr.Group_Order_No as [OrderNo],
HR.Sub_Order_No as [SubOrderNo],
mat1.ProductCode, 
ISNULL(col.PalletNumber, ' ') AS Pallet,  
pk.SSCC,
pk.SiteID,
case when  (cast(HR.[Ordered_Qty]as int) - (select count(*) from HR_Order_Allocation OA2 where OA2.[ProductCode] = mat1.ProductCode and [OrderNo] = @OrderNo)) >= ROW_NUMBER() OVER (PARTITION BY mat1.ProductCode ORDER By mat1.ProductCode)  then 1 else    0 end as Allocate,
Col.PalletId as  PalletId,
pk.DNOB as DNOB,
pk.UseBy as Useby,
HR.Box_No

FROM         Stock_Packs AS pk WITH (nolock) INNER JOIN
                      Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode LEFT JOIN
                      Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site INNER JOIN
                      Pallets AS col WITH (nolock) ON pk.PalletID = col.PalletID and pk.siteid = col.siteid
                      LEFT OUTER JOIN
                      ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode left outer join
                      CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID
                      inner join [FFG_DW].[dbo].[HR_Product_Subs] HPS on HPS.ProductCode = Mat1.ProductCode
                      inner join [FFG_DW].[dbo].[HR_Order_Summary_Import] HR on HR.Box_No = HPS.BoxNo
WHERE  
HR.Group_Order_NO = @OrderNo and  HR.[Sub_Order_No] = @OrderSubNo 
and mat1.storageType = 1 
and pr.InventoryTypeID = 1 
and (datediff("d", @Today,pk.UseBy) > = 1) and
 (datediff("d", @Today,pk.UseBy) < = 7)
and ISNULL(con.name, 'N/A') like '%HILTON%'
and(HR.box_no is not null and Hr.product_name is not null)
and cast(HR.[Ordered_Qty] as int) > 0
and NOT EXISTS (select * FROM [FFG_DW].[dbo].[HR_Order_Allocation] oA3 where oA3.BoxNo  = pk.SSCC and [OrderNo] = @OrderNo and oA3.[SiteID] = pk.SiteID)
order by datediff("d", @Today, pk.UseBy), mat1.ProductCode

Insert into HR_Order_Allocation
([OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby,[HR_BoxNo] )
select [OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby,[HR_BoxNo] from @OrderAllocationTemp
where allocate = 1


end
GO
