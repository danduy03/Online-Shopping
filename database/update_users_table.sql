USE [ec]
GO
/****** Object:  Table [dbo].[users]    Script Date: 1/14/2025 1:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](50) NULL,
	[email] [nvarchar](100) NULL,
	[password] [nvarchar](255) NULL,
	[first_name] [nvarchar](50) NULL,
	[last_name] [nvarchar](50) NULL,
	[full_name] [nvarchar](100) NULL,
	[address] [nvarchar](255) NULL,
	[phone] [nvarchar](20) NULL,
	[is_admin] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[oauth_provider] [nvarchar](20) NULL,
	[profile_picture] [nvarchar](max) NULL,
	[oauth_id] [nvarchar](255) NULL,
	[last_login] [datetime] NULL,
	[role] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([id], [username], [email], [password], [first_name], [last_name], [full_name], [address], [phone], [is_admin], [created_at], [updated_at], [oauth_provider], [profile_picture], [oauth_id], [last_login], [role]) VALUES (1, N'testuser', N'test@example.com', N'password123', N'Test', N'User', N'Test User', N'123 Test St', N'123-456-7890', 0, CAST(N'2025-01-14T01:03:56.690' AS DateTime), CAST(N'2025-01-14T01:03:56.690' AS DateTime), N'Google', NULL, N'test_oauth_id', CAST(N'2025-01-14T01:03:56.690' AS DateTime), N'user')
INSERT [dbo].[users] ([id], [username], [email], [password], [first_name], [last_name], [full_name], [address], [phone], [is_admin], [created_at], [updated_at], [oauth_provider], [profile_picture], [oauth_id], [last_login], [role]) VALUES (2, N'adminuser', N'admin@example.com', N'adminpassword', N'Admin', N'User', N'Admin User', N'123 Admin St', N'123-456-7890', 1, CAST(N'2025-01-14T01:07:50.050' AS DateTime), CAST(N'2025-01-14T01:07:50.050' AS DateTime), NULL, NULL, NULL, CAST(N'2025-01-14T01:07:50.050' AS DateTime), N'admin')
INSERT [dbo].[users] ([id], [username], [email], [password], [first_name], [last_name], [full_name], [address], [phone], [is_admin], [created_at], [updated_at], [oauth_provider], [profile_picture], [oauth_id], [last_login], [role]) VALUES (3, N'user1', N'user1@example.com', N'user1password', N'First', N'User', N'First User', N'456 User Rd', N'234-567-8901', 0, CAST(N'2025-01-14T01:07:50.050' AS DateTime), CAST(N'2025-01-14T01:07:50.050' AS DateTime), NULL, NULL, NULL, CAST(N'2025-01-14T01:07:50.050' AS DateTime), N'user')
INSERT [dbo].[users] ([id], [username], [email], [password], [first_name], [last_name], [full_name], [address], [phone], [is_admin], [created_at], [updated_at], [oauth_provider], [profile_picture], [oauth_id], [last_login], [role]) VALUES (4, N'user2', N'user2@example.com', N'user2password', N'Second', N'User', N'Second User', N'789 User Ave', N'345-678-9012', 0, CAST(N'2025-01-14T01:07:50.050' AS DateTime), CAST(N'2025-01-14T01:07:50.050' AS DateTime), NULL, NULL, NULL, CAST(N'2025-01-14T01:07:50.050' AS DateTime), N'user')
INSERT [dbo].[users] ([id], [username], [email], [password], [first_name], [last_name], [full_name], [address], [phone], [is_admin], [created_at], [updated_at], [oauth_provider], [profile_picture], [oauth_id], [last_login], [role]) VALUES (5, N'luongdanduy90tc', N'luongdanduy90tc@gmail.com', NULL, N'Ä�an Duy', N'LÆ°á»�ng', N'Ä�an DuyLÆ°á»�ng', NULL, NULL, 0, CAST(N'2025-01-14T01:09:56.380' AS DateTime), CAST(N'2025-01-14T01:09:56.380' AS DateTime), N'google', N'https://lh3.googleusercontent.com/a/ACg8ocJ5knvHeW8lLZPcESh-D8K2zuK8UtsDKvViW8mzZhSDmcfcyw=s96-c', N'112425552382469241418', CAST(N'2025-01-14T01:09:56.380' AS DateTime), N'USER')
SET IDENTITY_INSERT [dbo].[users] OFF
GO

-- Update existing roles to lowercase
UPDATE [dbo].[users] SET [role] = LOWER([role]) WHERE [role] IS NOT NULL;

-- Add default constraint for role column
ALTER TABLE [dbo].[users] ADD CONSTRAINT [DF_users_role] DEFAULT 'user' FOR [role];
GO
