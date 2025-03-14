USE [ec]
GO
/****** Object:  Table [dbo].[feedback_responses]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[feedback_responses](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[feedback_id] [bigint] NOT NULL,
	[user_id] [bigint] NOT NULL,
	[message] [nvarchar](max) NOT NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[feedback_responses] ON 

INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (1, 3, 1, N'Oke bạn nhé.', CAST(N'2025-01-12T01:13:00.160' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (2, 2, 1, N'ok', CAST(N'2025-01-12T01:15:34.553' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (3, 2, 1, N'l', CAST(N'2025-01-12T01:15:50.853' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (4, 1, 1, N'lol', CAST(N'2025-01-12T01:17:02.570' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (5, 1, 1, N'rồi nhé', CAST(N'2025-01-12T01:23:50.677' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (6, 5, 1, N'ê', CAST(N'2025-01-12T02:01:54.137' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (7, 4, 1, N'ccc', CAST(N'2025-01-12T02:02:09.773' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (8, 5, 1, N'âs', CAST(N'2025-01-12T02:06:53.247' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (9, 5, 1, N'vsd', CAST(N'2025-01-12T02:09:28.890' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (10, 6, 1, N'ok', CAST(N'2025-01-12T11:41:28.467' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (11, 6, 1, N'cc', CAST(N'2025-01-12T13:04:26.540' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (12, 7, 1, N'test cai lo', CAST(N'2025-01-12T13:54:52.700' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (13, 7, 1, N'fsgsdgs', CAST(N'2025-01-12T14:08:39.467' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (14, 7, 1, N'con mej afy ksndmfknasdjnkasmfdslf', CAST(N'2025-01-12T14:08:52.817' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (15, 7, 1, N'Test casi lo', CAST(N'2025-01-12T14:11:50.960' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (16, 7, 1, N'dafasdf', CAST(N'2025-01-12T14:14:55.740' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (17, 8, 1, N'de', CAST(N'2025-01-12T14:22:31.413' AS DateTime))
INSERT [dbo].[feedback_responses] ([id], [feedback_id], [user_id], [message], [created_at]) VALUES (18, 8, 1, N'ihihij', CAST(N'2025-01-12T14:56:10.280' AS DateTime))
SET IDENTITY_INSERT [dbo].[feedback_responses] OFF
GO
ALTER TABLE [dbo].[feedback_responses] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[feedback_responses]  WITH CHECK ADD FOREIGN KEY([feedback_id])
REFERENCES [dbo].[feedback] ([id])
GO
