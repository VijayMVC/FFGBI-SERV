CREATE TABLE [dbo].[InventoryTypes]
(
[InventoryTypeID] [bigint] NOT NULL,
[Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InventoryTypes] ADD CONSTRAINT [PK_InventoryTypes] PRIMARY KEY CLUSTERED  ([InventoryTypeID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
