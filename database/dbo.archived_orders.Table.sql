USE [ec]
GO
/****** Object:  Table [dbo].[archived_orders]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[archived_orders](
	[id] [bigint] NOT NULL,
	[user_id] [bigint] NOT NULL,
	[status] [varchar](20) NOT NULL,
	[total_amount] [decimal](10, 2) NOT NULL,
	[shipping_address] [nvarchar](255) NULL,
	[payment_method] [varchar](50) NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[archived_at] [datetime] NULL,
 CONSTRAINT [PK_archived_orders] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[archived_orders] ADD  DEFAULT (getdate()) FOR [archived_at]
GO
