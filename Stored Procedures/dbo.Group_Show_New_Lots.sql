SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Tommy Thomson
-- Create date: 19/01/2015
-- Description:	Data Grid for new lots
-- =============================================
CREATE PROCEDURE [dbo].[Group_Show_New_Lots] 
	-- Add the parameters for the stored procedure here
AS
	SET NOCOUNT ON;
select ln.Id,(cast(s1.code as varchar(5)) + cast(s2.code as varchar(5)) +  cast(s3.code as varchar(5)) +  cast(A.code as varchar(5)) +  cast(O.Code as varchar) +  cast(Q.code as varchar(5))) as LotCode,
(cast(s1.ShName as varchar(5)) + ',' + cast(s2.ShName as varchar(5)) + ',' + cast(s3.ShName as varchar(5)) + ',' + cast(A.name as varchar(5)) + ',' + cast(O.ShName as varchar) + ',' + cast(Q.name as varchar(5))) as LotDesc,
s1.code as [SlaughteredInCode] ,s1.name as [SlaughteredIn], s1.CompanyCode as [slaughteredInComapny],
s2.code as [CutInCode],s2.name as [CutIn], s2.CompanyCode as [CutInComapny],
s3.code as [ProcessedInCode],s3.name as [ProcessedIn], S3.CompanyCode as [processedInComapny],
A.Code as [AgeInCode],A.Name as [AgeIn], 
O.Code as [OriginCode],O.shName as [ShNameOrigin],O.name as [Origin],
Q.Code as [QualityCode] , Q.Name as [Quality],
Y.Code as [ShowInYieldCode], Y.Name as [ShowInYield]
from Lots_new Ln (nolock)
left join LotsSites s1 (nolock) on  Ln.slaughteredIn = s1.code
left join Lotssites s2 (nolock) on  Ln.CutIn = s2.code
left join Lotssites s3 (nolock) on  Ln.processedIn = s3.code
left join LotsAge A (nolock) on Ln.age = A.code
left join LotsOrigin O (nolock) on Ln.Origin = O.code
left join LotsQuality Q (nolock) on Ln.Quality = Q.code
left join LotsShowYield Y (nolock) on Ln.ShowYeild = Y.Code
--where LN.processed = 'Processed'

GO
