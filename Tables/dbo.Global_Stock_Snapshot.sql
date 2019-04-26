CREATE TABLE [dbo].[Global_Stock_Snapshot]
(
[ID] [bigint] NOT NULL,
[SiteID] [bigint] NOT NULL,
[Date] [datetime] NOT NULL,
[LotId] [bigint] NOT NULL,
[InventoryID] [bigint] NOT NULL,
[InventoryLocationID] [bigint] NULL,
[PalletID] [bigint] NULL,
[ProductCode] [bigint] NOT NULL,
[Weight] [real] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_SnapshotDate] ON [dbo].[Global_Stock_Snapshot] ([Date]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
