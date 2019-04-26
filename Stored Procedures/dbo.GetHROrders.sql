SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 24/03/2015
-- Description:	Get Current orders that need processed
-- =============================================
CREATE PROCEDURE [dbo].[GetHROrders]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select  distinct Group_Order_No as [OrderNo], Sub_Order_No as [SubOrderNo] from dbo.HR_Order_Summary_import
END
GO
