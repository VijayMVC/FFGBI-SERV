CREATE TABLE [staging].[EmployeeAllocations]
(
[EmployeeID] [int] NOT NULL,
[absence_entitlement_id] [int] NOT NULL,
[EntitlementFrom] [date] NOT NULL,
[PeriodFromDate] [date] NOT NULL,
[PeriodToDate] [date] NOT NULL,
[entitlement_year] [int] NOT NULL,
[Year Service] [int] NULL,
[Holiday Allowance Days] [money] NOT NULL,
[Stat Allowance Days] [money] NOT NULL,
[Carry Over Days] [money] NOT NULL,
[Credit days] [money] NOT NULL,
[Worked Days] [money] NOT NULL,
[Taken Days] [money] NOT NULL,
[Planned Days] [money] NOT NULL,
[Entitlement Group] [varchar] (15) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
