USE [ec]
GO
/****** Object:  Table [dbo].[cart]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cart](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[product_id] [bigint] NOT NULL,
	[quantity] [int] NOT NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[cart] ON 

INSERT [dbo].[cart] ([id], [user_id], [product_id], [quantity], [created_at], [updated_at]) VALUES (1, 2, 2, 1, CAST(N'2025-01-06T11:39:52.600' AS DateTime), CAST(N'2025-01-06T11:39:52.600' AS DateTime))
INSERT [dbo].[cart] ([id], [user_id], [product_id], [quantity], [created_at], [updated_at]) VALUES (2, 3, 5, 1, CAST(N'2025-01-06T11:39:52.607' AS DateTime), CAST(N'2025-01-06T11:39:52.607' AS DateTime))
INSERT [dbo].[cart] ([id], [user_id], [product_id], [quantity], [created_at], [updated_at]) VALUES (4, 2, 2, 1, CAST(N'2025-01-06T23:16:49.543' AS DateTime), CAST(N'2025-01-06T23:16:49.543' AS DateTime))
INSERT [dbo].[cart] ([id], [user_id], [product_id], [quantity], [created_at], [updated_at]) VALUES (5, 3, 5, 1, CAST(N'2025-01-06T23:16:49.543' AS DateTime), CAST(N'2025-01-06T23:16:49.543' AS DateTime))
SET IDENTITY_INSERT [dbo].[cart] OFF
GO
ALTER TABLE [dbo].[cart] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[cart] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[cart] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD  CONSTRAINT [FK_cart_product] FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
GO
ALTER TABLE [dbo].[cart] CHECK CONSTRAINT [FK_cart_product]
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD  CONSTRAINT [FK_cart_user] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[cart] CHECK CONSTRAINT [FK_cart_user]
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD  CONSTRAINT [CHK_cart_quantity] CHECK  (([quantity]>(0)))
GO
ALTER TABLE [dbo].[cart] CHECK CONSTRAINT [CHK_cart_quantity]
GO
