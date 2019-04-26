CREATE TABLE [dbo].[DimEmployee]
(
[EmployeeKey] [int] NOT NULL,
[EmployeeId] [int] NOT NULL,
[First Name] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Last Name] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Paylink] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
[Sex] [varchar] (7) COLLATE Latin1_General_CI_AS NULL,
[Start Date] [date] NULL,
[Termination Date] [date] NULL,
[Job Title] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[Employee Status] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Nationality] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[Employed By] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[Sub Team] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[Contract Type] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Payment Frequency] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Manager] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[National Insurance] [bit] NULL,
[Date of Birth] [date] NULL,
[Passport] [bit] NULL,
[Work Schedule] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[Staff Present] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimEmployee] ADD CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED  ([EmployeeKey]) ON [PRIMARY]
GO
