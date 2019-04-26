SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Kevin Hargan
-- Create date: 10/07/2017
-- Description:	GLO
-- =============================================
--exec [FG_usrrep_IntoBoning_Report_MultiLots] '07/06/2017','07/06/2017','151515111011',0,99999

CREATE PROCEDURE [dbo].[FG_usrrep_IntoBoning_Report_MultiLots] 

@BeginDate datetime,
@EndDate datetime,
@_Lots nvarchar(max),
@FromBatch int,
@ToBatch int

AS

exec [GLOSQL01].[Innova].[dbo].[usrrep_IntoBoning_Report_MultiLots] @BeginDate,@EndDate,@_Lots,@FromBatch,@ToBatch


GO
