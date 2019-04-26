CREATE TABLE [dbo].[ProductTypes]
(
[ProductTypeID] [bigint] NOT NULL,
[Code] [nvarchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[Name] [nvarchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[Description2] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description3] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description4] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProductTypes] ADD CONSTRAINT [PK_ProductTypes] PRIMARY KEY CLUSTERED  ([ProductTypeID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
