SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason McDevitt	
-- Create date: 27.03.15
-- Description:	Get Allocated Stock for adjustment Screen
-- =============================================
-- exec dbo.HR_AllocatedStockByProduct 102343,2,'905',5
CREATE PROCEDURE [dbo].[HR_AllocatedStockByProduct] 
	-- Add the parameters for the stored procedure here
	@OrderNo Bigint,
	@SubOrder int,
	@BoxNo nvarchar(15),
	@SiteID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select OrderNo,[SubOrderNo]
      ,HR.[ProductCode]
      ,P.Dimension4 as BoxNo
      ,HR.[SiteID]
      ,case when HR.Palletid is null then null
      else isnull([PalletNo],'') end as PalletNo
      ,isnull(HR.PalletId,'') PalletId
      ,DNOB
      ,UseBy
      ,Count(*) as Qty,
      Pr.Name,
	  cast(HR.VIP as bit) as VIP
      into #TMP
	from HR_Order_Allocation HR with (nolock)
	inner Join Products P with (nolock)on P.ProductCode = HR.ProductCode
	left join pallets PP with (nolock) on isnull(HR.palletid,'') = isnull(PP.Palletid,'') and HR.siteid =PP.siteid
	left join Inventories PR with (nolock)on PP.Inventoryid = PR.Inventoryid and PR.site = PP.Siteid
	where OrderNo =  @OrderNo and SuborderNo = @SubOrder and HR.HR_BoxNo = @BoxNo and HR.SiteID = @SiteID
	group By OrderNo,[SubOrderNo],HR.[ProductCode],P.Dimension4,HR.[PalletId],[PalletNo],HR.[SiteID],DNOB,UseBy,Pr.Name,HR.VIP
	Order by UseBy,DNOB
	
	select OrderNo,[SubOrderNo],[ProductCode],BoxNo,[SiteID],PalletNo,PalletId,DNOB,UseBy,sum(qty) as Qty,Name,VIP
	
	from #TMP
	group By OrderNo,[SubOrderNo],[ProductCode],BoxNo,[SiteID],PalletNo,PalletId,DNOB,UseBy,Name,VIP
	
END
GO
