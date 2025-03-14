USE [ec]
GO
/****** Object:  Table [dbo].[discount_codes]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[discount_codes](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NULL,
	[discount_type] [nvarchar](20) NOT NULL,
	[discount_value] [decimal](10, 2) NOT NULL,
	[min_purchase_amount] [decimal](10, 2) NULL,
	[max_discount_amount] [decimal](10, 2) NULL,
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[max_uses] [int] NULL,
	[used_count] [int] NULL,
	[is_active] [bit] NULL,
	[can_combine] [bit] NULL,
	[max_codes_per_order] [int] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[discount_codes] ON 

INSERT [dbo].[discount_codes] ([id], [code], [description], [discount_type], [discount_value], [min_purchase_amount], [max_discount_amount], [start_date], [end_date], [max_uses], [used_count], [is_active], [can_combine], [max_codes_per_order], [created_at], [updated_at]) VALUES (1, N'WELCOME10', N'Welcome discount 10% off', N'PERCENTAGE', CAST(10.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), NULL, CAST(N'2025-01-01T00:00:00.000' AS DateTime), CAST(N'2025-12-31T23:59:59.000' AS DateTime), 100, 0, 1, 1, 1, CAST(N'2025-01-07T11:55:01.090' AS DateTime), CAST(N'2025-01-07T11:55:01.090' AS DateTime))
INSERT [dbo].[discount_codes] ([id], [code], [description], [discount_type], [discount_value], [min_purchase_amount], [max_discount_amount], [start_date], [end_date], [max_uses], [used_count], [is_active], [can_combine], [max_codes_per_order], [created_at], [updated_at]) VALUES (2, N'SUMMER25', N'Summer sale 25% off', N'PERCENTAGE', CAST(25.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), NULL, CAST(N'2025-06-01T00:00:00.000' AS DateTime), CAST(N'2025-08-31T23:59:59.000' AS DateTime), 50, 0, 1, 0, 1, CAST(N'2025-01-07T11:55:01.090' AS DateTime), CAST(N'2025-01-07T11:55:01.090' AS DateTime))
INSERT [dbo].[discount_codes] ([id], [code], [description], [discount_type], [discount_value], [min_purchase_amount], [max_discount_amount], [start_date], [end_date], [max_uses], [used_count], [is_active], [can_combine], [max_codes_per_order], [created_at], [updated_at]) VALUES (3, N'FIXED20', N'Fixed $20 off', N'FIXED', CAST(20.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), NULL, CAST(N'2025-01-01T00:00:00.000' AS DateTime), CAST(N'2025-12-31T23:59:59.000' AS DateTime), 200, 0, 1, 1, 2, CAST(N'2025-01-07T11:55:01.090' AS DateTime), CAST(N'2025-01-07T11:55:01.090' AS DateTime))
INSERT [dbo].[discount_codes] ([id], [code], [description], [discount_type], [discount_value], [min_purchase_amount], [max_discount_amount], [start_date], [end_date], [max_uses], [used_count], [is_active], [can_combine], [max_codes_per_order], [created_at], [updated_at]) VALUES (4, N'COMBO15', N'Combinable 15% off', N'PERCENTAGE', CAST(15.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), NULL, CAST(N'2025-01-01T00:00:00.000' AS DateTime), CAST(N'2025-12-31T23:59:59.000' AS DateTime), -1, 0, 1, 1, 3, CAST(N'2025-01-07T11:55:01.090' AS DateTime), CAST(N'2025-01-07T11:55:01.090' AS DateTime))
INSERT [dbo].[discount_codes] ([id], [code], [description], [discount_type], [discount_value], [min_purchase_amount], [max_discount_amount], [start_date], [end_date], [max_uses], [used_count], [is_active], [can_combine], [max_codes_per_order], [created_at], [updated_at]) VALUES (5, N'VN', N'sg', N'PERCENTAGE', CAST(15.00 AS Decimal(10, 2)), CAST(11.00 AS Decimal(10, 2)), CAST(112.00 AS Decimal(10, 2)), CAST(N'2025-01-07T11:55:00.000' AS DateTime), CAST(N'2025-01-09T11:55:00.000' AS DateTime), 22, 0, 1, 0, 1, CAST(N'2025-01-07T11:55:55.830' AS DateTime), CAST(N'2025-01-07T11:55:55.830' AS DateTime))
INSERT [dbo].[discount_codes] ([id], [code], [description], [discount_type], [discount_value], [min_purchase_amount], [max_discount_amount], [start_date], [end_date], [max_uses], [used_count], [is_active], [can_combine], [max_codes_per_order], [created_at], [updated_at]) VALUES (6, N'JJ', N'0', N'PERCENTAGE', CAST(70.00 AS Decimal(10, 2)), CAST(99.00 AS Decimal(10, 2)), CAST(999.00 AS Decimal(10, 2)), CAST(N'2025-01-08T01:53:00.000' AS DateTime), CAST(N'2025-01-24T01:53:00.000' AS DateTime), 99, 0, 1, 0, 1, CAST(N'2025-01-08T01:53:26.940' AS DateTime), CAST(N'2025-01-08T01:53:26.940' AS DateTime))
SET IDENTITY_INSERT [dbo].[discount_codes] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_discount_codes_code]    Script Date: 1/12/2025 6:43:31 PM ******/
ALTER TABLE [dbo].[discount_codes] ADD  CONSTRAINT [UQ_discount_codes_code] UNIQUE NONCLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_discount_codes_code]    Script Date: 1/12/2025 6:43:31 PM ******/
CREATE NONCLUSTERED INDEX [idx_discount_codes_code] ON [dbo].[discount_codes]
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[discount_codes] ADD  DEFAULT ('PERCENTAGE') FOR [discount_type]
GO
ALTER TABLE [dbo].[discount_codes] ADD  DEFAULT ((0.00)) FOR [min_purchase_amount]
GO
ALTER TABLE [dbo].[discount_codes] ADD  DEFAULT ((-1)) FOR [max_uses]
GO
ALTER TABLE [dbo].[discount_codes] ADD  DEFAULT ((0)) FOR [used_count]
GO
ALTER TABLE [dbo].[discount_codes] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[discount_codes] ADD  DEFAULT ((0)) FOR [can_combine]
GO
ALTER TABLE [dbo].[discount_codes] ADD  DEFAULT ((1)) FOR [max_codes_per_order]
GO
ALTER TABLE [dbo].[discount_codes] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[discount_codes] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[discount_codes]  WITH CHECK ADD  CONSTRAINT [CHK_current_uses] CHECK  (([used_count]>=(0)))
GO
ALTER TABLE [dbo].[discount_codes] CHECK CONSTRAINT [CHK_current_uses]
GO
ALTER TABLE [dbo].[discount_codes]  WITH CHECK ADD  CONSTRAINT [CHK_discount_dates] CHECK  (([end_date]>=[start_date]))
GO
ALTER TABLE [dbo].[discount_codes] CHECK CONSTRAINT [CHK_discount_dates]
GO
ALTER TABLE [dbo].[discount_codes]  WITH CHECK ADD  CONSTRAINT [CHK_discount_type] CHECK  (([discount_type]='FIXED' OR [discount_type]='PERCENTAGE'))
GO
ALTER TABLE [dbo].[discount_codes] CHECK CONSTRAINT [CHK_discount_type]
GO
ALTER TABLE [dbo].[discount_codes]  WITH CHECK ADD  CONSTRAINT [CHK_discount_value] CHECK  (([discount_type]='PERCENTAGE' AND [discount_value]>(0) AND [discount_value]<=(100) OR [discount_type]='FIXED' AND [discount_value]>(0)))
GO
ALTER TABLE [dbo].[discount_codes] CHECK CONSTRAINT [CHK_discount_value]
GO
ALTER TABLE [dbo].[discount_codes]  WITH CHECK ADD  CONSTRAINT [CHK_max_codes_per_order] CHECK  (([max_codes_per_order]>=(1)))
GO
ALTER TABLE [dbo].[discount_codes] CHECK CONSTRAINT [CHK_max_codes_per_order]
GO
ALTER TABLE [dbo].[discount_codes]  WITH CHECK ADD  CONSTRAINT [CHK_max_uses] CHECK  (([max_uses]>=(-1)))
GO
ALTER TABLE [dbo].[discount_codes] CHECK CONSTRAINT [CHK_max_uses]
GO
