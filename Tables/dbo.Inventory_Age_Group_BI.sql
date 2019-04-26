CREATE TABLE [dbo].[Inventory_Age_Group_BI]
(
[ID] [nchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Storage] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Min] [int] NULL,
[Max] [int] NULL,
[Group] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inventory_Age_Group_BI] ADD CONSTRAINT [PK_Inventory_Age_Group_BI] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
