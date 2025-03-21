USE [ec]
GO
/****** Object:  Table [dbo].[products]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[products](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](max) NULL,
	[price] [decimal](10, 2) NOT NULL,
	[stock_quantity] [int] NOT NULL,
	[image_url] [nvarchar](255) NULL,
	[category_id] [bigint] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [bigint] NULL,
	[search_vector] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[products] ON 

INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (1, N'iPhone 15 Pro', N'Latest iPhone with advanced camera system', CAST(999.99 AS Decimal(10, 2)), 50, N'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5', 1, CAST(N'2025-01-06T11:39:52.567' AS DateTime), CAST(N'2025-01-08T16:48:13.410' AS DateTime), NULL, N'iPhone 15 Pro Latest iPhone with advanced camera system')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (2, N'MacBook Pro 16"', N'Powerful laptop for professionals', CAST(1999.99 AS Decimal(10, 2)), 30, N'https://images.unsplash.com/photo-1496181133206-80ce9b88a853', 2, CAST(N'2025-01-06T11:39:52.567' AS DateTime), CAST(N'2025-01-08T16:48:13.410' AS DateTime), NULL, N'MacBook Pro 16" Powerful laptop for professionals')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (3, N'Sony 65" OLED TV', N'Premium 4K OLED Television', CAST(1999.99 AS Decimal(10, 2)), 20, N'https://images.unsplash.com/photo-1593784991095-a205069470b6', 3, CAST(N'2025-01-06T11:39:52.567' AS DateTime), CAST(N'2025-01-08T16:48:13.410' AS DateTime), NULL, N'Sony 65" OLED TV Premium 4K OLED Television')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (4, N'Sony WH-1000XM4', N'Premium noise cancelling headphones', CAST(349.99 AS Decimal(10, 2)), 100, N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e', 4, CAST(N'2025-01-06T11:39:52.567' AS DateTime), CAST(N'2025-01-08T16:48:13.410' AS DateTime), NULL, N'Sony WH-1000XM4 Premium noise cancelling headphones')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (5, N'PS5', N'Next-gen gaming console', CAST(499.99 AS Decimal(10, 2)), 25, N'https://images.unsplash.com/photo-1606813907291-d86efa9b94db', 5, CAST(N'2025-01-06T11:39:52.567' AS DateTime), CAST(N'2025-01-08T16:48:13.410' AS DateTime), NULL, N'PS5 Next-gen gaming console')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (7, N'Duy', N'k', CAST(99.00 AS Decimal(10, 2)), 9, N'https://images.unsplash.com/photo-1531297484001-80022131f5a1?q=80&w=2020&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 4, CAST(N'2025-01-07T09:38:10.223' AS DateTime), CAST(N'2025-01-11T17:27:21.370' AS DateTime), NULL, N'Duy k')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (8, N'Na', N'kk', CAST(99.00 AS Decimal(10, 2)), 1, N'1736218046629_Screenshot (4).png', 4, CAST(N'2025-01-07T09:47:26.827' AS DateTime), CAST(N'2025-01-08T16:48:13.410' AS DateTime), NULL, N'Na kk')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (23, N'JLN', N'SGs', CAST(353.00 AS Decimal(10, 2)), 10, N'uploads/products/1736579990005.png', 2, CAST(N'2025-01-08T17:11:46.917' AS DateTime), CAST(N'2025-01-11T14:19:50.087' AS DateTime), 1, N'JLN SGs')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (28, N'JLNshs', N'dhs', CAST(666.00 AS Decimal(10, 2)), 32, N'https://images.unsplash.com/photo-1531297484001-80022131f5a1?q=80&w=2020&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 2, CAST(N'2025-01-08T17:32:10.750' AS DateTime), CAST(N'2025-01-08T17:32:10.760' AS DateTime), 1, N'JLNshs dhs')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (30, N'JLNshs', N'sf', CAST(22.00 AS Decimal(10, 2)), 22, N'https://images.unsplash.com/photo-1531297484001-80022131f5a1?q=80&w=2020&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 4, CAST(N'2025-01-08T17:39:51.977' AS DateTime), CAST(N'2025-01-08T17:39:51.997' AS DateTime), 1, N'JLNshs sf')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (32, N'JLNshs', N'sshds', CAST(22.00 AS Decimal(10, 2)), 22, N'uploads/products/1736333124648.png', 4, CAST(N'2025-01-08T17:45:24.733' AS DateTime), CAST(N'2025-01-08T17:45:24.770' AS DateTime), 1, N'JLNshs sshds')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (33, N'XIN CHAO', N'Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử', CAST(50.00 AS Decimal(10, 2)), 22, N'uploads/products/1736338323381.png', 5, CAST(N'2025-01-08T19:12:03.520' AS DateTime), CAST(N'2025-01-11T15:47:47.040' AS DateTime), 1, N'XIN CHAO Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (35, N'XIN CHAO CAC BE', N'Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử', CAST(500.00 AS Decimal(10, 2)), 99, N'https://www.bing.com/th?id=OIP.s2SHIZUjABr-gwswyqZhkAHaE7&w=148&h=100&c=8&rs=1&qlt=90&o=6&dpr=1.5&pid=3.1&rm=2', 2, CAST(N'2025-01-08T19:17:06.703' AS DateTime), CAST(N'2025-01-11T15:47:18.797' AS DateTime), 1, N'XIN CHAO CAC BE Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (38, N'Upload File', N'Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử', CAST(300.00 AS Decimal(10, 2)), 22, N'uploads/products/1736581136103.png', 1, CAST(N'2025-01-11T14:38:56.203' AS DateTime), CAST(N'2025-01-11T15:46:57.397' AS DateTime), 1, N'Upload File Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử
Xin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thửXin chào tất cả các bạn dưới đây là một sản phẩm tôi test thử')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (39, N'Test Upload SP 29', N'SỐ 38 UPLOAD FILE UPDATE ', CAST(300.00 AS Decimal(10, 2)), 34, N'uploads/products/1736585308945.png', 4, CAST(N'2025-01-11T15:48:29.053' AS DateTime), CAST(N'2025-01-11T16:30:20.143' AS DateTime), 1, N'Test Upload SP 29 SỐ 38 UPLOAD FILE UPDATE ')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (40, N'Test Upload SP30', N'fs', CAST(300.00 AS Decimal(10, 2)), 34, N'https://th.bing.com/th?id=OIP.BIATVRhLpfWe4SO5Tr0FfwHaHG&w=255&h=244&c=8&rs=1&qlt=90&o=6&dpr=1.5&pid=3.1&rm=2', 4, CAST(N'2025-01-11T17:23:28.923' AS DateTime), CAST(N'2025-01-11T17:23:28.957' AS DateTime), 1, N'Test Upload SP30 fs')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (41, N'Test Upload SP31', N'Thử nhá', CAST(300.00 AS Decimal(10, 2)), 34, N'uploads/products/1736591302882.png', 4, CAST(N'2025-01-11T17:28:22.950' AS DateTime), CAST(N'2025-01-11T17:28:22.963' AS DateTime), 1, N'Test Upload SP31 Thử nhá')
INSERT [dbo].[products] ([id], [name], [description], [price], [stock_quantity], [image_url], [category_id], [created_at], [updated_at], [created_by], [search_vector]) VALUES (43, N'Test Upload SP32', N'd', CAST(300.00 AS Decimal(10, 2)), 34, N'https://th.bing.com/th/id/OIP.xY5F8MQv7vWD3COukM4cGQHaHa?w=168&h=180&c=7&r=0&o=5&dpr=1.5&pid=1.7', 11, CAST(N'2025-01-11T17:32:39.663' AS DateTime), CAST(N'2025-01-11T17:32:39.670' AS DateTime), 1, N'Test Upload SP32 d')
SET IDENTITY_INSERT [dbo].[products] OFF
GO
/****** Object:  Index [IDX_Products_Fulltext_Key]    Script Date: 1/12/2025 6:43:31 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Products_Fulltext_Key] ON [dbo].[products]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_products_name]    Script Date: 1/12/2025 6:43:31 PM ******/
CREATE NONCLUSTERED INDEX [idx_products_name] ON [dbo].[products]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_products_price]    Script Date: 1/12/2025 6:43:31 PM ******/
CREATE NONCLUSTERED INDEX [idx_products_price] ON [dbo].[products]
(
	[price] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[products] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[products] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD  CONSTRAINT [FK_products_category] FOREIGN KEY([category_id])
REFERENCES [dbo].[categories] ([id])
GO
ALTER TABLE [dbo].[products] CHECK CONSTRAINT [FK_products_category]
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD  CONSTRAINT [FK_products_created_by] FOREIGN KEY([created_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[products] CHECK CONSTRAINT [FK_products_created_by]
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD  CONSTRAINT [CHK_products_price_positive] CHECK  (([price]>=(0)))
GO
ALTER TABLE [dbo].[products] CHECK CONSTRAINT [CHK_products_price_positive]
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD  CONSTRAINT [CHK_products_stock_positive] CHECK  (([stock_quantity]>=(0)))
GO
ALTER TABLE [dbo].[products] CHECK CONSTRAINT [CHK_products_stock_positive]
GO
