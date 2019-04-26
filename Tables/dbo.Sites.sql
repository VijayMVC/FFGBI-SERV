CREATE TABLE [dbo].[Sites]
(
[SiteID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ShName] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sites] ADD CONSTRAINT [PK_Sites] PRIMARY KEY CLUSTERED  ([SiteID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
