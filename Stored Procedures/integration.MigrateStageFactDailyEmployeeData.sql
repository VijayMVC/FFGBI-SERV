SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [integration].[MigrateStageFactDailyEmployeeData] (@P_MIN_DATE DATE)
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;
	DECLARE 
		@MIN_DATE DATE = @P_MIN_DATE,
		@MIN_DATE_INT INT,
		@MAX_EMPLOYEE_FACT_KEY BIGINT,
		@ABSENCE_REASON_KEY INT
	
		SELECT 
			@MIN_DATE_INT = CAST(CONVERT(VARCHAR(8),@MIN_DATE,112) AS INT)
	
		SELECT 
			Employee_Id,
			MAX([clock out])max_clock_out,
			MAX(CASE WHEN assignment_date = cast(getdate() as date) THEN staff_present ELSE 0 END) staff_present
		INTO
			#TMP_MAX_CLOCK_OUT
		FROM 
			staging.[Employee_Absence_and_Clockin]
		GROUP BY 
			Employee_Id
		CREATE CLUSTERED INDEX 
			z_ci_tmp_max_clock on #TMP_MAX_CLOCK_OUT (employee_id)

	
	--set the termination date to the last clockout date and set if the employee is currently present
		UPDATE 
			D_EMP
		SET
			D_EMP.[Termination Date] = CASE WHEN D_EMP.[Employee Status] = 'Leaver' AND MAX_OUT.max_clock_out IS NOT NULL THEN MAX_OUT.max_clock_out ELSE D_EMP.[Termination Date] END,
			D_EMP.[Staff Present] = ISNULL(MAX_OUT.staff_present,0)
		FROM
			DimEmployee D_EMP
			INNER JOIN staging.temployee SEMP on D_EMP.EmployeeId = SEMP.employee_id 
			INNER JOIN #TMP_MAX_CLOCK_OUT MAX_OUT on SEMP.employee_id = MAX_OUT.employee_id
		WHERE
			1=1


    DECLARE @TABLE_NAME VARCHAR(100) =  N'FactDailyEmployee'
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
	DELETE FROM 
		[dbo].[FactDailyEmployee]
	WHERE
		DateKey>= @MIN_DATE_INT
			
	SELECT 
		@MAX_EMPLOYEE_FACT_KEY = MAX(EmployeeFactKey)
	FROM
		[dbo].[FactDailyEmployee]

	--set the absencereasonkey where it is blank
	SELECT 
		@ABSENCE_REASON_KEY = AbsenceReasonKey 
	FROM 
		DimAbsenceReason 
	WHERE 
		[Absence Reason] = 'N/A'

	--SELECT 
	--	@MAX_EMPLOYEE_FACT_KEY emp_fact_key,@MIN_DATE_INT min_date_int, @MIN_DATE MIN_DATE 
	INSERT INTO		
		[dbo].[FactDailyEmployee]
	SELECT 
		CASE WHEN @MAX_EMPLOYEE_FACT_KEY IS NULL THEN 0 ELSE @MAX_EMPLOYEE_FACT_KEY END + ROW_NUMBER() OVER(ORDER BY EMP.EmployeeKey,DATES.datekey)employeefactkey,
		EMP.EmployeeKey,
		ISNULL(DEPT.DepartmentKey,-1) DepartmentKey,
		ISNULL(SITES.SiteKey,-1)SiteKey,
		DATES.datekey,
		ISNULL(ABS_RES.AbsenceReasonKey, @ABSENCE_REASON_KEY)AbsenceReasonKey,-- 5 = N/A
		ISNULL(ABS_TYPE.AbsenceTypeKey,-1)AbsenceTypeKey,
		CASE WHEN AC.[clock in] IS NOT NULL THEN ISNULL(AC.worked_minutes,0) ELSE 0 END [worked_minutes] ,
		CASE
			WHEN ABS_RES.[Absence Reason] IS NOT NULL THEN ISNULL(AC.worked_minutes,0) + ISNULL(AC.overtime_minutes,0)
			ELSE 0
		END absent_minutes,
		CASE WHEN AC.[clock in] IS NOT NULL THEN ISNULL(AC.overtime_minutes,0) ELSE 0 END [overtime_minutes] ,
		AC.[clock in],
		AC.[clock out],
		null daily_rate,
		ISNULL(EXP_HOURS.workday,0) workday,
		ISNULL(EXP_HOURS.expected_hours,0) expected_hours,
		ISNULL(AC.staff_employed,0)staff_employed,
		@LineageKey
	FROM
		DimDate DATES
		INNER JOIN DimEmployee EMP on DATES.Date >= EMP.[Start Date]
		INNER JOIN staging.temployee SEMP on EMP.EmployeeId = SEMP.employee_id 
		LEFT JOIN DimSIte SITES on SEMP.Site_id = SITES.[site id]
		LEFT JOIN DimEmployeeDepartment DEPT on SEMP.Department_id = DEPT.DepartmentID
		LEFT JOIN [staging].[Employee_Absence_and_Clockin] AC on DATES.date = AC.assignment_date AND SEMP.employee_id = AC.employee_id
		LEFT JOIN DimAbsenceType ABS_TYPE on AC.absence_type = ABS_TYPE.[Absence Type]
		LEFT JOIN DimAbsenceReason ABS_RES on AC.absence_reason= ABS_RES.[Absence Reason]
		LEFT JOIN [staging].[EmployeeExpectedHours] EXP_HOURS on SEMP.employee_id = EXP_HOURS.employee_id and DATES.date = EXP_HOURS.work_date
	WHERE
		DATES.Date BETWEEN @MIN_DATE AND GETDATE()
			
	
	
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
