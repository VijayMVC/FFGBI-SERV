CREATE TABLE [staging].[FFG LIVE_G_L_Entry]
(
[Entry No_] [int] NOT NULL,
[G_L Account No_] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Posting Date] [datetime] NOT NULL,
[Document Type] [int] NOT NULL,
[Document No_] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Global Dimension 1 Code] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[User ID] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Source Code] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Journal Batch Name] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Transaction No_] [int] NOT NULL,
[Document Date] [datetime] NOT NULL,
[External Document No_] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Gen_ Bus_ Posting Group] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Amount] [decimal] (38, 20) NOT NULL,
[Debit Amount] [decimal] (38, 20) NOT NULL,
[Credit Amount] [decimal] (38, 20) NOT NULL,
[VAT Amount] [decimal] (38, 20) NOT NULL,
[Additional-Currency Amount] [decimal] (38, 20) NOT NULL
) ON [PRIMARY]
GO
