CREATE TABLE [dbo].[AD_Service_Plans]
(
[ServicePlanKey] [int] NOT NULL IDENTITY(1, 1),
[ServicePlanId] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[LicenceID] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[AppliesTo] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ServicePlanName] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[ProvisioningStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AD_Service_Plans] ADD CONSTRAINT [PK_AD_Service_Plans] PRIMARY KEY CLUSTERED  ([ServicePlanKey]) ON [PRIMARY]
GO
