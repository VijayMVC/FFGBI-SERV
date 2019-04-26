CREATE TABLE [dbo].[DimGlAccounts]
(
[EntryKey] [int] NOT NULL IDENTITY(1, 1),
[Entry No_] [int] NOT NULL,
[G_L Account No_] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Posting Date] [datetime] NOT NULL,
[Document Type] [int] NOT NULL,
[Document No_] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Site Code] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Site Name] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[User ID] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Source Code] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Journal Batch Name] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Transaction No_] [int] NOT NULL,
[Document Date] [datetime] NOT NULL,
[External Document No_] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[InterCompany] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[G_L Account Name] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[Period Account Name] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Period Group Name] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Header GL Account No_] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Buy-from Vendor Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimGlAccounts] ADD CONSTRAINT [PK_DimGlAccounts] PRIMARY KEY CLUSTERED  ([EntryKey]) ON [PRIMARY]
GO
