CREATE TABLE [dbo].[LotsShowYield]
(
[Id] [int] NOT NULL,
[Code] [int] NULL,
[Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LotsShowYield] ADD CONSTRAINT [PK_LotsShowYeild] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
