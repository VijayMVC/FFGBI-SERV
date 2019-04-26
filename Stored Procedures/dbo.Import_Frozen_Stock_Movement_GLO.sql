SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <19/06/17>
-- Description:	<GLoucester Frozen stock Movement>
-- =============================================
--exec [Import_Frozen_Stock_Movement_GLO]
CREATE PROCEDURE [dbo].[Import_Frozen_Stock_Movement_GLO]
	as
	declare @currentDate as datetime
	set @currentDate = (cast(getdate() as date))


	delete from [dbo].[FrozenStockInOut] where ImportDate < @currentDate -7 and [Site] = 5
	
	--Gloucester
	exec [FFGSQL03].[FG_INNOVA].[DBO].[packMovemment]
	
GO
