CREATE TABLE [dbo].[Group-Nav_Late_Order_Detailed]
(
[Site] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Code] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[OrderNo] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[SellToCustomerNo] [int] NULL,
[SellToCustomerName] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[ReleasedDate] [datetime] NULL,
[ShipmentDate] [datetime] NULL,
[ReleaseBy] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[ReleaseTime] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
