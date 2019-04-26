CREATE TABLE [dbo].[InventoryLocations]
(
[SiteID] [int] NOT NULL,
[InventoryLocationID] [bigint] NOT NULL,
[InventoryID] [bigint] NOT NULL,
[Code] [nvarchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InventoryLocations] ADD CONSTRAINT [PK_InventoryLocations] PRIMARY KEY CLUSTERED  ([SiteID], [InventoryLocationID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InventoryLocations] ADD CONSTRAINT [FK_InventoryLocations_Sites] FOREIGN KEY ([SiteID]) REFERENCES [dbo].[Sites] ([SiteID])
GO
