SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 06/10/2014
-- Description:	Stored procedure for all frozen
-- =============================================
--exec [dbo].[SP_FrozenBase_DBoguesTest]  
CREATE PROCEDURE [dbo].[ARCHIVED_SP_FrozenBase_DBoguesTest] 
	@_Where nvarchar(max)
AS
BEGIN

declare @SQL as nvarchar(max)	


--set @SQL = convert(nvarchar(max), N'') + N' 
--'

-- DBogues 2016 09 20 : This is horrible logic, but it is what was wanted by Sales at the time. They wanted frozen stock grouped specifically by certain products and to make logic reusable for site specific reports this was best way Daniel had of doing this


SELECT * INTO #tmpStockTable FROM OPENROWSET('SQLNCLI', 'Server=FFGBI-SERV;Trusted_Connection=yes;',
	'EXEC [FFG_DW].[dbo].[SP_FrozenBase_CoreLogic]')

SELECT * FROM #tmpStockTable

/*
+ @_Where
exec(@SQL)
*/
-- drop table #tmpStockTable

--exec [dbo].[SP_FrozenBase_DBoguesTest]



END
GO
