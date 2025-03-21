USE [ec]
GO
/****** Object:  Table [dbo].[users]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[first_name] [nvarchar](50) NULL,
	[last_name] [nvarchar](50) NULL,
	[full_name]  AS (case when [first_name] IS NULL AND [last_name] IS NULL then NULL when [first_name] IS NULL then [last_name] when [last_name] IS NULL then [first_name] else ([first_name]+' ')+[last_name] end) PERSISTED,
	[address] [nvarchar](255) NULL,
	[phone] [nvarchar](20) NULL,
	[is_admin] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([id], [username], [email], [password], [first_name], [last_name], [address], [phone], [is_admin], [created_at], [updated_at]) VALUES (1, N'admin', N'admin@example.com', N'admin123', N'Admin', N'User', N'123 Admin St', N'123-456-7890', 1, CAST(N'2025-01-06T11:39:52.547' AS DateTime), CAST(N'2025-01-06T11:39:52.547' AS DateTime))
INSERT [dbo].[users] ([id], [username], [email], [password], [first_name], [last_name], [address], [phone], [is_admin], [created_at], [updated_at]) VALUES (2, N'john', N'john@example.com', N'john123', N'John', N'Doe', N'456 User St', N'234-567-8901', 0, CAST(N'2025-01-06T11:39:52.553' AS DateTime), CAST(N'2025-01-06T11:39:52.553' AS DateTime))
INSERT [dbo].[users] ([id], [username], [email], [password], [first_name], [last_name], [address], [phone], [is_admin], [created_at], [updated_at]) VALUES (3, N'jane', N'jane@example.com', N'jane123', N'Jane', N'Smith', N'789 Customer Ave', N'345-678-9012', 0, CAST(N'2025-01-06T11:39:52.553' AS DateTime), CAST(N'2025-01-06T11:39:52.553' AS DateTime))
INSERT [dbo].[users] ([id], [username], [email], [password], [first_name], [last_name], [address], [phone], [is_admin], [created_at], [updated_at]) VALUES (4, N'danduy03', N'danduy474@gmail.com', N'admin123', NULL, NULL, NULL, NULL, 0, CAST(N'2025-01-06T22:02:33.237' AS DateTime), CAST(N'2025-01-06T22:02:33.237' AS DateTime))
INSERT [dbo].[users] ([id], [username], [email], [password], [first_name], [last_name], [address], [phone], [is_admin], [created_at], [updated_at]) VALUES (5, N'acc1', N'acc1@mail.com', N'fnC/9OdBeLd65TzuI+M/HSuCCvpApuakdc0gmbFcPrICD7rS8GbQKUP9WETlRIwI', NULL, NULL, NULL, NULL, 0, CAST(N'2025-01-12T15:49:43.230' AS DateTime), CAST(N'2025-01-12T15:49:43.230' AS DateTime))
INSERT [dbo].[users] ([id], [username], [email], [password], [first_name], [last_name], [address], [phone], [is_admin], [created_at], [updated_at]) VALUES (6, N'acc2', N'acc2@gmail.com', N'FulaGO90F9DByaZHmTfvJqPsXYkeuAiT2ycOu59j6qE/pJRcGVTcT9v7eNw6MR/i', NULL, NULL, NULL, NULL, 0, CAST(N'2025-01-12T15:51:52.480' AS DateTime), CAST(N'2025-01-12T15:51:52.480' AS DateTime))
SET IDENTITY_INSERT [dbo].[users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_users_email]    Script Date: 1/12/2025 6:43:31 PM ******/
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [UQ_users_email] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_users_username]    Script Date: 1/12/2025 6:43:31 PM ******/
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [UQ_users_username] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((0)) FOR [is_admin]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
