SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--used for GL Spend Report for Powerbi
CREATE PROCEDURE [dbo].[Z_GL_SPEND_ALL_SITES]
--WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    --insert vendor details into temp table
	SELECT 
		PIH.[no_] collate database_default [no_],
		PIH.[Pay-to Name],
		PIH.[Buy-from Vendor Name],
		PIH.[Buy-from Vendor No_],
		IH.[Shortcut Dimension 1 Code]
	INTO
		#TMP_INVOICE
	FROM 
		[ffgsql02].[FFG-Production].[dbo].[FFG LIVE$Purch_ Inv_ Header] PIH with (nolock) --on MAIN.[Document No_] = PIH.[no_] collate database_default
		LEFT JOIN [ffgsql02].[FFG-Production].[dbo].[FFG LIVE$Sales Invoice Header] IH with (nolock) on PIH.[Vendor Invoice No_]=IH.No_ 
	
	--get the main data for the report
	SELECT 
		MAIN.*,
		PIH.[Pay-to Name],
		PIH.[Buy-from Vendor Name],
		PIH.[Buy-from Vendor No_],
		PIH.[Shortcut Dimension 1 Code] 
	FROM
		(
			SELECT 
				DATES.FiscalMonth,
				DATES.FiscalYear,
				DATES.WeekOfYear,
				GLA.[Site Code],
				LTRIM(REPLACE(GLA.[Site Name],'Foyle',''))[Site Name],
				GLA.Description,
				GLA.[Period Group Name],
				GLA.[Period Account Name],
				GLA.[G_L Account Name],
				GLA.[G_L Account No_],
				GLA.[Header GL Account No_],
				GLA.[Document No_],
				GLA.[Posting Date],
				GLA.InterCompany,
				SUM(FACT_GL.amount)amount,
				SUM(FACT_GL.[Additional-Currency Amount]) [Additional-Currency Amount],
				GLA.[Buy-from Vendor Name],
				GLA.[Document Date],
				GLA.[User ID],
				CASE 
					WHEN GLA.[G_L Account Name] like '%WAGES & SALARIES%' THEN 'Payroll'
					WHEN (GLA.[G_L Account Name] like '%maintenance%' or GLA.[G_L Account No_] IN (213500,214000,214300,214200,214201)) THEN 'Licences/Contracts'
					WHEN GLA.[G_L Account No_] IN (213200,213300,213600,213400,213700,213800,214100) THEN 'Consumables'
					WHEN GLA.[G_L Account No_] IN (208100) THEN 'Telephones'
				ELSE 'Other'
				END AS [GL Classification],
				CASE 
					WHEN GLA.[Period Account Name] = 'Sales' THEN 1
					WHEN GLA.[Period Account Name] = 'Sales commissions' THEN 2
					WHEN GLA.[Period Account Name] = 'Purchases' THEN 3
					WHEN GLA.[Period Account Name] = 'Haulage in of purchases' THEN 4
					WHEN GLA.[Period Account Name] = 'Stock movement' THEN 5
					WHEN GLA.[Period Account Name] = 'Factory wages' THEN 6
					WHEN GLA.[Period Account Name] = 'Insurance - EL liability' THEN 7
					WHEN GLA.[Period Account Name] = 'EL Claim costs and provisions' THEN 8
					WHEN GLA.[Period Account Name] = 'Training expenses (production staff)' THEN 9
					WHEN GLA.[Period Account Name] = 'Engineering expenses' THEN 10
					WHEN GLA.[Period Account Name] = 'Packaging materials' THEN 11
					WHEN GLA.[Period Account Name] = 'Protective clothing, Laundry' THEN 12
					WHEN GLA.[Period Account Name] = 'Knives and saw blades' THEN 13
					WHEN GLA.[Period Account Name] = 'Health & safety' THEN 14
					WHEN GLA.[Period Account Name] = 'Storage charges' THEN 15
					WHEN GLA.[Period Account Name] = 'Cleaning expenses' THEN 16
					WHEN GLA.[Period Account Name] = 'Rendering / blood disposal' THEN 17
					WHEN GLA.[Period Account Name] = 'Plant hire' THEN 18
					WHEN GLA.[Period Account Name] = 'Salt for curing' THEN 19
					WHEN GLA.[Period Account Name] = 'Canteen expenses' THEN 20
					WHEN GLA.[Period Account Name] = 'Sundry factory expenses' THEN 21
					WHEN GLA.[Period Account Name] = 'Fallen stock collection costs' THEN 22
					WHEN GLA.[Period Account Name] = 'Electricity' THEN 23
					WHEN GLA.[Period Account Name] = 'Fuel oil / Tallow' THEN 24
					WHEN GLA.[Period Account Name] = 'Water' THEN 25
					WHEN GLA.[Period Account Name] = 'Effluent plant' THEN 26
					WHEN GLA.[Period Account Name] = 'Repairs and renewals' THEN 27
					WHEN GLA.[Period Account Name] = 'Quality control' THEN 28
					WHEN GLA.[Period Account Name] = 'Insurance - Trade credit' THEN 29
					WHEN GLA.[Period Account Name] = 'Depreciation' THEN 30
					WHEN GLA.[Period Account Name] = 'R & D costs' THEN 31
					WHEN GLA.[Period Account Name] = 'Production consumables' THEN 32
					WHEN GLA.[Period Account Name] = 'Edible fat plant' THEN 33
					WHEN GLA.[Period Account Name] = 'Freight ' THEN 34
					WHEN GLA.[Period Account Name] = 'Distribution wages' THEN 35
					WHEN GLA.[Period Account Name] = 'Lorry expenses' THEN 36
					WHEN GLA.[Period Account Name] = 'Freight Depreciation' THEN 37
					WHEN GLA.[Period Account Name] = 'Wages and salaries' THEN 38
					WHEN GLA.[Period Account Name] = 'Pensions' THEN 39
					WHEN GLA.[Period Account Name] = 'Directors remuneration' THEN 40
					WHEN GLA.[Period Account Name] = 'Insurance' THEN 41
					WHEN GLA.[Period Account Name] = 'Rent & Rates' THEN 42
					WHEN GLA.[Period Account Name] = 'Stationery and postage' THEN 43
					WHEN GLA.[Period Account Name] = 'Telephone and Comms' THEN 44
					WHEN GLA.[Period Account Name] = 'Travelling expenses' THEN 45
					WHEN GLA.[Period Account Name] = 'Advertising, shows and related exps' THEN 46
					WHEN GLA.[Period Account Name] = 'Legal and professional fees' THEN 47
					WHEN GLA.[Period Account Name] = 'Audit fees' THEN 48
					WHEN GLA.[Period Account Name] = 'Motor expenses' THEN 49
					WHEN GLA.[Period Account Name] = 'Bad debt provision' THEN 50
					WHEN GLA.[Period Account Name] = 'Actual Bad debt W/O' THEN 51
					WHEN GLA.[Period Account Name] = 'Security costs' THEN 52
					WHEN GLA.[Period Account Name] = 'Disposal of fixed assets' THEN 53
					WHEN GLA.[Period Account Name] = 'General expenses' THEN 54
					WHEN GLA.[Period Account Name] = 'Customer visits and entertainment' THEN 55
					WHEN GLA.[Period Account Name] = 'Depreciation admin' THEN 56
					WHEN GLA.[Period Account Name] = 'Group costs recharged' THEN 57
					WHEN GLA.[Period Account Name] = 'IT costs' THEN 58
					WHEN GLA.[Period Account Name] = 'Management training costs' THEN 59
					WHEN GLA.[Period Account Name] = 'Storage income' THEN 60
					WHEN GLA.[Period Account Name] = 'Revenue Grant' THEN 61
					WHEN GLA.[Period Account Name] = 'Dividend income' THEN 62
					WHEN GLA.[Period Account Name] = 'Insurance proceeds' THEN 63
					WHEN GLA.[Period Account Name] = 'Other' THEN 64
					WHEN GLA.[Period Account Name] = 'Foreign exchange gains losses' THEN 65
					WHEN GLA.[Period Account Name] = 'Capital grant released' THEN 66
					WHEN GLA.[Period Account Name] = 'Finance costs' THEN 67
				ELSE 999
				END Period_account_name_sort,
				CASE 
					WHEN GLA.[Period Group Name] = 'Turnover' THEN 1
					WHEN GLA.[Period Group Name] = 'Cost Of Sales' THEN 2
					WHEN GLA.[Period Group Name] = 'Distribution Expenses' THEN 3
					WHEN GLA.[Period Group Name] = 'Administrative Expenses' THEN 4
					WHEN GLA.[Period Group Name] = 'Other Operating Income / (Charges)' THEN 5
					WHEN GLA.[Period Group Name] = 'Interest Payable and Similar Charges' THEN 6
					ELSE 999
				END Period_group_name_sort,
				CASE WHEN [site code] in ('FC','FD','FO','FGL','FMM','FC','FH') THEN 1 
					 WHEN [site code] = 'FI' THEN 2
					 WHEN [site code] in ('FP','FB') THEN 3 
					 ELSE 4
				END site_group_sort,
				--row_number() over(partition by GLA.fiscalyear,GLA.fiscalmonth,dates.FiscalWeekOfYear,GLA.[site code]  
				--	order by GLA.fiscalyear,GLA.fiscalmonth,dates.FiscalWeekOfYear,GLA.[site code]  )cattle_rank,
				CASE 
					WHEN [Period Group Name] ='Cost of Sales' AND [Period Account Name] not in ('Purchases','Haulage in of purchases','Stock Movement') THEN 1 
					ELSE 0 
				END 'Factory Running Cost'
			FROM 
				dbo.DimDate DATES
				LEFT JOIN dbo.DimExchangeRate EXR on DATES.DateKey = EXR.DateKey
				INNER JOIN [dbo].[FactGLAccount] FACT_GL on DATES.DateKey = FACT_GL.datekey
				INNER JOIN DimGlAccounts GLA on FACT_GL.entrykey = GLA.EntryKey
			WHERE
				GLA.[G_L Account No_] <=250000
				AND DATES.fiscalYear >= 2017
			GROUP BY
				DATES.FiscalMonth,
				DATES.FiscalYear,
				DATES.WeekOfYear,
				GLA.Description,
				GLA.[Site Code],
				GLA.[Site Name],
				GLA.[Period Group Name],
				GLA.[Period Account Name],
				GLA.[G_L Account Name],
				GLA.[G_L Account No_],
				GLA.[Header GL Account No_],
				GLA.[Document No_],
				GLA.[Posting Date],
				GLA.InterCompany,
				GLA.[Buy-from Vendor Name],
				GLA.[Document Date],
				GLA.[User ID]
		)MAIN
		LEFT JOIN #TMP_INVOICE PIH on MAIN.[Document No_] = PIH.[no_]
			
		---drop temp tables
		IF OBJECT_ID('tempdb.dbo.#TMP_INVOICE', 'U') IS NOT NULL	
			DROP TABLE  #TMP_INVOICE

    RETURN 0;
END;


GO
