CREATE TABLE [dbo].[proc_xactpaths]
(
[SiteID] [int] NOT NULL,
[xactpath] [int] NOT NULL,
[code] [nvarchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[name] [nvarchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[shname] [nvarchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[srcprunit] [int] NOT NULL,
[dstprunit] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[proc_xactpaths] ADD CONSTRAINT [pk_proc_xactpaths] PRIMARY KEY CLUSTERED  ([SiteID], [xactpath]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
