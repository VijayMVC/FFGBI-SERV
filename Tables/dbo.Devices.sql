CREATE TABLE [dbo].[Devices]
(
[SiteID] [int] NOT NULL,
[DeviceID] [bigint] NOT NULL,
[Name] [nvarchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Devices] ADD CONSTRAINT [PK_Devices] PRIMARY KEY CLUSTERED  ([SiteID], [DeviceID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Devices] ADD CONSTRAINT [FK_Devices_Sites] FOREIGN KEY ([SiteID]) REFERENCES [dbo].[Sites] ([SiteID])
GO
