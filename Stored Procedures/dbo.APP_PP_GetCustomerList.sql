SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[APP_PP_GetCustomerList]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- exec [dbo].[APP_PP_GetCustomerList]

	SELECT Distinct 
		[Name] as Customer,
		isnull([priority],100)
	FROM 
		[FFG_DW].[dbo].[CustomerSpecs] with (nolock)
	Order By 
		isnull([priority],100)
END
GO
