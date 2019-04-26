SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 10/04/2015
-- Description:	add Manual Stock
-- =============================================
CREATE PROCEDURE [dbo].[HR_Add_Manual_Stock] 
	-- Add the parameters for the stored procedure here
@OrderNo Bigint,
@SubOrderNo as int, 
@SiteId as Int,
@BoxNo as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	create Table #OrderAllocationSummary
	(
		OrderNo  bigint,
		SubOrderNo  int,
		ProductCode bigint, 
		BoxNo int, 
		productname nvarchar (max),
		DeliveryDate datetime, TotalQty int,FCSite int, FCQty int,FCTotal int,
		FOSite int, FOQty int,FOTotal int,
		FHSite int, FHQty int,FHTotal int,
		FDSite int, FDQty int,FDTotal int,
		FGSite int, FGQty int,FGTotal int,
		FMMSite int, FMMQty int,FMMTotal int,
		RequiredQty int
	)
	
insert into #OrderAllocationSummary
EXEC [dbo].[HR_Allocation_Summary] @OrderNo	

select OAS.BoxNo, Null as DNOB,Null as Useby,OAS.RequiredQty,0 as QtyToAdd
from #OrderAllocationSummary OAS



--select OS.box_no, Null as DNOB,Null as Useby,
--(cast(OS.Ordered_Qty as int) - Sum(case when OA.siteid in(1,2,3,4,5,6) then 1 else 0 end)) as RequiredQty,
--0 as QtyToAdd
--from dbo.HR_Order_Allocation OA (nolock)
--left join HR_Order_Summary_Import OS (nolock) on right(OA.ProductCode,3) = OS.Box_No and OS.Group_Order_No = OA.OrderNo
--where Os.Ordered_qty >0 
--group by Os.Box_No,OS.Ordered_Qty



END
GO
