SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [Import_Frozen_Stock_Movement_MEL]
CREATE PROCEDURE [dbo].[Import_Frozen_Stock_Movement_MEL]
	as
	declare @currentDate as datetime
	set @currentDate = (cast(getdate() as date))


	delete from [dbo].[FrozenStockInOut] where ImportDate < @currentDate -7 and [Site] = 6

	--Melton
	exec [FFGSQL03].[FMM_INNOVA].[DBO].[packMovemment]
GO
