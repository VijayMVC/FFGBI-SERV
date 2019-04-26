CREATE TABLE [dbo].[Z_PL_COMPARISONS_TMP]
(
[id] [int] NOT NULL,
[FiscalMonth] [int] NULL,
[FiscalYear] [char] (4) COLLATE Latin1_General_CI_AS NULL,
[FiscalFirstDayOfMonth] [date] NULL,
[Site Code] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Site Name] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Period Group Name] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Period Account Name] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[G_L Account Name] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[G_L Account No_] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Header G_L Account No_] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Document No_] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Posting Date] [datetime] NULL,
[InterCompany] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[amount] [decimal] (38, 6) NULL,
[Additional-Currency Amount] [decimal] (38, 6) NULL,
[Buy-from Vendor Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
