SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		David Bogues 
-- Create date: 2017-02-08
-- Description:	Clears out the HR Ire Order Staging
-- =============================================
CREATE PROCEDURE [dbo].[APP_HR_Test]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select Top 10 * From HR_Order_Summary_Import
END
GO
