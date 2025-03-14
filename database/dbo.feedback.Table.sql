USE [ec]
GO
/****** Object:  Table [dbo].[feedback]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[feedback](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[user_name] [nvarchar](255) NULL,
	[subject] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NOT NULL,
	[type] [nvarchar](50) NOT NULL,
	[status] [nvarchar](50) NOT NULL,
	[priority] [nvarchar](50) NOT NULL,
	[attachment_path] [nvarchar](255) NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[feedback] ON 

INSERT [dbo].[feedback] ([id], [user_id], [user_name], [subject], [description], [type], [status], [priority], [attachment_path], [created_at], [updated_at]) VALUES (1, 4, N'danduy03', N'HIdsfsa', N'fasdfsfafaf', N'Bug Report', N'RESOLVED', N'Low', N'uploads/feedback/Screenshot (1).png', CAST(N'2025-01-12T00:33:45.147' AS DateTime), CAST(N'2025-01-12T01:24:01.890' AS DateTime))
INSERT [dbo].[feedback] ([id], [user_id], [user_name], [subject], [description], [type], [status], [priority], [attachment_path], [created_at], [updated_at]) VALUES (2, 4, N'danduy03', N'TÔI CẦN ĐƯỢC GIÚP ĐỠ', N'KÍNH CHÀO ĐỘI NGŨ NHÀ PHÁT TRIỂN. GẦN ĐÂY TÔI CÓ PHÁT HIỆN WEBSITE CỦA CÁC BẠN CÓ LỖ HỔNG. HÃY TRẢ LỜI TIN NHẮN CỦA TÔI ĐỂ BIẾT NHÉ !', N'Support Request', N'CLOSED', N'High', N'/uploads/feedback/Screenshot (6).png', CAST(N'2025-01-12T00:46:22.477' AS DateTime), CAST(N'2025-01-12T01:17:25.143' AS DateTime))
INSERT [dbo].[feedback] ([id], [user_id], [user_name], [subject], [description], [type], [status], [priority], [attachment_path], [created_at], [updated_at]) VALUES (3, 4, N'danduy03', N'BUG BOUTIN', N'HELLO IM HACKEER', N'Bug Report', N'RESOLVED', N'Low', N'/feedback/cfb3f703-c33e-4c1b-bf5e-8a9f31b7c2e4.png', CAST(N'2025-01-12T00:52:49.640' AS DateTime), CAST(N'2025-01-12T02:07:01.277' AS DateTime))
INSERT [dbo].[feedback] ([id], [user_id], [user_name], [subject], [description], [type], [status], [priority], [attachment_path], [created_at], [updated_at]) VALUES (4, 4, N'danduy03', N'fadsfsaf', N'gsdgsfsafsfd', N'General Feedback', N'IN_PROGRESS', N'Medium', NULL, CAST(N'2025-01-12T01:39:01.380' AS DateTime), CAST(N'2025-01-12T02:02:09.787' AS DateTime))
INSERT [dbo].[feedback] ([id], [user_id], [user_name], [subject], [description], [type], [status], [priority], [attachment_path], [created_at], [updated_at]) VALUES (5, 4, N'danduy03', N'jojonk', N'mlm;l,;;,''''', N'General Feedback', N'CLOSED', N'Medium', NULL, CAST(N'2025-01-12T01:42:52.467' AS DateTime), CAST(N'2025-01-12T02:09:40.420' AS DateTime))
INSERT [dbo].[feedback] ([id], [user_id], [user_name], [subject], [description], [type], [status], [priority], [attachment_path], [created_at], [updated_at]) VALUES (6, 4, N'danduy03', N'HIsdf', N'dfasdfsdadá', N'General Feedback', N'RESOLVED', N'Medium', NULL, CAST(N'2025-01-12T11:38:08.827' AS DateTime), CAST(N'2025-01-12T14:56:26.403' AS DateTime))
INSERT [dbo].[feedback] ([id], [user_id], [user_name], [subject], [description], [type], [status], [priority], [attachment_path], [created_at], [updated_at]) VALUES (7, 4, N'danduy03', N'TEST THỬ THÔI BẠN ƠI', N'TEST THỬ THÔI BẠN ƠI', N'Bug Report', N'IN_PROGRESS', N'Medium', NULL, CAST(N'2025-01-12T13:37:14.420' AS DateTime), CAST(N'2025-01-12T14:14:55.770' AS DateTime))
INSERT [dbo].[feedback] ([id], [user_id], [user_name], [subject], [description], [type], [status], [priority], [attachment_path], [created_at], [updated_at]) VALUES (8, 4, N'danduy03', N'BUG IN YOUR WEBSITE', N'PLEASE RESPONE FOR ME', N'Bug Report', N'CLOSED', N'Low', N'uploads/feedback/49d3580c-d05d-4f02-84d4-cc550be2ccef.png', CAST(N'2025-01-12T14:21:26.043' AS DateTime), CAST(N'2025-01-12T14:56:17.487' AS DateTime))
SET IDENTITY_INSERT [dbo].[feedback] OFF
GO
ALTER TABLE [dbo].[feedback] ADD  DEFAULT ('OPEN') FOR [status]
GO
ALTER TABLE [dbo].[feedback] ADD  DEFAULT ('Medium') FOR [priority]
GO
ALTER TABLE [dbo].[feedback] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[feedback] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[feedback]  WITH CHECK ADD  CONSTRAINT [CK_feedback_priority] CHECK  (([priority]='High' OR [priority]='Medium' OR [priority]='Low'))
GO
ALTER TABLE [dbo].[feedback] CHECK CONSTRAINT [CK_feedback_priority]
GO
ALTER TABLE [dbo].[feedback]  WITH CHECK ADD  CONSTRAINT [CK_feedback_status] CHECK  (([status]='CLOSED' OR [status]='RESOLVED' OR [status]='IN_PROGRESS' OR [status]='OPEN'))
GO
ALTER TABLE [dbo].[feedback] CHECK CONSTRAINT [CK_feedback_status]
GO
ALTER TABLE [dbo].[feedback]  WITH CHECK ADD  CONSTRAINT [CK_feedback_type] CHECK  (([type]='Support Request' OR [type]='General Feedback' OR [type]='Feature Request' OR [type]='Bug Report'))
GO
ALTER TABLE [dbo].[feedback] CHECK CONSTRAINT [CK_feedback_type]
GO
