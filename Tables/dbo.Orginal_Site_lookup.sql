CREATE TABLE [dbo].[Orginal_Site_lookup]
(
[SiteId] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrgSiteId] [int] NOT NULL,
[OrgSiteName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Orginal_Site_lookup] ADD CONSTRAINT [PK_Orginal_Site_lookup] PRIMARY KEY CLUSTERED  ([SiteId], [OrgSiteId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
