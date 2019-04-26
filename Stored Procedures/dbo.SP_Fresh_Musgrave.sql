SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  procedure [dbo].[SP_Fresh_Musgrave]

AS
BEGIN

exec [dbo].[SP_FreshBase] 'and mat1.description1 like ''%(mus)%'''

END

--  exec [SP_Fresh_Musgrave] ''
GO
