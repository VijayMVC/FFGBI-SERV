CREATE TABLE [staging].[Kill_Bone_Weekly_figures]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[Week] [int] NOT NULL,
[Boned back to gross] [decimal] (18, 2) NULL,
[Offal credit] [decimal] (18, 2) NULL,
[Cattle price] [decimal] (18, 2) NULL,
[Freight] [decimal] (18, 2) NULL,
[Other] [decimal] (18, 2) NULL,
[Buy_sell margin] [decimal] (18, 2) NULL,
[Costs] [decimal] (18, 2) NULL,
[Profit_loss per kg] [decimal] (18, 2) NULL,
[Net sales price] [decimal] (18, 2) NULL,
[Cattle cost] [decimal] (18, 2) NULL,
[Processing costs per kg] [decimal] (18, 2) NULL,
[fiscalYear] [int] NULL CONSTRAINT [DF__Kill_Bone__fisca__2EE5E349] DEFAULT ((2018))
) ON [PRIMARY]
GO
