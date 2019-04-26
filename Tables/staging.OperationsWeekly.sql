CREATE TABLE [staging].[OperationsWeekly]
(
[Year] [int] NOT NULL,
[Week] [nvarchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Period End] [datetime] NOT NULL,
[Site Dimension] [nvarchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Cattle Cost LCY] [decimal] (38, 20) NOT NULL,
[Kill Cost LCY] [decimal] (38, 20) NOT NULL,
[Offal Credit £] [decimal] (38, 20) NOT NULL,
[Sales Price £] [decimal] (38, 20) NOT NULL,
[Boning Cost £] [decimal] (38, 20) NOT NULL,
[Quarters Boned] [decimal] (38, 20) NOT NULL,
[KG Boned] [decimal] (38, 20) NOT NULL
) ON [PRIMARY]
GO
