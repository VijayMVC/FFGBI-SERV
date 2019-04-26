SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy
-- Create date: 24/11/2015
-- Description:	Show sites selected
-- =============================================
--exec HR_Show_Site_comments '106427','1','913'
CREATE PROCEDURE [dbo].[HR_Show_Site_comments] 
@Orderno nvarchar(20),
@SubOrderNo  nvarchar(5),
@BoxNo nvarchar(5)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	select isnull(Site_comments,0) as site_Comments from [dbo].[HR_Order_Summary_Import]
	where ISNUMERIC([Group_Order_No]) = 1 and ISNUMERIC([Sub_Order_no]) = 1 and ISNUMERIC([Box_No]) = 1 and 
	[Group_Order_No]  = cast(@Orderno as bigint) and [Sub_Order_no]  = cast(@suborderno as int) and [Box_No]  = @boxno

END
GO
