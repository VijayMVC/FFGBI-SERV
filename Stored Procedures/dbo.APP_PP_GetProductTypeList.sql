SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [GetProductTypeList] 
CREATE PROCEDURE [dbo].[APP_PP_GetProductTypeList] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT 
		Distinct Upper(Replace([Name],'*','')) as ProductType,[ProductTypeID]
	FROM 
		[FFG_DW].[dbo].[ProductTypes] with (nolock)
	where 
		[ProductTypeID] in (
			select [MaterialType] FROM [FFG_DW].[dbo].[Products] with (nolock)
		)
	order by 
		Upper(Replace([Name],'*','')) asc
END
GO
