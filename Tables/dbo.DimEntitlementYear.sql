CREATE TABLE [dbo].[DimEntitlementYear]
(
[EntitlementYearKey] [int] NOT NULL,
[Entitlement Year] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimEntitlementYear] ADD CONSTRAINT [PK_OrderItem] PRIMARY KEY CLUSTERED  ([EntitlementYearKey]) ON [PRIMARY]
GO
