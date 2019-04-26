CREATE TABLE [dbo].['data source$']
(
[Related Invoices] [float] NULL,
[Site Code] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Customer No#] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Customer Name] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Blocked] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Salesperson Debtors] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Customer Team] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Document Type] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Document No#] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[External Document No#] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Posting Date] [datetime] NULL,
[Document Date] [datetime] NULL,
[Due Date] [datetime] NULL,
[Aged Days] [float] NULL,
[Aged Periods] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Currency Code] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Original Amount] [float] NULL,
[Remaining Amount] [float] NULL,
[Original Amt# (LCY)] [float] NULL,
[Remaining Amt# (LCY)] [float] NULL,
[Open] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
