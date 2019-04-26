CREATE TABLE [dbo].[Staging_Pallets]
(
[SiteID] [int] NOT NULL,
[PalletID] [int] NOT NULL,
[PalletNumber] [bigint] NULL,
[InventoryID] [bigint] NULL,
[InvlocationsID] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Staging_Pallets] ADD CONSTRAINT [PK_Staging_Pallets] PRIMARY KEY CLUSTERED  ([SiteID], [PalletID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
