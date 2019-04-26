SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <02/04/19>
-- Description:	<SP_StockvsSalesPersonMaster>
-- =============================================
CREATE PROCEDURE [dbo].[SP_StockvsSalesPersonMaster] 
	-- Add the parameters for the stored procedure here
	
	@FreshFrozen nvarchar(20),
	@Site int

AS
BEGIN
	
	IF @FreshFrozen = 'Frozen'
	begin
	EXEC					[SP_FrozenStockVsSalesPerson] @Site
	END

	IF @FreshFrozen = 'Fresh'
	begin
	EXEC					[SP_FreshStockVsSalesPerson] @Site
	END

END
GO
