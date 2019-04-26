CREATE TABLE [dbo].[Pallets]
(
[SiteID] [int] NOT NULL,
[PalletID] [bigint] NOT NULL,
[PalletNumber] [bigint] NOT NULL,
[InventoryID] [bigint] NOT NULL,
[Invlocation] [bigint] NULL,
[PalletSiteID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Pallets] ADD CONSTRAINT [PK_Pallets] PRIMARY KEY CLUSTERED  ([SiteID], [PalletID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Pallets_PalletID] ON [dbo].[Pallets] ([PalletID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Pallets_PalletNumber] ON [dbo].[Pallets] ([PalletNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<ix_pallet_site,sysname,>] ON [dbo].[Pallets] ([SiteID], [PalletNumber]) INCLUDE ([InventoryID], [Invlocation]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Pallets] ADD CONSTRAINT [FK_Pallets_Sites] FOREIGN KEY ([SiteID]) REFERENCES [dbo].[Sites] ([SiteID])
GO
