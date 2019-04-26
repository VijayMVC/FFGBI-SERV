SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 03/04/2015
-- Description:	get suborder no
-- =============================================
CREATE PROCEDURE [dbo].[GetHRSubOrder] 
	-- Add the parameters for the stored procedure here
@OrderNo Bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
select  distinct Sub_Order_No as [SubOrderNo] from dbo.HR_Order_Summary_import where Group_Order_no = @OrderNo

END
GO
