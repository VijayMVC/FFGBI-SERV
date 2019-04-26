CREATE TABLE [dbo].[LotsOrigin]
(
[ID] [int] NOT NULL,
[Code] [int] NOT NULL,
[Name] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Shname] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[LotsCode] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LotsOrigin] ADD CONSTRAINT [PK_LotsOrigin] PRIMARY KEY CLUSTERED  ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
