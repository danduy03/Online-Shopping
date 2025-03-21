USE [ec]
GO
/****** Object:  Table [dbo].[articles]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[articles](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[content] [nvarchar](max) NOT NULL,
	[thumbnail] [nvarchar](255) NULL,
	[summary] [nvarchar](500) NULL,
	[author] [nvarchar](100) NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[status] [varchar](20) NULL,
	[slug] [varchar](255) NULL,
	[view_count] [int] NULL,
	[author_id] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__articles__32DD1E4C0DB66648]    Script Date: 1/12/2025 6:43:31 PM ******/
ALTER TABLE [dbo].[articles] ADD UNIQUE NONCLUSTERED 
(
	[slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_articles_created_at]    Script Date: 1/12/2025 6:43:31 PM ******/
CREATE NONCLUSTERED INDEX [idx_articles_created_at] ON [dbo].[articles]
(
	[created_at] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_articles_slug]    Script Date: 1/12/2025 6:43:31 PM ******/
CREATE NONCLUSTERED INDEX [idx_articles_slug] ON [dbo].[articles]
(
	[slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_articles_status]    Script Date: 1/12/2025 6:43:31 PM ******/
CREATE NONCLUSTERED INDEX [idx_articles_status] ON [dbo].[articles]
(
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_articles_author_id]    Script Date: 1/12/2025 6:43:31 PM ******/
CREATE NONCLUSTERED INDEX [IX_articles_author_id] ON [dbo].[articles]
(
	[author_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[articles] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[articles] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[articles] ADD  DEFAULT ('draft') FOR [status]
GO
ALTER TABLE [dbo].[articles] ADD  DEFAULT ((0)) FOR [view_count]
GO
ALTER TABLE [dbo].[articles]  WITH CHECK ADD  CONSTRAINT [FK_articles_author] FOREIGN KEY([author_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[articles] CHECK CONSTRAINT [FK_articles_author]
GO
