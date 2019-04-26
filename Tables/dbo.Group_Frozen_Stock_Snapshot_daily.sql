CREATE TABLE [dbo].[Group_Frozen_Stock_Snapshot_daily]
(
[Date] [datetime] NULL,
[SiteID] [int] NULL,
[ProductCode] [bigint] NULL,
[Total] [float] NULL,
[Regtime] [datetime] NULL,
[AvgPPK] [money] NULL,
[CovertedTotalValue] [float] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Group_Frozen_Stock_Snapshot_daily_Date_SiteID] ON [dbo].[Group_Frozen_Stock_Snapshot_daily] ([Date], [SiteID]) INCLUDE ([AvgPPK], [CovertedTotalValue], [ProductCode], [Regtime], [Total]) ON [PRIMARY]
GO
