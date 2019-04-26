CREATE TABLE [dbo].[Hilton_shipment]
(
[Site] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Description] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Order No_] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Ordered Qty_] [decimal] (18, 0) NULL,
[weight] [float] NULL,
[Product Code] [nvarchar] (18) COLLATE Latin1_General_CI_AS NULL,
[Box Number] [nvarchar] (18) COLLATE Latin1_General_CI_AS NULL,
[ProductType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Shipment Date] [datetime] NULL,
[Delivered Date] [datetime] NULL,
[PO] [nvarchar] (18) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
