SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dbo].[Z_DimAbsenceReason_Attendance_V]
AS


SELECT 
	AbsenceReasonKey,
	[Absence Reason]
FROM
	DimAbsenceReason
	


GO
