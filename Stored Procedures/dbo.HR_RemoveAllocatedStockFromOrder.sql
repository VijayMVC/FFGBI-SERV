SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason McDevitt
-- Create date: 27.03.15
-- Description:	Remove Stock Allocated to an Order
-- =============================================
-- exec [dbo].[HR_RemoveAllocatedStockFromOrder] '106933','1','501910228',0,2,'11/03/15','11/04/15',903,10


-- exec [dbo].[HR_RemoveAllocatedStockFromOrder] 
-- 116443 , 1, 501910213, 431124, 2, '2017-01-16', '2016-01-30', 213, 2

CREATE PROCEDURE [dbo].[HR_RemoveAllocatedStockFromOrder] 
	-- Add the parameters for the stored procedure here
	@OrderNo Bigint,
	@SubOrderNo int,
	@ProductCode nvarchar(15),
	@PalletId bigint,
	@SiteID int,
	@DNOB datetime = null,
	@UseBy DateTime = null,
	@BoxNo nvarchar (10),
	@QtyToRemove int
	
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
	[PalletID] [bigint] NULL,
	[DNOB] [datetime] NULL,
	[UseBy] [datetime] NULL	,
	[Remove] [bit]
)


insert into @OrderAllocationTemp
SELECT  
	HR.[OrderNo] ,
	HR.[SubOrderNo],
	HR.[ProductCode],
	HR.[PalletNo],
	HR.[BoxNo],
	HR.[SiteID],
	HR.[PalletID],
	HR.[DNOB],
	HR.[UseBy],
case when  
	(@QtyToRemove) >= ROW_NUMBER() OVER 
	(PARTITION BY PalletId,DNOB,UseBy ORDER By PalletId,DNOB,UseBy)  
	then 1 
	else    0 end as Remove

FROM         
	HR_Order_Allocation  HR
					
WHERE  
	HR.OrderNO = @OrderNo 
	and  
	HR.[SubOrderNo] = @SubOrderNo 
	and 
	[ProductCode] = @ProductCode 
	and 
	isnull([PalletId],0) = @PalletId 
	and 
	[SiteID] = @SiteID
	and 
	DNOB = @DNOB 
	and 
	[UseBy] = @UseBy 
	and 
	HR.HR_BoxNo = @BoxNo
	and 
	datepart(year,HR.OrderDate) = DATEPART(year, getdate())


delete  
	HRA
from 
	HR_Order_Allocation HRA 
	Inner Join @OrderAllocationTemp OAT 
		on 
			HRA.BoxNo = OAT.BoxNo 
			and 
			HRA.SiteID = OAT.SiteID 
			and 
			isnull(HRA.PalletId,0) = isnull(OAT.PalletId,0) 
			and HRA.orderno =@OrderNo
where 
	OAT.[Remove] = 1


--([OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby )
--select [OrderNo],[SubOrderNo] ,[ProductCode] ,	[PalletNo] ,[BoxNo],[SiteID],PalletId, DNOB, Useby 
--from @OrderAllocationTemp
--where [Remove] = 1


end
GO
