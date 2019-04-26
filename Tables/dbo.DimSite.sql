CREATE TABLE [dbo].[DimSite]
(
[SiteKey] [int] NOT NULL,
[Site ID] [int] NOT NULL,
[Site Code] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Site Name] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimSite] ADD CONSTRAINT [PK_DimSite] PRIMARY KEY CLUSTERED  ([SiteKey]) ON [PRIMARY]
GO
