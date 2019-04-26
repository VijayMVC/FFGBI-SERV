SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[Z_DimEntitlementYear_Allocation_V]
AS


SELECT 
	EntitlementYearKey,
	[Entitlement Year]
FROM
	DimEntitlementYear
	



GO
