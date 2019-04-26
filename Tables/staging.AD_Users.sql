CREATE TABLE [staging].[AD_Users]
(
[UserID] [varchar] (40) COLLATE Latin1_General_CI_AS NULL,
[FullName] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[GivenName] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[Surname] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[Department] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[JobTitle] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[UserName] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[AccountEnabled] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[ObjectType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[UserType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
