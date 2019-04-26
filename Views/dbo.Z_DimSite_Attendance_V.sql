SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dbo].[Z_DimSite_Attendance_V]
AS


SELECT 
	SiteKey,
	[Site Code],
	[Site Name]
FROM
	DimSite
	

GO
