SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		David Bogues / Kevin Hargan
-- Create date: 2017-01-25
-- Description:	SP to Delete Hilton Retail Suboarder
--				This is usually called when an order is uplaoded twice by mistake
-- =============================================
CREATE PROCEDURE [dbo].[APP_HR_DeleteHiltonOrder]
	@OrderNo bigint,
	@SubOrderNo int,
	@CustomerSite nvarchar(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	-- exec APP_HR_DeleteHiltonOrder 777777, 1, 'IRE'
	-- exec APP_HR_DeleteHiltonOrder 888888, 1, 'UK'

SELECT 
	*
FROM 
	[FFG_DW].[dbo].[HR_Order_Summary_Import]
WHERE
	[Sub_Order_No] = @SubOrderNo
	and
	[Group_Order_No] = @OrderNo 
	and
	[SiteId] = @CustomerSite
	
DELETE
FROM 
	[FFG_DW].[dbo].[HR_Order_Summary_Import]
WHERE
	[Sub_Order_No] = @SubOrderNo
	and
	[Group_Order_No] = @OrderNo 
	and
	[SiteId] = @CustomerSite
	


SELECT *
FROM 
	[FFG_DW].[dbo].[HR_Order_Allocation]
WHERE 
	SuborderNo = @SubOrderNo
	and
	OrderNo = @OrderNo
	
DELETE
FROM 
	[FFG_DW].[dbo].[HR_Order_Allocation]
WHERE 
	SuborderNo = @SubOrderNo
	and
	OrderNo = @OrderNo

END
GO
