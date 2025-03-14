USE [ec]
GO
/****** Object:  Table [dbo].[product_categories]    Script Date: 1/12/2025 6:43:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product_categories](
	[product_id] [bigint] NOT NULL,
	[category_id] [bigint] NOT NULL,
	[created_at] [datetime] NULL,
 CONSTRAINT [PK_product_categories] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC,
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[product_categories] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[product_categories]  WITH CHECK ADD  CONSTRAINT [FK_product_categories_category] FOREIGN KEY([category_id])
REFERENCES [dbo].[categories] ([id])
GO
ALTER TABLE [dbo].[product_categories] CHECK CONSTRAINT [FK_product_categories_category]
GO
ALTER TABLE [dbo].[product_categories]  WITH CHECK ADD  CONSTRAINT [FK_product_categories_product] FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
GO
ALTER TABLE [dbo].[product_categories] CHECK CONSTRAINT [FK_product_categories_product]
GO
