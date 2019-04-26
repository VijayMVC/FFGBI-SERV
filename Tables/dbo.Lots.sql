CREATE TABLE [dbo].[Lots]
(
[SiteID] [int] NOT NULL,
[LotID] [bigint] NOT NULL,
[Code] [bigint] NOT NULL,
[Name] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ExtCode] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Dimension1] [int] NULL,
[Description2] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description5] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[SLHouse] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[BRCountry] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RICountry] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lots] ADD CONSTRAINT [PK_Lots] PRIMARY KEY CLUSTERED  ([SiteID], [LotID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Lots_Dimension1] ON [dbo].[Lots] ([Dimension1]) INCLUDE ([Code], [Name]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Lots_SiteID_Code] ON [dbo].[Lots] ([SiteID], [Code]) INCLUDE ([Name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lots] ADD CONSTRAINT [FK_Lots_Sites] FOREIGN KEY ([SiteID]) REFERENCES [dbo].[Sites] ([SiteID])
GO
