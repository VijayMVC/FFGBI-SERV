CREATE TABLE [dbo].[LotsQuality]
(
[Id] [int] NOT NULL,
[Code] [int] NOT NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ShName] [varchar] (30) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LotsQuality] ADD CONSTRAINT [PK_LotsQuality] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
