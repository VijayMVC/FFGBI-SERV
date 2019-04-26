CREATE TABLE [staging].[AD_Service_Plans]
(
[ServicePlanId] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[LicenceID] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[AppliesTo] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ServicePlanName] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[ProvisioningStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
