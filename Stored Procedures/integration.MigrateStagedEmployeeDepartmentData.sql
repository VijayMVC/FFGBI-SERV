SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateStagedEmployeeDepartmentData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE 
		@EndOfTime datetime2(7) =  '99991231 23:59:59.9999999',
		@TABLE_NAME VARCHAR(100) =  N'DimEmployeeDepartment',
		@MAX_DepartmentKey int;

    BEGIN TRAN;
		DECLARE @LineageKey int = (	SELECT 
										TOP(1) [Lineage Key]
									FROM 
										Integration.Lineage
									WHERE 
										[Table Name] = @TABLE_NAME
										AND [Data Load Completed] IS NULL
									ORDER BY 
										[Lineage Key] DESC);
	
	
	SELECT @MAX_DepartmentKey = MAX(DepartmentKey) from DimEmployeeDepartment
	--Insert into DimSite
	MERGE
		dbo.DimEmployeeDepartment AS TARGET
	USING
		(
			SELECT 
				ROW_NUMBER() OVER(PARTITION BY DIM_DEPT.DepartmentID ORDER BY DEPT.Department_Id) +CASE WHEN DIM_DEPT.DepartmentID IS NULL THEN ISNULL(@MAX_DepartmentKey,0) ELSE 0 END  Departmentkey,
				DEPT.Department_Id,
				DEPT.Department_Code,
				DEPT.department_name
			FROM 
				staging.EmployeeDepartment DEPT
				LEFT JOIN DimEmployeeDepartment DIM_DEPT on DEPT.department_id = DIM_DEPT.DepartmentID
			WHERE 
				1=1
			UNION 
			SELECT 
				-1 DepartmentKey,
				-1 DepartmentId, 
				'UN' Departmentcode,
				'Unknown' DepartmetName
		) AS SOURCE
		
		ON(
			TARGET.[DepartmentID] = SOURCE.[Department_ID])
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[DepartmentCode] = SOURCE.department_code,
				TARGET.[Departmentname] = SOURCE.department_name

	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				"DepartmentKey",
				"DepartmentID",
				"DepartmentName",
				"DepartmentCode"
			)
			VALUES
			(	
				DepartmentKey,
				Department_Id,
				Department_name,
				Department_Code
				
			)
		
	--		--remove any rows in the Target that ddoesn't exist in the Source
	--		WHEN NOT MATCHED BY SOURCE THEN 
	--		DELETE;
			
			OUTPUT $action, 
			INSERTED.[DepartmentKey] [DepartmentKey];
			SELECT @@ROWCOUNT;;
	
	
	
	
	--Update the lineage table 
		UPDATE 
			Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
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
			[Table Name] =@TABLE_NAME


    COMMIT;

    RETURN 0;
END;

		
GO
