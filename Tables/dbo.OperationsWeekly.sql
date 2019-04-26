CREATE TABLE [dbo].[OperationsWeekly]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[Year] [int] NOT NULL,
[Week] [nvarchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Period End] [datetime] NOT NULL,
[Site Dimension] [nvarchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Cattle Cost LCY] [decimal] (38, 20) NULL,
[Kill Cost LCY] [decimal] (38, 20) NULL,
[Offal Credit £] [decimal] (38, 20) NULL,
[Sales Price £] [decimal] (38, 20) NULL,
[Boning Cost £] [decimal] (38, 20) NULL,
[Quarters Boned] [decimal] (38, 20) NULL,
[KG Boned] [decimal] (38, 20) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OperationsWeekly] ADD CONSTRAINT [PK_OperationsWeekly] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
