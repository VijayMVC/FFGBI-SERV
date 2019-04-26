SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [integration].[MigrateStagedEmployeeData]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE 
		@EndOfTime datetime2(7) =  '99991231 23:59:59.9999999',
		@TABLE_NAME VARCHAR(100) =  N'Employee',
		@MAX_EMployeeKey int;

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
	--Get the max clock out times for termination date until finalised
	--SELECT 
	--	Employee_Id,
	--	max([clock out])max_clock_out
	--INTO
	--	#TMP_MAX_CLOCK_OUT
	--FROM 
	--	staging.EmployeeHoursWorked
	--GROUP BY 
	--	Employee_Id
	--create clustered index z_ci_tmp_max_clock on #TMP_MAX_CLOCK_OUT (employee_id)
	--get the max current employeekey for new inserts 
	SELECT 
		@MAX_EMployeeKey = MAX(employeeKey) 
	FROM
		DimEmployee
	--Insert into DimEmployee
	MERGE
		dbo.DimEmployee AS TARGET
	USING
		(
			SELECT 
				ROW_NUMBER() OVER( partition by DIM_EMP.employeeid ORDER BY T_EMP.employee_id) + CASE WHEN DIM_EMP.employeeid IS NULL THEN ISNULL(@MAX_EMployeeKey,0) ELSE 0  END employeekey,
				T_EMP.[employee_id],
				LTRIM(T_EMP.[first_name]) [first_name],
				LTRIM(T_EMP.[last_name]) [last_name],
				T_EMP.[paylink],
				ISNULL(T_EMP.[Sex],'Unknown') sex,
				T_EMP.[Site_id],
				ISNULL(T_EMP.[Department_id],-1) department_id,
				ISNULL(T_EMP.[Employee_Status],'Unknown')[employee status],
				T_EMP.[date_started_with_company] [start date],
				--CASE WHEN T_EMP.[Employee_Status] in ('Leaver Current Period', 'Leaver') THEN MAX_CO.max_clock_out END [Termination Date],
				CASE WHEN DIM_EMP.[Termination Date] IS NULL THEN NULL ELSE DIM_EMP.[Termination Date] END  [Termination Date],
				ISNULL(T_EMP.[job_title],'N/A')[job title],
				ISNULL(T_EMP.[Employed_by],'Unknown') employed_by,
				ISNULL(T_EMP.[sub_team],'N/A')sub_team,
				ISNULL(T_EMP.[contract_type],'Unknown') contract_type,
				ISNULL(T_EMP.[payment_frequency],'Unknown')payment_frequency,
				ISNULL(T_EMP.[Manager],'Unknown') Manager,
				CASE WHEN T_EMP.[ni_code] IS NOT NULL THEN 1 ELSE 0 END ni_code_flag,
				T_EMP.[date_of_birth],
				CASE WHEN T_EMP.[passport_number] IS NOT NULL THEN 1 ELSE 0 END  passport_flag,
				ISNULL(T_EMP.[Nationality],'Unknown')Nationality,
				ISNULL(T_EMP.work_schedule,'Unknown')work_schedule,
				0 Staff_present
			FROM 
				staging.tEmployee T_EMP
				--LEFT JOIN #TMP_MAX_CLOCK_OUT MAX_CO on T_EMP.employee_id = MAX_CO.employee_id
				LEFT JOIN dbo.DimEmployee DIM_EMP on T_EMP.employee_id = DIM_EMP.employeeid
			
		) AS SOURCE
		
		ON(
			TARGET.[EmployeeId] = SOURCE.[Employee_Id])
			
	--		--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.[first name] = SOURCE.first_name,
				TARGET.[last name] = SOURCE.last_name,
				TARGET.Paylink= SOURCE.paylink,
				TARGET.Sex = SOURCE.Sex,
				TARGET.[start date]= SOURCE.[start date],
				TARGET.[Termination Date] = SOURCE.[Termination Date],
				TARGET.[Job title] = SOURCE.[Job Title],
				TARGET.[Employee Status] = SOURCE.[Employee Status],
				TARGET.[Nationality] = SOURCE.[Nationality],
				TARGET."Employed By" =  SOURCE."Employed_By",
				TARGET."Sub Team"  =  SOURCE."Sub_Team" ,
				TARGET."Contract Type" =  SOURCE."Contract_Type",
				TARGET."Payment Frequency" =  SOURCE."Payment_Frequency",
				TARGET."Manager" =  SOURCE."Manager",
				TARGET."National Insurance" =  SOURCE."NI_Code_flag",
				TARGET."Date of Birth" =  SOURCE."Date_of_Birth",
				TARGET."Passport"  =  SOURCE."Passport_flag",
				TARGET."work schedule"  =  SOURCE."work_schedule",
				TARGET."Staff Present"  =  SOURCE."staff_present"

		
	--		--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				"EmployeeKey",
				"EmployeeID",
				"First Name",
				"Last Name",
				"Paylink",
				"Sex",
				"Start Date" ,
				"Termination Date",
				"Job Title",
				"Employee Status",
				"Nationality",
				"Employed By",
				"Sub Team",
				"Contract Type",
				"Payment Frequency",
				"Manager",
				"National Insurance",
				"Date of Birth",
				"Passport",
				"Work Schedule",
				"Staff Present"
			)
			VALUES
			(	
				"EmployeeKey",
				"Employee_ID",
				"First_Name",
				"Last_Name",
				"Paylink",
				"Sex",
				"Start Date" ,
				"Termination Date",
				"Job Title",
				"Employee Status",
				"Nationality",
				"Employed_By",
				"Sub_Team",
				"Contract_Type",
				"Payment_Frequency",
				"Manager",
				"NI_Code_flag",
				"Date_of_Birth",
				"Passport_flag",
				"Work_Schedule",
				"Staff_Present"
			)
		
	--		--remove any rows in the Target that ddoesn't exist in the Source
	--		WHEN NOT MATCHED BY SOURCE THEN 
	--		DELETE;
			
			OUTPUT $action, 
			INSERTED.[EmployeeKey] [EmployeeKey];
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

		--DROP TABLE #TMP_MAX_CLOCK_OUT

    COMMIT;

    RETURN 0;
END;

		
GO
