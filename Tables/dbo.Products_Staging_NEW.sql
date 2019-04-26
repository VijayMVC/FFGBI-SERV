CREATE TABLE [dbo].[Products_Staging_NEW]
(
[ProductCode] [bigint] NULL,
[Name] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Dimension1] [int] NULL,
[Dimension2] [int] NULL,
[Dimension3] [int] NULL,
[Dimension4] [int] NULL,
[Description1] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description2] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description3] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description4] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description5] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description6] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description7] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description8] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[MaterialType] [bigint] NULL,
[BaseProductCode] [bigint] NULL,
[FabCode1] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[FabCode2] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[StorageType] [int] NULL,
[DaysTillExpire] [int] NULL,
[Conservation] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Conservation_Name] [nvarchar] (150) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
