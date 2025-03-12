USE [ec]
GO

CREATE TABLE [dbo].[password_reset_tokens](
    [id] [bigint] IDENTITY(1,1) NOT NULL,
    [user_id] [bigint] NOT NULL,
    [token] [nvarchar](255) NOT NULL,
    [expiry_time] [datetime] NOT NULL,
    [used] [bit] NOT NULL DEFAULT 0,
    [created_at] [datetime] NOT NULL DEFAULT GETDATE(),
PRIMARY KEY CLUSTERED 
(
    [id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
GO

ALTER TABLE [dbo].[password_reset_tokens]  WITH CHECK ADD  CONSTRAINT [FK_password_reset_tokens_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO

ALTER TABLE [dbo].[password_reset_tokens] CHECK CONSTRAINT [FK_password_reset_tokens_users]
GO

CREATE INDEX [IX_password_reset_tokens_token] ON [dbo].[password_reset_tokens]
(
    [token] ASC
)
GO
