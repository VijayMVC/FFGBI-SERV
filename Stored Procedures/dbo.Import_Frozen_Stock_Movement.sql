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
CREATE PROCEDURE [dbo].[Import_Frozen_Stock_Movement]
	as
	declare @currentDate as datetime
	set @currentDate = (cast(getdate() as date))


	delete from [dbo].[FrozenStockInOut] where ImportDate < @currentDate -7 

	--Omagh
	exec [OMASQL01].[INNOVA].[DBO].[packMovemment]
	--Campsie
	exec [CAMSQL01].[INNOVA].[DBO].[packMovemment]
	--Donegal
	exec [DONSQL01].[INNOVA].[DBO].[packMovemment]
	--Hilton
	exec [CKTSQL01].[INNOVA].[DBO].[packMovemment]
	--Gloucester
	exec [GLOSQL01].[INNOVA].[DBO].[packMovemment]
	--Melton
	exec [MELSQL01].[INNOVA].[DBO].[packMovemment]
	--Ingredients
	exec [INGSQL01].[FI_INNOVA].[DBO].[packMovemment]
	
GO
