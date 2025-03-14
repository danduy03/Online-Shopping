USE [ec]
GO
/****** Object:  Table [dbo].[categories]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[categories](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](255) NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[parent_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[categories] ON 

INSERT [dbo].[categories] ([id], [name], [description], [created_at], [updated_at], [parent_id]) VALUES (1, N'Smartphones', N'Latest mobile phones and accessories', CAST(N'2025-01-06T11:39:52.557' AS DateTime), CAST(N'2025-01-06T11:39:52.557' AS DateTime), NULL)
INSERT [dbo].[categories] ([id], [name], [description], [created_at], [updated_at], [parent_id]) VALUES (2, N'Laptops', N'Notebooks and laptops', CAST(N'2025-01-06T11:39:52.557' AS DateTime), CAST(N'2025-01-06T11:39:52.557' AS DateTime), NULL)
INSERT [dbo].[categories] ([id], [name], [description], [created_at], [updated_at], [parent_id]) VALUES (3, N'TVs', N'Television sets and entertainment systems', CAST(N'2025-01-06T11:39:52.557' AS DateTime), CAST(N'2025-01-06T11:39:52.557' AS DateTime), NULL)
INSERT [dbo].[categories] ([id], [name], [description], [created_at], [updated_at], [parent_id]) VALUES (4, N'Audio', N'Headphones, speakers, and audio equipment', CAST(N'2025-01-06T11:39:52.557' AS DateTime), CAST(N'2025-01-06T11:39:52.557' AS DateTime), NULL)
INSERT [dbo].[categories] ([id], [name], [description], [created_at], [updated_at], [parent_id]) VALUES (5, N'Gaming', N'Gaming consoles and accessories', CAST(N'2025-01-06T11:39:52.557' AS DateTime), CAST(N'2025-01-06T11:39:52.557' AS DateTime), NULL)
INSERT [dbo].[categories] ([id], [name], [description], [created_at], [updated_at], [parent_id]) VALUES (11, N'vv', N'i', CAST(N'2025-01-11T17:30:09.003' AS DateTime), CAST(N'2025-01-11T17:30:09.003' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[categories] OFF
GO
/****** Object:  Index [IX_categories_parent_id]    Script Date: 1/12/2025 6:43:31 PM ******/
CREATE NONCLUSTERED INDEX [IX_categories_parent_id] ON [dbo].[categories]
(
	[parent_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[categories] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[categories] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[categories]  WITH CHECK ADD  CONSTRAINT [FK_categories_parent] FOREIGN KEY([parent_id])
REFERENCES [dbo].[categories] ([id])
GO
ALTER TABLE [dbo].[categories] CHECK CONSTRAINT [FK_categories_parent]
GO
