SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 04/06/2014
-- Description:	upload lots
-- =============================================
CREATE PROCEDURE [dbo].[uploadPaths] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
insert into proc_xactpaths
SELECT 1,[xactpath]
      ,[code]
      ,[name]
      ,[shname]
      ,[srcprunit]
      ,[dstprunit]
  FROM [CAMSQL01].[innova].[dbo].[vw_XactPathswithNoXML]

END
GO
