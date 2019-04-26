SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Jason McDevitt
-- Create date: 15/01/15
-- Description:	Record Report Usuage on Site
-- =============================================
CREATE PROCEDURE [dbo].[InsertReportLog] 
	@ReportID uniqueidentifier,
	@UserName nvarchar(2000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Insert Into [Reports_Log]
	select NewID(),@ReportID,@UserName, getdate()
END

GO
