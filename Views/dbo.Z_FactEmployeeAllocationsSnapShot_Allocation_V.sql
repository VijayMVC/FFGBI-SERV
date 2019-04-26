SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Z_FactEmployeeAllocationsSnapShot_Allocation_V]
AS
SELECT 
	[EmployeeAllocationKey] ,
	[EmployeeKey],
	[EntitlementYearKey] ,
	[EntitlementTypeKey],
	[DepartmentKey],
	[SiteKey],
	[EntitlementFromKey],
	[PeriodFromDateKey],
	[PeriodToDateKey],
	[Year Service],
	[Holiday Allowance Days],
	[Stat Allowance Days],
	[Carry Over Days],
	[Credit days],
	[Worked Days],
	[Taken Days],
	[Planned Days],
	[Average Rate]
FROM 
	FactEmployeeAllocationsSnapShot


GO
