CREATE TABLE [dbo].[Group_Frozen_Stock_Snapshot]
(
[WeekNo] [int] NULL,
[SiteID] [int] NULL,
[ProductCode] [bigint] NULL,
[Total] [float] NULL,
[Regtime] [datetime] NULL,
[AvgPPK] [money] NULL,
[CovertedTotalValue] [float] NULL
) ON [PRIMARY]
GO
