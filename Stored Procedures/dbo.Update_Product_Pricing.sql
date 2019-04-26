SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 20/06/2014
-- Description:	Update Product pricing
-- =============================================
CREATE PROCEDURE [dbo].[Update_Product_Pricing] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--delete from product_price

--CAMPSIE--
insert into dbo.Product_Price 

SELECT        code, 1 AS site, ISNULL([value], 0) AS Value, 
cast(getdate() - 1 as date) AS ValueFrom, 
 cast(getdate() + 5 as date)
                         AS valueto,null
FROM           [CAMSQL01].INNOVA.dbo.vw_matswithNoXML
WHERE        (ISNUMERIC(code) = 1) AND (LEN(code) = 9)


--OMAGH--
insert into dbo.Product_Price 

SELECT        code, 2 AS site, ISNULL([value], 0) AS Value, 
cast(getdate() - 1 as date) AS ValueFrom, 
 cast(getdate() + 5 as date)
                         AS valueto,null
FROM        [OMASQL01].INNOVA.dbo.vw_matswithNoXML
WHERE        (ISNUMERIC(code) = 1) AND (LEN(code) = 9)

--HILTON--
insert into dbo.Product_Price 

SELECT        code, 3 AS site, ISNULL([value], 0) AS Value, 
cast(getdate() - 1 as date) AS ValueFrom, 
 cast(getdate() + 5 as date)
                         AS valueto,null
FROM        [CKTSQL01].INNOVA.dbo.vw_matswithNoXML
WHERE        (ISNUMERIC(code) = 1) AND (LEN(code) = 9)

--DONEGAL--
insert into dbo.Product_Price 

SELECT        code, 4 AS site, ISNULL([value], 0) AS Value, 
cast(getdate() - 1 as date) AS ValueFrom, 
 cast(getdate() + 5 as date)
                         AS valueto,null
FROM        [DONSQL01].INNOVA.dbo.vw_matswithNoXML
WHERE        (ISNUMERIC(code) = 1) AND (LEN(code) = 9)

--GLOUCESTER--
insert into dbo.Product_Price 

SELECT        code, 5 AS site, ISNULL([value], 0) AS Value, 
cast(getdate() - 1 as date) AS ValueFrom, 
 cast(getdate() + 5 as date)
                         AS valueto,null
FROM      [GLOSQL01].INNOVA.dbo.vw_matswithNoXML
WHERE        (ISNUMERIC(code) = 1) AND (LEN(code) = 9)

--MELTON--
insert into dbo.Product_Price 

SELECT        code, 6 AS site, ISNULL([value], 0) AS Value, 
cast(getdate() - 1 as date) AS ValueFrom, 
 cast(getdate() + 5 as date)
                         AS valueto,null
FROM	[MELSQL01].INNOVA.dbo.vw_matswithNoXML
WHERE        (ISNUMERIC(code) = 1) AND (LEN(code) = 9)

--FI--
insert into dbo.Product_Price 

SELECT        code, 7 AS site, ISNULL([value], 0) AS Value, 
cast(getdate() - 1 as date) AS ValueFrom, 
 cast(getdate() + 5 as date)
                         AS valueto,null
FROM	[INGSQL01].FI_INNOVA.dbo.vw_matswithNoXML
WHERE        (ISNUMERIC(code) = 1) AND (LEN(code) = 9)

END
GO
