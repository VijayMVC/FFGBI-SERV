SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thompson / David Bogues (updated)
-- Create date: 2017-01-27 (updated)
-- Description:	
--	Logic to Save a Manal Order Allocation. This was hardcoded in Tommy's logic but I have made SP
-- =============================================
CREATE PROCEDURE [dbo].[HR_SaveManualAllocation]
	

	-- exec HR_SaveManualAllocation 116387,	1,	501910662, 2, '2017-01-26 00:00:00.000', '2017-01-27 00:00:00.000', 1, 901, '2017-01-27', 0

	-- Add the parameters for the stored procedure here
	@OrderNo bigint, 
	@SubOrderNo int,
	@ProductCode bigint,
	--@PalletNo bigint,
	--@BoxNo int,
	@SiteID int,
	@DNOB DateTime,
	@UseBy DateTime,
	@InProductionStock bit,
	@HR_BoxNo int,
	@OrderDate DateTime,
	--@Modified int,
	@VIP bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	select Modified from dbo.HR_Order_Summary_import  with (nolock) where Group_Order_No =@OrderNo and Box_No = @HR_BoxNo

	-- This Was Logic In Tommy's Code - Not sure what point is. Thing may be redundant in Phase 2
	DECLARE @PalletNo bigint
	SET @PalletNo = (select isnull(max(palletNo),0) + 1 as MaxPalletNo from [HR_Order_Allocation] with (nolock) where inproductionstock = 1)

	-- This Was Logic In Tommy's Code - Not sure what point is. Thing may be redundant in Phase 2
	-- Tommy's Logic Didnnt actually use this at all
	--DECLARE @BoxNo int
	--SET @BoxNo = (select isnull(max(BoxNo),0) + 1 as MaxBoxNo from [HR_Order_Allocation]  with (nolock) where inproductionstock = 1)

	-- This Was Logic In Tommy's Code - Not sure what point is. Thing may be redundant in Phase 2
	DECLARE @Modified int
	SET @Modified = (select top 1 Modified from dbo.HR_Order_Summary_import  with (nolock) where Group_Order_No =@OrderNo and Box_No = @HR_BoxNo)

    -- Insert statements for procedure here
	insert into 
		HR_Order_Allocation(
			OrderNo, 
			SubOrderNo,
			ProductCode,
			PalletNo,
			BoxNo,
			SiteID,
			PalletId,
			DNOB,
			UseBy,
			InProductionStock,
			HR_BoxNo,
			Orderdate,
			[Modified],
			VIP) 
		values(
			@OrderNo, 
			@SubOrderNo,
			@ProductCode,
			@PalletNo,
			@PalletNo,
			@SiteID,
			Null,
			@DNOB,
			@UseBy,
			@InProductionStock,
			@HR_BoxNo,
			@OrderDate,
			@Modified,
			@VIP
		)
END
GO
