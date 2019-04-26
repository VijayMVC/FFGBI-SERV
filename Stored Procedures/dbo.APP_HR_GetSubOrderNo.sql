SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thompson / David Bogues (updated)
-- Create date: 2017-02-09 (updated)
-- Description:	Gets the SubOrder No for Hilton order (updated to sp)
-- =============================================
CREATE PROCEDURE [dbo].[APP_HR_GetSubOrderNo] 
	-- Add the parameters for the stored procedure here
	@GroupOrderNo bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select  
	IsNull((Max(Sub_Order_no)+1),1) as 'SubOrder'  
		--(count(distinct Group_Order_No)+1) as 'SubOrder'  
	from 
		[FFG_DW].[dbo].[HR_Order_Summary_Import] with (nolock)
	where 
		Group_Order_No = @GroupOrderNo

END
GO
