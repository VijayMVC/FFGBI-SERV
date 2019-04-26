CREATE TABLE [staging].[EmployeeExpectedHours]
(
[employee_id] [int] NOT NULL,
[Work_Date] [date] NOT NULL,
[Expected_Hours] [decimal] (8, 2) NOT NULL,
[WorkDay] [bit] NOT NULL
) ON [PRIMARY]
GO
