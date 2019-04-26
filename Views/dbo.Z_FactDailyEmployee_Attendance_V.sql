SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Z_FactDailyEmployee_Attendance_V]
AS


SELECT [EmployeeFactKey]
      ,[EmployeeKey]
      ,[DepartmentKey]
      ,[SiteKey]
      ,[DateKey]
      ,[AbsenceReasonKey]
      ,[AbsenceTypeKey]
      ,[Worked minutes]
      ,[Absent minutes]
	  ,[Overtime minutes]
      ,[Clock In Time]
      ,[Clock Out Time]
      ,[Daily Rate]
      ,[Work Day]
      ,[Expected Hours]
      ,[Staff Employed]
	  ,case WHEN CAST([Clock In Time] as date) = cast(getdate() as date) and [Clock Out Time] is null THEN 1 ELSE 0 END [Currently Logged In]
	  ,[Worked minutes] / 60 [Worked Hours]
      ,[Absent minutes] / 60 [Absent Hours]
	  ,[Overtime minutes] / 60 [Overtime Hours]
  FROM [dbo].[FactDailyEmployee]
	


GO
