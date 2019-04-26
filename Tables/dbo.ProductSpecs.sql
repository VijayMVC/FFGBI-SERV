CREATE TABLE [dbo].[ProductSpecs]
(
[ProductCode] [bigint] NOT NULL,
[SpecID] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProductSpecs] ADD CONSTRAINT [PK_ProductSpecs] PRIMARY KEY CLUSTERED  ([ProductCode], [SpecID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ProductSpecs_SpecID] ON [dbo].[ProductSpecs] ([SpecID]) INCLUDE ([ProductCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ProductSpecs_SpecID_2] ON [dbo].[ProductSpecs] ([SpecID]) INCLUDE ([ProductCode]) ON [PRIMARY]
GO
