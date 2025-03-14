USE [ec]
GO
/****** Object:  Table [dbo].[provinces]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provinces](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[provinces] ON 

INSERT [dbo].[provinces] ([id], [name]) VALUES (1, N'Thái Bình')
INSERT [dbo].[provinces] ([id], [name]) VALUES (2, N'Hà Nội')
INSERT [dbo].[provinces] ([id], [name]) VALUES (3, N'Hồ Chí Minh')
SET IDENTITY_INSERT [dbo].[provinces] OFF
GO
