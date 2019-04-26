SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 04/06/2014
-- Description:	Upload of materials
-- =============================================
CREATE PROCEDURE [dbo].[UploadProducts] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
Delete from  dbo.Products	

insert into dbo.Products

Select cast(code as bigint)
, name, dimension1, dimension2, dimension3, dimension4, description1,
description2,description3,description4,description5,description6,description7,description8,
isnull(materialtype,0),base, Fabcode1, fabcode2,
case when Fabcode3 = 'Fresh' THEN 1 else 2 end as storageType
 from [FFG-SQL01].innova.dbo.vw_matswithNoXML
 where --active = 1 and
ISNUMERIC(code)= 1 and 
  LEN(code) = 9
 
 --select * from [FFG-SQL01].innova.dbo.vw_matswithNoXML where materialtype is null and active = 1 and LEN(code) = 9

END
GO
