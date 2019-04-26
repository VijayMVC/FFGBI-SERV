SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason McDevitt	
-- Create date: 27.03.15
-- Description:	Get Allocated Stock for adjustment Screen
-- =============================================
-- exec dbo.[HR_GetUnallocatedStockByProduct] '501910249',4, 99343,1,'03/28/15'
CREATE PROCEDURE [dbo].[HR_GetUnallocatedStockByProduct] 
	-- Add the parameters for the stored procedure here
	@ProductCode nvarchar(15),
	@SiteID int,
	@OrderNo Bigint,
	@SubOrderNo Bigint,
	@DeliveryDate Datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--select OrderNo,[SubOrderNo]
 --     ,HR.[ProductCode]
 --     ,P.Dimension4 as BoxNo
 --     ,[SiteID]
 --     ,[PalletNo]
 --     ,PalletId
 --     ,DNOB
 --     ,UseBy
 --     ,Count(*) as Qty
	--from HR_Order_Allocation HR
	--inner Join Products P on P.ProductCode = HR.ProductCode
	--where OrderNo =  @OrderNo and SuborderNo = @SubOrder and HR.ProductCode = @ProductCode and SiteID = @SiteID
	--group By OrderNo,[SubOrderNo],HR.[ProductCode],P.Dimension4,[PalletNo],[PalletId],[SiteID],PalletNo,DNOB,UseBy
	
	SELECT  @OrderNo as OrderNo, 
	@SubOrderNo as SubOrderNo, 
mat1.ProductCode, 
Mat1.Name As ProductName,
ISNULL(col.PalletNumber, ' ') AS PalletNo,  
pk.SiteID,
Col.PalletId as  PalletId,
pk.DNOB as DNOB,
pk.UseBy as Useby,
count(*) as PalletQty,
(select sum(cast(isnull([Ordered_Qty],0) as Int)) from [FFG_DW].[dbo].[HR_Order_Summary_Import] AS OI where  isnumeric(OI.[Box_No])=1 and cast(OI.[Box_No] as int) = Mat1.Dimension4 and OI.[Group_Order_No] = @OrderNo and OI.[Sub_Order_No] = @SubOrderNo ) 
-( select count(*) from HR_Order_Allocation AS OA where OA.[ProductCode] = mat1.ProductCode and OA.[OrderNo] = @OrderNo and OA.[SubOrderNo] = @SubOrderNo)
as QtyRequired
FROM         Stock_Packs AS pk WITH (nolock) INNER JOIN
					--Sites S WITH (nolock) on pk.SiteID = S.SiteID  INNER JOIN
                      Products AS mat1 WITH (nolock) ON pk.ProductCode = mat1.ProductCode LEFT JOIN
                      Inventories AS pr WITH (nolock) ON pr.InventoryID = pk.InventoryID and pk.siteid = pr.site INNER JOIN
                      --ProductTypes PT ON mat1.materialtype = pt.ProductTypeID LEFT OUTER JOIN
                      Pallets AS col WITH (nolock) ON pk.PalletID = col.PalletID and pk.siteid = col.siteid
                      LEFT OUTER JOIN
                      ProductSpecs as PS with (nolock) on mat1.ProductCode = ps.ProductCode left outer join
                      CustomerSpecs AS con WITH (nolock) ON ps.SpecID = con.SpecID
                      --left JOIN Lots lts (nolock) ON lts.LotID=pk.LotID and lts.siteid = pk.siteid 
                      inner join [FFG_DW].[dbo].[HR_Order_Summary_Import] HR on cast(HR.Box_No as int) = Mat1.[Dimension4]
WHERE  
Mat1.ProductCode = @ProductCode and pk.SiteID = @SiteID 
--and mat1.storageType = 1 
and pr.InventoryTypeID = 1 
and ISNULL(con.name, 'N/A') like '%HILTON%'
and cast(HR.[Ordered_Qty] as Int) > 0
and (pr.Name <> 'Order Returns'
or pr.Name <> 'Beef Returns') 
and  pr.Name <> 'Ready to Ship'
and pr.name <> 'Stock on hold'
and pr.name <> 'QC Hold'
and pr.name <> 'QC Stock'
and NOT (pr.name like '%QC%')
and pr.name <> 'Chill D Floor' 
and pr.Name <> 'Returns' -- added by KH 13/11/18 on Ryan Maybin Request
and pk.DNOB >= (@DeliveryDate - 1) and pk.UseBy >= (@DeliveryDate + 5)
 and isnumeric(HR.box_no)=1
and (HR.box_no is not null OR HR.product_name is not null OR HR.ordered_qty is not null)
and NOT EXISTS (select * FROM [FFG_DW].[dbo].[HR_Order_Allocation] oA3 where oA3.BoxNo  = pk.SSCC and [OrderNo] = @OrderNo and oA3.[SiteID] = pk.SiteID)
Group By mat1.ProductCode, mat1.Name, Mat1.Dimension4, ISNULL(col.PalletNumber, ' ') ,  pk.SiteID,Col.PalletId ,pk.DNOB ,pk.UseBy 
--order by datediff("d", @Today, pk.UseBy), mat1.ProductCode

END
GO
