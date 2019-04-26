SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason McDevitt
-- Create date: 31/03/15
-- Description:	Add Product from Pallet to Order
-- ============================================= 
--exec [dbo].[HR_AllocateStockToOrderByPallet] '102583','1','502810931',64547,3	,'06/25/15','07/07/15','931','2'
CREATE PROCEDURE [dbo].[HR_AllocateStockToOrderByPallet] 
	-- Add the parameters for the stored procedure here
	@OrderNo Bigint,
	@SubOrderNo int,
	@ProductCode nvarchar(15),
	@PalletId bigint,
	@SiteID int,
	@DNOB Datetime,
	@UseBy DateTime,
	@BoxNo nvarchar(10),
	@QtyToAdd int
	--@VIP int
AS
BEGIN
declare @today as datetime
declare @Orderdate as date

set @orderDate = (select cast(getdate() as date))
set @Today = (SELECT DATEADD(day, DATEDIFF(day, 0, getdate()), 0))
declare @OrderAllocationTemp TABLE
(
	[OrderNo] [bigint] NOT NULL,
	[SubOrderNo] [int] NOT NULL,
	[ProductCode] [nvarchar](15) NOT NULL,
	[PalletNo] [bigint] NOT NULL,
	[BoxNo] [nvarchar](18) NOT NULL,
	[SiteID] [int] NOT NULL,
	[Allocate] bit,
	[PalletID] [bigint] NULL,
	[DNOB] [datetime] NULL,
	[UseBy] [datetime] NULL
)



if(@PalletId ='9999')
begin set @PalletId = null end

declare @Modified int

set @Modified = (select Modified from dbo.HR_Order_Summary_import where Group_Order_No =@OrderNo and Box_No =@BoxNo and Sub_Order_no = @SubOrderNo)

--select @PalletId

insert into @OrderAllocationTemp
SELECT    @OrderNo, 
@SubOrderNo,
mat1.ProductCode, 
ISNULL(col.PalletNumber, ' ') AS Pallet,  
pk.SSCC,
pk.SiteID,
--case when  (@Qty - (select count(*) from HR_Order_Allocation OA2 where OA2.[ProductCode] = mat1.ProductCode and [OrderNo] = @OrderNo)) >= ROW_NUMBER() OVER (PARTITION BY mat1.ProductCode ORDER By mat1.ProductCode)  then 1 else    0 end as Allocate,
case when  (@QtyToAdd) >= ROW_NUMBER() OVER (PARTITION BY isnull(Pk.PalletId,9999),DNOB,UseBy ORDER By isnull(Pk.PalletId,9999),DNOB,UseBy)  then 1 else    0 end as AddToOrder,
Col.PalletId as  PalletId,
pk.DNOB as DNOB,
pk.UseBy as Useby

FROM         Stock_Packs AS pk WITH (nolock) INNER JOIN
					--Sites S WITH (nolock) on pk.SiteID = S.SiteID  INNER JOIN
                      Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode LEFT JOIN
                      Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site INNER JOIN
                      --ProductTypes PT ON mat1.materialtype = pt.ProductTypeID LEFT OUTER JOIN
                      Pallets AS col WITH (nolock) ON isnull(pk.PalletID,9999) = isnull(col.PalletID,9999) and pk.siteid = col.siteid LEFT OUTER JOIN
                      
                      ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode left outer join
                      CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID
                    --  left join dbo.HR_Order_Summary_Import OS (nolock) on OS.Group_Order_no = @Orderno and Sub_Order_no = @SubOrderNo
                      --left JOIN Lots lts (nolock) ON lts.LotID=pk.LotID and lts.siteid = pk.siteid 
WHERE  
--mat1.storageType = 1 
--and
 pr.InventoryTypeID = 1 
and not(pr.name like '%Gran%')
and (ISNULL(con.name, 'N/A') like '%HILTON%' OR ISNULL(con.name, 'N/A') like '%DROGHEDA%' )
and (pr.Name <> 'Order Returns'
or pr.Name <> 'Beef Returns') 
and  pr.Name <> 'Ready to Ship'
and pr.name <> 'Stock on hold'
and pr.name <> 'QC Stock'
and pr.name <> 'Blast Chill'
and pr.name <> 'QC Hold'
and pr.name <> 'Chill D Floor'
and NOT (pr.name like '%QC%') 
And Mat1.ProductCode = @ProductCode
and pk.DNOB = @DNOB
and pk.UseBy = @UseBy
and isnull(Pk.PalletId,9999) = isnull(@PalletId,9999)
and Pk.SiteID = @SiteID
and NOT EXISTS (select * FROM [FFG_DW].[dbo].[HR_Order_Allocation] oA3 where oA3.BoxNo  = pk.SSCC  and oA3.[SiteID] = pk.SiteID and oA3.OrderDate = @orderDate)

select * from @OrderAllocationTemp

Insert into HR_Order_Allocation
([OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby,HR_BoxNo,orderdate,Modified,VIP)
select [OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby,@BoxNo,@Orderdate,@Modified,0
from @OrderAllocationTemp
where allocate = 1


end
GO
