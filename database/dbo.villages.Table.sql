USE [ec]
GO
/****** Object:  Table [dbo].[villages]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[villages](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[commune_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[villages] ON 

INSERT [dbo].[villages] ([id], [name], [commune_id]) VALUES (1, N'Thôn 1', 1)
INSERT [dbo].[villages] ([id], [name], [commune_id]) VALUES (2, N'Thôn 2', 1)
INSERT [dbo].[villages] ([id], [name], [commune_id]) VALUES (3, N'Thôn 1', 2)
INSERT [dbo].[villages] ([id], [name], [commune_id]) VALUES (4, N'Thôn 3', 2)
SET IDENTITY_INSERT [dbo].[villages] OFF
GO
ALTER TABLE [dbo].[villages]  WITH CHECK ADD FOREIGN KEY([commune_id])
REFERENCES [dbo].[communes] ([id])
ON DELETE CASCADE
GO
