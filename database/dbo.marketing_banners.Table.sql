USE [ec]
GO
/****** Object:  Table [dbo].[marketing_banners]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[marketing_banners](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NULL,
	[image_url] [nvarchar](255) NOT NULL,
	[link_url] [nvarchar](255) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[position] [varchar](50) NOT NULL,
	[priority] [int] NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_marketing_banners_created_by]    Script Date: 1/12/2025 6:43:31 PM ******/
CREATE NONCLUSTERED INDEX [IX_marketing_banners_created_by] ON [dbo].[marketing_banners]
(
	[created_by] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[marketing_banners] ADD  DEFAULT ((0)) FOR [priority]
GO
ALTER TABLE [dbo].[marketing_banners] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[marketing_banners] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[marketing_banners] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[marketing_banners]  WITH CHECK ADD  CONSTRAINT [FK_marketing_banners_creator] FOREIGN KEY([created_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[marketing_banners] CHECK CONSTRAINT [FK_marketing_banners_creator]
GO
ALTER TABLE [dbo].[marketing_banners]  WITH CHECK ADD CHECK  (([position]='CHECKOUT_PAGE' OR [position]='PRODUCT_PAGE' OR [position]='SIDEBAR_BOTTOM' OR [position]='SIDEBAR_TOP' OR [position]='CATEGORY_BOTTOM' OR [position]='CATEGORY_TOP' OR [position]='HOME_BOTTOM' OR [position]='HOME_MIDDLE' OR [position]='HOME_TOP' OR [position]='ABOVE_NAVBAR'))
GO
