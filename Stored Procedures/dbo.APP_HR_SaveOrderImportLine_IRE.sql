SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		David Bogues
-- Create date: 2017-02-08
-- Description:	Records a HR Import Line - Based on Tommy ETL
-- =============================================
CREATE PROCEDURE [dbo].[APP_HR_SaveOrderImportLine_IRE] 
	@RowNo int,
	@OrderDate datetime,
	@Group_Order_No bigint,
	@Delivery_Date datetime,
	@Sub_Order_no int,
	@Box_No nvarchar(10) = null,
	@Product_Name nvarchar(max) = null,
	@Ordered_Qty nvarchar(max) = null,
	@Confirmed_Qty nvarchar(max) = null,
	@Siteid nvarchar(10),
	@Processed nvarchar(2),
	@VIP int,
	@Comments nvarchar(max) = null,
	@Modified int,
	@Org_Ordered_Qty int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- Insert Values
    INSERT 
		INTO HR_Order_Summary_Import_IRE(
			[RowNo],
			[OrderDate], [Group_Order_No], [Delivery_Date],	[Sub_Order_no],
			[Box_No], [Product_Name], [Ordered_Qty], [Confirmed_Qty],
			[Siteid], [Processed], [VIP], [Comments], [Modified], [Org_Ordered_Qty] 
		)
	VALUES(
		@RowNo,
		@OrderDate,
		@Group_Order_No,
		@Delivery_Date,
		@Sub_Order_no,
		@Box_No,
		@Product_Name,
		@Ordered_Qty,
		@Confirmed_Qty,
		@Siteid,
		@Processed,
		@VIP,
		@Comments,
		@Modified,
		@Org_Ordered_Qty
	)

	-- Update the Values - this could probably be ran once at end of import, but looking at working all night so this is simplier
	update
		[FFG_DW].[dbo].[HR_Order_Summary_import_IRE] 
    set 
		ordered_qty = round(ordered_qty, 0) 
    where 
		ordered_qty <> round(ordered_qty, 0)        
		

	-- Update the Values - same as above : this could probably be ran once at end of import, but looking at working all night so this is simplier
    update  
		OS
	set 
		OS.box_no = BL.boxNo
    from
		[FFG_DW].[dbo].[HR_Order_Summary_import_IRE] OS 
		Left join[FFG_DW].[dbo].[HR_BoxNo_Lookup] BL(nolock) on OS.Product_name = BL.ProductName
    where 
		box_no is null 
		and 
		product_name is not null 
		and 
		cast(ordered_qty as int) is not null


----THIS IS THE BIG CHANGE FOR AVG WGTS
--	Select * Into #b From [HR_BoxNo_Wgts] Where FFGSite='FD'

----Need to Store the Original Weight
--	Update [FFG_DW].[dbo].[HR_Order_Summary_import_IRE] Set [Org_Ordered_Qty] = ordered_qty Where  RowNo=@RowNo And [Org_Ordered_Qty]=0

--	Update h
--	Set h.AvgCaseWgt=b.AvgCaseWgt, h.EstCases=Cast(Round(h.Ordered_Qty/b.AvgCaseWgt,0) As Int)
--	From [FFG_DW].[dbo].[HR_Order_Summary_import_IRE] h
--	Left Join #b b On h.Box_No=b.BoxNo And b.FFGSite='FD'
--	Where h.Ordered_Qty >0 And h.RowNo=@RowNo

--	Update [FFG_DW].[dbo].[HR_Order_Summary_import_IRE] Set Ordered_Qty=IsNull(EstCases,0) Where RowNo=@RowNo

--	Drop Table #b

END
GO
