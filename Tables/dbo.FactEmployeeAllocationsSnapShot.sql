CREATE TABLE [dbo].[FactEmployeeAllocationsSnapShot]
(
[EmployeeAllocationKey] [bigint] NOT NULL,
[EmployeeKey] [int] NOT NULL,
[EntitlementYearKey] [int] NOT NULL,
[EntitlementTypeKey] [int] NOT NULL,
[DepartmentKey] [int] NOT NULL,
[SiteKey] [int] NOT NULL,
[EntitlementFromKey] [int] NOT NULL,
[PeriodFromDateKey] [int] NOT NULL,
[PeriodToDateKey] [int] NOT NULL,
[Year Service] [int] NULL,
[Holiday Allowance Days] [money] NOT NULL,
[Stat Allowance Days] [money] NOT NULL,
[Carry Over Days] [money] NOT NULL,
[Credit days] [money] NOT NULL,
[Worked Days] [money] NOT NULL,
[Taken Days] [money] NOT NULL,
[Planned Days] [money] NOT NULL,
[Average Rate] [money] NULL,
[Lineage Key] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactEmployeeAllocationsSnapShot] ADD CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED  ([EmployeeAllocationKey]) ON [PRIMARY]
GO
