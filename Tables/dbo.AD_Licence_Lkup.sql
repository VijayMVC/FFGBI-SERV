CREATE TABLE [dbo].[AD_Licence_Lkup]
(
[LicenceCode] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[LicenceName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AD_Licence_Lkup] ADD CONSTRAINT [PK_Licence_Lkup] PRIMARY KEY CLUSTERED  ([LicenceCode]) ON [PRIMARY]
GO
