CREATE TABLE [dbo].[LotsSites]
(
[Id] [int] NOT NULL,
[Code] [int] NOT NULL,
[Name] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ShName] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CompanyCode] [int] NULL,
[RICountry2] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RICountry3] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RICountry4] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RICountry5] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LotsSites] ADD CONSTRAINT [PK_LotsSites] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
