USE [ec]
GO
/****** Object:  Table [dbo].[audit_log]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[audit_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[table_name] [varchar](50) NOT NULL,
	[action] [varchar](10) NOT NULL,
	[record_id] [bigint] NOT NULL,
	[changed_by] [bigint] NULL,
	[changed_at] [datetime] NULL,
	[old_values] [nvarchar](max) NULL,
	[new_values] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[audit_log] ADD  DEFAULT (getdate()) FOR [changed_at]
GO
