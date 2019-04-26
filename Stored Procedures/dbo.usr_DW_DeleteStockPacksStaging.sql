SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		David Bogues / Tommy T
-- Create date: 2016-11-24
-- Description:	Updates to the DW SSIS Logic. Moved Dynamic SQL into SP
-- =============================================
CREATE PROCEDURE [dbo].[usr_DW_DeleteStockPacksStaging]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Delete From dbo.Staging_Stock_Packs
END
GO
