SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jason McDevitt | David Bogues (updated)
-- Create date: 30.01.15 | 2017-10-26 (updated)
-- Description:	Get Productplan production Selection - Lots Origin
-- =============================================
CREATE PROCEDURE [dbo].[APP_PP_GetLotsOrigin]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select 
		Code,
		Name,
		Shname 
	from 
		LotsOrigin with (NoLock)
END
GO
