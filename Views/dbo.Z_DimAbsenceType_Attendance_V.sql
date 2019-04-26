SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dbo].[Z_DimAbsenceType_Attendance_V]
AS


SELECT 
	AbsenceTypeKey,
	[Absence Type]
FROM
	DimAbsenceType
	


GO
