CREATE TABLE [staging].[AD_Licences]
(
[LicenceID] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[SkuPartNumber] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[CapabilityStatus] [varchar] (600) COLLATE Latin1_General_CI_AS NULL,
[ConsumedUnits] [int] NULL
) ON [PRIMARY]
GO
