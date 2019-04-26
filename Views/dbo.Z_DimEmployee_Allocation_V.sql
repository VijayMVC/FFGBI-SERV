SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[Z_DimEmployee_Allocation_V]
AS

SELECT 
	[EmployeeKey],
    [EmployeeId],
	[First Name] +' ' +[Last Name] [Employee Name],
    [First Name],
    [Last Name],
    [Paylink],
    [Sex],
    [Start Date],
    [Termination Date],
    [Job Title],
    [Employee Status],
    [Nationality],
    [Employed By],
    [Sub Team],
    [Contract Type],
    [Payment Frequency],
    [Manager],
    [National Insurance],
    [Date of Birth],
    [Passport],
    [Work Schedule],
    [Staff Present]
FROM 
	[FFG_DW].[dbo].[DimEmployee]
	
GO
