CREATE TABLE [staging].[AD_Groups]
(
[GroupID] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[GroupName] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (600) COLLATE Latin1_General_CI_AS NULL,
[ObjectType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
