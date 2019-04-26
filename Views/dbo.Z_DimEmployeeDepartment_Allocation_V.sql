SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[Z_DimEmployeeDepartment_Allocation_V]
AS


SELECT 
	DepartmentKey,
	DepartmentName,
	DepartmentCode
FROM 
	DimEmployeeDepartment
	
GO
