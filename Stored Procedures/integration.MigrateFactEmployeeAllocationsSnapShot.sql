SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [integration].[MigrateFactEmployeeAllocationsSnapShot] 
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;


    DECLARE @TABLE_NAME VARCHAR(100) =  N'FactEmployeeAllocationsSnapShot'
	DECLARE	@LineageKey int = (	SELECT 
										TOP(1) [Lineage Key]
									FROM 
										Integration.Lineage
									WHERE 
										[Table Name] = @TABLE_NAME
										AND [Data Load Completed] IS NULL
									ORDER BY 
										[Lineage Key] DESC
								);


	--DELETE FactDailyEmployee
	TRUNCATE TABLE FactEmployeeAllocationsSnapShot
	
	INSERT INTO		
		[dbo].[FactEmployeeAllocationsSnapShot]
	SELECT 
		ROW_NUMBER () OVER( ORDER BY EmployeeKey,EntitlementYearKey)EmployeeAllocationKey,
		EMP.EmployeeKey,
		ENT_YEAR.EntitlementYearKey,
		ENT_TYPE.EntitlementTypeKey,
		ISNULL(DEPT.DepartmentKey,-1) DepartmentKey,
		ISNULL(SITES.SiteKey,-1)SiteKey,
		cast(convert(varchar(8),EMP_ALLOC.entitlementFrom,112) as int)entitlementFromDateKey,
		cast(convert(varchar(8),EMP_ALLOC.PeriodFromDate,112) as int)PeriodFromDateKey,
		cast(convert(varchar(8),EMP_ALLOC.PeriodToDate,112) as int)PeriodToDateKey,
		EMP_ALLOC.[Year Service],
		EMP_ALLOC.[Holiday Allowance Days] ,
		EMP_ALLOC.[Stat Allowance Days],
		EMP_ALLOC.[Carry Over Days],
		EMP_ALLOC.[Credit days] ,
		EMP_ALLOC.[Worked Days],
		EMP_ALLOC.[Taken Days],
		EMP_ALLOC.[Planned Days],
		null [Average rate],
		@LineageKey
	FROM
		staging.EmployeeAllocations EMP_ALLOC 
		INNER JOIN DimEmployee EMP on EMP_ALLOC.employeeid = EMP.EmployeeId
		INNER JOIN staging.temployee SEMP on EMP.EmployeeId = SEMP.employee_id 
		INNER JOIN DimEntitlementYear ENT_YEAR on EMP_ALLOC.entitlement_year = ENT_YEAR.[Entitlement Year]
		INNER JOIN DimEntitlementType ENT_TYPE on EMP_ALLOC.absence_entitlement_id = ENT_TYPE.EntitlementId
		LEFT JOIN DimEmployeeDepartment DEPT on SEMP.Department_id = DEPT.DepartmentID
		LEFT JOIN DimSIte SITES on SEMP.Site_id = SITES.[site id]
	WHERE
		1=1
			
	
	
	UPDATE 
		Integration.Lineage
	SET 
		[Data Load Completed] = SYSDATETIME(),
		[Was Successful] = 1
	WHERE 
		[Lineage Key] = @LineageKey;

	UPDATE 
		Integration.[ETL Cutoff]
	SET 
		[Cutoff Time] = (SELECT [Source System Cutoff Time]
								FROM Integration.Lineage
								WHERE [Lineage Key] = @LineageKey)
	FROM 
		Integration.[ETL Cutoff]
	WHERE 
		[Table Name] = @TABLE_NAME;

    COMMIT;

    RETURN 0;
END;
GO
