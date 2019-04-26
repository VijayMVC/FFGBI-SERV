CREATE TABLE [dbo].[DimEmployeeDepartment]
(
[DepartmentKey] [int] NOT NULL,
[DepartmentID] [int] NOT NULL,
[DepartmentName] [varchar] (60) COLLATE Latin1_General_CI_AS NOT NULL,
[DepartmentCode] [varchar] (8) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimEmployeeDepartment] ADD CONSTRAINT [DimDepartment_pk] PRIMARY KEY CLUSTERED  ([DepartmentKey]) ON [PRIMARY]
GO
