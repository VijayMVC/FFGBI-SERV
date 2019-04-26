CREATE TABLE [dbo].[AD_User_Licences]
(
[UserLicenceKey] [int] NOT NULL IDENTITY(1, 1),
[UserID] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[LicenceId] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AD_User_Licences] ADD CONSTRAINT [PK_AD_User_Licences] PRIMARY KEY CLUSTERED  ([UserLicenceKey]) ON [PRIMARY]
GO
