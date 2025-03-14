USE [ec]
GO
/****** Object:  Table [dbo].[orders]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NULL,
	[full_name] [nvarchar](255) NULL,
	[phone] [varchar](20) NULL,
	[email] [varchar](255) NULL,
	[province] [nvarchar](255) NULL,
	[district] [nvarchar](255) NULL,
	[commune] [nvarchar](255) NULL,
	[address] [nvarchar](500) NULL,
	[notes] [nvarchar](1000) NULL,
	[discount_code] [varchar](50) NULL,
	[discount_amount] [decimal](10, 2) NULL,
	[shipping_cost] [decimal](10, 2) NULL,
	[subtotal] [decimal](10, 2) NULL,
	[total_amount] [decimal](10, 2) NULL,
	[status] [varchar](50) NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[orders] ON 

INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (1, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(6193.98 AS Decimal(10, 2)), CAST(6198.98 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T17:51:40.697' AS DateTime), CAST(N'2025-01-12T17:51:40.697' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (2, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(600.00 AS Decimal(10, 2)), CAST(605.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T17:54:41.767' AS DateTime), CAST(N'2025-01-12T17:54:41.767' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (3, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(900.00 AS Decimal(10, 2)), CAST(905.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T17:57:27.820' AS DateTime), CAST(N'2025-01-12T17:57:27.820' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (4, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(600.00 AS Decimal(10, 2)), CAST(605.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T17:58:06.960' AS DateTime), CAST(N'2025-01-12T17:58:06.960' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (5, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(900.00 AS Decimal(10, 2)), CAST(905.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:00:33.020' AS DateTime), CAST(N'2025-01-12T18:00:33.020' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (6, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(5849.95 AS Decimal(10, 2)), CAST(5854.95 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:04:41.000' AS DateTime), CAST(N'2025-01-12T18:04:41.000' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (7, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(300.00 AS Decimal(10, 2)), CAST(305.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:07:44.730' AS DateTime), CAST(N'2025-01-12T18:07:44.730' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (8, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(300.00 AS Decimal(10, 2)), CAST(305.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:08:28.250' AS DateTime), CAST(N'2025-01-12T18:08:28.250' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (9, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(300.00 AS Decimal(10, 2)), CAST(305.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:09:52.773' AS DateTime), CAST(N'2025-01-12T18:09:52.773' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (10, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(300.00 AS Decimal(10, 2)), CAST(305.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:10:32.200' AS DateTime), CAST(N'2025-01-12T18:10:32.200' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (11, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(300.00 AS Decimal(10, 2)), CAST(305.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:17:28.683' AS DateTime), CAST(N'2025-01-12T18:17:28.683' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (12, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(300.00 AS Decimal(10, 2)), CAST(305.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:27:22.820' AS DateTime), CAST(N'2025-01-12T18:27:22.820' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (13, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(300.00 AS Decimal(10, 2)), CAST(305.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:31:43.723' AS DateTime), CAST(N'2025-01-12T18:31:43.723' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (14, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(300.00 AS Decimal(10, 2)), CAST(305.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:33:05.710' AS DateTime), CAST(N'2025-01-12T18:33:05.710' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (15, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(300.00 AS Decimal(10, 2)), CAST(305.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:37:29.433' AS DateTime), CAST(N'2025-01-12T18:37:29.433' AS DateTime))
INSERT [dbo].[orders] ([id], [user_id], [full_name], [phone], [email], [province], [district], [commune], [address], [notes], [discount_code], [discount_amount], [shipping_cost], [subtotal], [total_amount], [status], [created_at], [updated_at]) VALUES (16, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(5.00 AS Decimal(10, 2)), CAST(300.00 AS Decimal(10, 2)), CAST(305.00 AS Decimal(10, 2)), N'PENDING', CAST(N'2025-01-12T18:39:00.437' AS DateTime), CAST(N'2025-01-12T18:39:00.437' AS DateTime))
SET IDENTITY_INSERT [dbo].[orders] OFF
GO
ALTER TABLE [dbo].[orders] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[orders] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
