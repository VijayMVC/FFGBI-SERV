SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Hargan, Kevin>
-- Create date: <20/12/16,>
-- Description:	<Get lots list for reports>
-- =============================================

--exec [SP_GetLotListForReports] '01/25/16', '01/25/16', 0, 3

Create procedure [dbo].[SP_GetLotListForReports]
@BeginDate datetime,
@EndDate datetime,
@LotsTypes int,
@site int
As

If @LotsTypes = 0 
begin 
--Boning Hall Lots
--print 'Boning'
	SELECT  distinct 
		case when len(proc_lots.Code) < 3 then  substring('00' + proc_lots.Code,len( proc_lots.Code),3) else proc_lots.Code end as Code, proc_lots.Name, proc_Lots.extcode  
	FROM         	
		proc_matxacts AS x WITH (nolock)  
		INNER JOIN proc_lots WITH (nolock) ON x.tolot = proc_lots.lot and proc_lots.SiteID = @site
		inner join proc_xactpaths pxp with (nolock) on x.xactpath = pxp.xactpath and x.SiteID = pxp.SiteID
	WHERE  
		proc_lots.dimension1 = '1' 
		and x.material <> '13727'
		--AND (x.xactpath in( 1,178,2))
		and pxp.description1 = 'bonein' 
		AND CONVERT(nvarchar(10), x.regtime, 102) between CONVERT(nvarchar(10), @BeginDate, 102)  and CONVERT(nvarchar(10), @EndDate, 102)
		and x.SiteID = @site
	
	union

	SELECT  distinct 
		case when len(proc_lots.Code) < 3 then  substring('00' + proc_lots.Code,len( proc_lots.Code),3) else proc_lots.Code end as Code , proc_lots.Name, proc_Lots.extcode
	FROM 
		proc_packs AS proc_packs WITH (nolock) 
		INNER JOIN proc_lots WITH (nolock) ON proc_packs.lot = proc_lots.lot and proc_lots.SiteID = @site
	WHERE  
		proc_lots.dimension1 = '1' and proc_packs.rtype <> 4
		AND CONVERT(nvarchar(10), proc_packs.prday, 102) between CONVERT(nvarchar(10), @BeginDate, 102)  and CONVERT(nvarchar(10), @EndDate, 102)
		and proc_packs.po is null
		and proc_packs.SiteID = @site
	order by 
		case when len(proc_lots.Code) < 3 then  substring('00' + proc_lots.Code,len( proc_lots.Code),3) else proc_lots.Code end
End
else
 Begin
 --print 'FP'
--FP Lots
	SELECT  distinct case when len(proc_lots.Code) < 3 then  substring('00' + proc_lots.Code,len( proc_lots.Code),3) else proc_lots.Code end as Code , proc_lots.Name, proc_Lots.extcode
	 FROM 
	proc_packs AS proc_packs WITH (nolock) 
	INNER JOIN proc_lots WITH (nolock) ON proc_packs.lot = proc_lots.lot and proc_lots.SiteID = @site
	WHERE  
	proc_packs.rtype <> 4
	AND CONVERT(nvarchar(10), proc_packs.regtime, 102) between CONVERT(nvarchar(10), @BeginDate, 102)  and CONVERT(nvarchar(10), @EndDate, 102)
	and isnull(proc_packs.po,0) > 0 and proc_lots.Code <> '99'
	and proc_packs.SiteID = @site
	order by case when len(proc_lots.Code) < 3 then  substring('00' + proc_lots.Code,len( proc_lots.Code),3) else proc_lots.Code end

end
GO
