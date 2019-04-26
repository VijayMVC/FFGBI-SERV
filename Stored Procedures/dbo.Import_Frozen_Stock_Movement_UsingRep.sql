SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [Import_Frozen_Stock_Movement]
CREATE PROCEDURE [dbo].[Import_Frozen_Stock_Movement_UsingRep]
	as
	declare @currentDate as datetime
	set @currentDate = (cast(getdate() as date))


	delete from [dbo].[FrozenStockInOut] where ImportDate < @currentDate -7 

	--Omagh
	exec [FFGSQL03].[FO_INNOVA].[DBO].[packMovemment]
	--Campsie
	exec [FFGSQL03].[FM_INNOVA].[DBO].[packMovemment]
	--Donegal
	exec [FFGSQL03].[FD_INNOVA].[DBO].[packMovemment]
	--Hilton
	exec [FFGSQL03].[FH_INNOVA].[DBO].[packMovemment]
	--Gloucester
	exec [FFGSQL03].[FG_INNOVA].[DBO].[packMovemment]
	--Melton
	exec [FFGSQL03].[FMM_INNOVA].[DBO].[packMovemment]
	--Ingredients
	exec [FFGSQL03].[FI_INNOVA].[DBO].[packMovemment]
	
GO
