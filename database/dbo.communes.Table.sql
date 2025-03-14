USE [ec]
GO
/****** Object:  Table [dbo].[communes]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[communes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[district_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[communes] ON 

INSERT [dbo].[communes] ([id], [name], [district_id]) VALUES (1, N'Xã Đông Hoàng', 1)
INSERT [dbo].[communes] ([id], [name], [district_id]) VALUES (2, N'Xã Đông Sơn', 1)
INSERT [dbo].[communes] ([id], [name], [district_id]) VALUES (3, N'Phường Hàng Trống', 3)
INSERT [dbo].[communes] ([id], [name], [district_id]) VALUES (4, N'Phường Bến Nghé', 4)
SET IDENTITY_INSERT [dbo].[communes] OFF
GO
ALTER TABLE [dbo].[communes]  WITH CHECK ADD FOREIGN KEY([district_id])
REFERENCES [dbo].[districts] ([id])
ON DELETE CASCADE
GO
