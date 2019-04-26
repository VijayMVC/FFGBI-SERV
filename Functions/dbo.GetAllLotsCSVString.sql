SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		David Bogues
-- Create date: 2016-11-11
-- Description:	Function that can be used by to get all lots as CSV String arg list
-- =============================================
/*
	Code to check function : 
	DECLARE @_Lots NVARCHAR(MAX)
	EXEC @_Lots = dbo.GetAllLotsCSVString 5;
	Select @_Lots
*/

CREATE FUNCTION [dbo].[GetAllLotsCSVString]
(	
	@SiteId int
)
-- Has to return 4000 - NVARCHAR(MAX) is not supported in distributed queries, and this is bigges data size I can find that works (more than big enough)
RETURNS NVARCHAR(4000) 
AS
BEGIN

	-- Has to return 4000 - NVARCHAR(MAX) is not supported in distributed queries, and this is bigges data size I can find that works (more than big enough)
	Declare @_Lots NVARCHAR(4000)
	SET @_Lots = ''

	SELECT 
		@_Lots = @_Lots + cast([Code] as NVARCHAR) + N','
	FROM 
		[FFGBI-SERV].[FFG_DW].[dbo].Lots with (nolock)
	WHERE
		Dimension1 = '1' 
		and 
		len(Code) = 12 
		and [SiteID] = @SiteId
	
	Return @_lots
END
GO
