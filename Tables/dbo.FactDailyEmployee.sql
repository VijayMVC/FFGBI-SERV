CREATE TABLE [dbo].[FactDailyEmployee]
(
[EmployeeFactKey] [bigint] NOT NULL,
[EmployeeKey] [int] NOT NULL,
[DepartmentKey] [int] NOT NULL,
[SiteKey] [int] NOT NULL,
[DateKey] [int] NOT NULL,
[AbsenceReasonKey] [int] NOT NULL,
[AbsenceTypeKey] [int] NOT NULL,
[Worked minutes] [int] NOT NULL,
[Absent minutes] [int] NOT NULL,
[Overtime minutes] [int] NOT NULL,
[Clock In Time] [datetime] NULL,
[Clock Out Time] [datetime] NULL,
[Daily Rate] [money] NULL,
[Work Day] [bit] NOT NULL,
[Expected Hours] [decimal] (8, 2) NOT NULL,
[Staff Employed] [bit] NOT NULL,
[Lineage Key] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactDailyEmployee] ADD CONSTRAINT [PK_FactDailyEmployee] PRIMARY KEY CLUSTERED  ([EmployeeFactKey]) ON [PRIMARY]
GO
