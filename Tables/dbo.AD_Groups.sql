CREATE TABLE [dbo].[AD_Groups]
(
[GroupKey] [int] NOT NULL IDENTITY(1, 1),
[GroupID] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[GroupName] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (600) COLLATE Latin1_General_CI_AS NULL,
[ObjectType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AD_Groups] ADD CONSTRAINT [PK_AD_Groups] PRIMARY KEY CLUSTERED  ([GroupKey]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AD_Groups_USER_ID_INDEX] ON [dbo].[AD_Groups] ([GroupID]) ON [PRIMARY]
GO
