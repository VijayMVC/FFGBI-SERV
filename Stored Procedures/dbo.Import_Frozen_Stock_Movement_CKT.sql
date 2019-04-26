SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <19/06/17>
-- Description:	<Description,,>
-- =============================================
--exec [Import_Frozen_Stock_Movement_CKT]
CREATE PROCEDURE [dbo].[Import_Frozen_Stock_Movement_CKT]
	as
	declare @currentDate as datetime
	set @currentDate = (cast(getdate() as date))


	delete from [dbo].[FrozenStockInOut] where ImportDate < @currentDate -7 and [Site] = 3

	--Hilton
	exec [FFGSQL03].[FH_INNOVA].[DBO].[packMovemment]

GO
