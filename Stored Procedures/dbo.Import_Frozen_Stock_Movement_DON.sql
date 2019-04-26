SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <19/06/17>
-- Description:	<Description,,>
-- =============================================
--exec [Import_Frozen_Stock_Movement_DON]
CREATE PROCEDURE [dbo].[Import_Frozen_Stock_Movement_DON]
	as
	declare @currentDate as datetime
	set @currentDate = (cast(getdate() as date))


	delete from [dbo].[FrozenStockInOut] where ImportDate < @currentDate -7 and [Site] = 4
	--Donegal
	exec [FFGSQL03].[FD_INNOVA].[DBO].[packMovemment]
	
GO
