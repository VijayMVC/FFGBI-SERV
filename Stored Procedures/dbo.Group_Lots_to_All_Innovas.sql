SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 16/01/2015
-- Description:	processing lots out all site's Innova
-- =============================================
--exec  [dbo].[Group_Lots_to_All_Innovas] 
CREATE PROCEDURE [dbo].[Group_Lots_to_All_Innovas] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
Declare @NextLot as int
set @NextLot = (select Top 1 Id from Lots_New where Processed is null)

while @NextLot is not null 
begin

--Omagh
exec [OMASQL01].[INNOVA].DBO.[Group_Insert_lots_New_FO] @NextLot
--Campsie
--exec [FM-SQL01].[INNOVA].DBO.[[Group_Insert_lots_New_FM] @NextLot
--Hilton
--exec [CKTSQL01].[INNOVA].DBO.[[Group_Insert_lots_New_FH] @NextLot
--Donegal
--exec [DONSQL01].[INNOVA].DBO.[[Group_Insert_lots_New_FD] @NextLot
--Gloucester
--exec [GLOSQL01].[INNOVA].DBO.[[Group_Insert_lots_New_FG] @NextLot
--Melton
--exec [FMM-SQL01].[INNOVA].DBO.[[Group_Insert_lots_New_FMM] @NextLot

--Update Lots_New set Processed = 'Transffered' where ID = @NextLot

set @NextLot = (select Top 1 Id from Lots_New where Processed is null)

end


 
END
GO
