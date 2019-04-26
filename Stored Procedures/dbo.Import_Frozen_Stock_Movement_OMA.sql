SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <190/06/17>
-- Description:	<Omagh Frozen Stock Movement>
-- =============================================
--exec [Import_Frozen_Stock_Movement_OMA]
CREATE PROCEDURE [dbo].[Import_Frozen_Stock_Movement_OMA]
	as
	declare @currentDate as datetime
	set @currentDate = (cast(getdate() as date))


	delete from [dbo].[FrozenStockInOut] where ImportDate < @currentDate -7 and [Site] = 2
	--omagh
	exec [FFGSQL03].[FO_INNOVA].[DBO].[packMovemment]

GO
