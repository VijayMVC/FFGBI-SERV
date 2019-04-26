CREATE TABLE [dbo].[AD_Licences]
(
[LicenceKey] [int] NOT NULL IDENTITY(1, 1),
[LicenceID] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[SkuPartNumber] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[CapabilityStatus] [varchar] (600) COLLATE Latin1_General_CI_AS NULL,
[ConsumedUnits] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AD_Licences] ADD CONSTRAINT [PK_AD_Licences] PRIMARY KEY CLUSTERED  ([LicenceKey]) ON [PRIMARY]
GO
