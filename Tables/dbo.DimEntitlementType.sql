CREATE TABLE [dbo].[DimEntitlementType]
(
[EntitlementTypeKey] [int] NOT NULL,
[EntitlementId] [int] NOT NULL,
[Entitlement Type] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Entitlement Group] [varchar] (15) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimEntitlementType] ADD CONSTRAINT [PK_table_109] PRIMARY KEY CLUSTERED  ([EntitlementTypeKey]) ON [PRIMARY]
GO
