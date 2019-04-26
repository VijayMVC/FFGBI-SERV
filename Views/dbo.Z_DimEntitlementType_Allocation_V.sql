SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[Z_DimEntitlementType_Allocation_V]
AS


SELECT 
	[EntitlementTypeKey],
	[EntitlementId],
	[Entitlement Type],
	[Entitlement Group]
FROM
	DimEntitlementType
	



GO
