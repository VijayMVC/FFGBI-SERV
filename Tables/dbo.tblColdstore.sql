CREATE TABLE [dbo].[tblColdstore]
(
[LocationID] [int] NOT NULL IDENTITY(1, 1),
[ColdStore] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[InnovaInventory] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblColdstore] ADD CONSTRAINT [PK_tblColdstore] PRIMARY KEY CLUSTERED  ([LocationID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
