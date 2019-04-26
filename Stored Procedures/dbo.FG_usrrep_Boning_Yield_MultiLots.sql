SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Jason Mcdevitt
-- Create date: 22/04/11
-- Description:	Procedure to Return Report Details Based On ReportID
-- =============================================

--exec [FG_usrrep_Boning_Yield_MultiLots]  '07/06/2017','07/06/2017','151515111011',0,99999
CREATE PROCEDURE [dbo].[FG_usrrep_Boning_Yield_MultiLots] 

@BeginDate datetime,
@EndDate datetime,
@_Lots nvarchar(max),
@FromBatch int,
@ToBatch int

AS

exec [GLOSQL01].[Innova].[dbo].[usrrep_boning_Yield_MultiLots] @BeginDate,@EndDate,@_Lots,@FromBatch,@ToBatch

GO
