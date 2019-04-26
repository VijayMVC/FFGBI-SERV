CREATE TABLE [dbo].[AD_User_Plans]
(
[PlanKey] [int] NOT NULL IDENTITY(1, 1),
[UserID] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[PlanId] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AD_User_Plans] ADD CONSTRAINT [PK_AD_User_Plans] PRIMARY KEY CLUSTERED  ([PlanKey]) ON [PRIMARY]
GO
