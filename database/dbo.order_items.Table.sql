USE [ec]
GO
/****** Object:  Table [dbo].[order_items]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_items](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[order_id] [bigint] NULL,
	[product_id] [bigint] NULL,
	[quantity] [int] NULL,
	[price] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[order_items] ON 

INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (1, 1, 2, 2, CAST(1999.99 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (2, 1, 7, 3, CAST(99.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (3, 1, 8, 3, CAST(99.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (4, 1, 35, 2, CAST(500.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (5, 1, 41, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (6, 1, 40, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (7, 2, 40, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (8, 2, 39, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (9, 3, 40, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (10, 3, 39, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (11, 3, 41, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (12, 4, 39, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (13, 4, 40, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (14, 5, 41, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (15, 5, 40, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (16, 5, 39, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (17, 6, 2, 1, CAST(1999.99 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (18, 6, 1, 1, CAST(999.99 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (19, 6, 3, 1, CAST(1999.99 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (20, 6, 5, 1, CAST(499.99 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (21, 6, 4, 1, CAST(349.99 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (22, 7, 40, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (23, 8, 40, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (24, 9, 39, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (25, 10, 41, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (26, 11, 41, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (27, 12, 39, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (28, 13, 39, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (29, 14, 40, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (30, 15, 40, 1, CAST(300.00 AS Decimal(10, 2)))
INSERT [dbo].[order_items] ([id], [order_id], [product_id], [quantity], [price]) VALUES (31, 16, 41, 1, CAST(300.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[order_items] OFF
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([id])
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
GO
