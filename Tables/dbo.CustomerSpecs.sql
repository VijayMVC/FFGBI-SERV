CREATE TABLE [dbo].[CustomerSpecs]
(
[SpecID] [bigint] NOT NULL,
[Code] [nvarchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[Name] [nvarchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[Group] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Priority] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerSpecs] ADD CONSTRAINT [PK_CustomerSpecs] PRIMARY KEY CLUSTERED  ([SpecID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
