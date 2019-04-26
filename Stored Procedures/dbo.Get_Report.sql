SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Jason Mcdevitt
-- Create date: 22/04/11
-- Description:	Procedure to Return Report Details Based On ReportID
-- =============================================

CREATE PROCEDURE [dbo].[Get_Report] 
@ReportId uniqueidentifier
AS

select * 
from DW_report R 
where r.reportID = @ReportId
GO
