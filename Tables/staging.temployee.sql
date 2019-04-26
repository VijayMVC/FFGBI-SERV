CREATE TABLE [staging].[temployee]
(
[employee_id] [int] NOT NULL,
[first_name] [nvarchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[last_name] [nvarchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[paylink] [nvarchar] (25) COLLATE Latin1_General_CI_AS NULL,
[Sex] [nvarchar] (6) COLLATE Latin1_General_CI_AS NULL,
[Site_id] [int] NULL,
[Department_id] [int] NULL,
[Employee_Status] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[date_started_with_company] [datetime] NULL,
[date_of_termination] [datetime] NULL,
[job_title] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[Employed_by] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[sub_team] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[contract_type] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[payment_frequency] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[Labour_type] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[Manager] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[ni_code] [nvarchar] (25) COLLATE Latin1_General_CI_AS NULL,
[date_of_birth] [date] NULL,
[passport_number] [nvarchar] (25) COLLATE Latin1_General_CI_AS NULL,
[nationality] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[work_schedule] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
