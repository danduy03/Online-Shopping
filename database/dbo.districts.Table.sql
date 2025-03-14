USE [ec]
GO
/****** Object:  Table [dbo].[districts]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[districts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[province_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[districts] ON 

INSERT [dbo].[districts] ([id], [name], [province_id]) VALUES (1, N'Huyện Đông Hưng', 1)
INSERT [dbo].[districts] ([id], [name], [province_id]) VALUES (2, N'Huyện Kiến Xương', 1)
INSERT [dbo].[districts] ([id], [name], [province_id]) VALUES (3, N'Quận Hoàn Kiếm', 2)
INSERT [dbo].[districts] ([id], [name], [province_id]) VALUES (4, N'Quận 1', 3)
SET IDENTITY_INSERT [dbo].[districts] OFF
GO
ALTER TABLE [dbo].[districts]  WITH CHECK ADD FOREIGN KEY([province_id])
REFERENCES [dbo].[provinces] ([id])
ON DELETE CASCADE
GO
