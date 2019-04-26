CREATE TABLE [dbo].[HR_Product_Subs]
(
[ProductCode] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ProductTypeId] [int] NULL,
[BoxNo] [nvarchar] (5) COLLATE Latin1_General_CI_AS NULL,
[DownGrades] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Substitues] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
