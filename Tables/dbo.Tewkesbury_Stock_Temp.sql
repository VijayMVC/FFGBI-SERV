CREATE TABLE [dbo].[Tewkesbury_Stock_Temp]
(
[PalletId] [bigint] NOT NULL,
[site] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tewkesbury_Stock_Temp] ADD CONSTRAINT [PK_Tewkesbury_Stock_Temp] PRIMARY KEY CLUSTERED  ([PalletId], [site]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
