USE [ec]
GO

-- Check if all required columns exist, add them if they don't
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('password_reset_tokens') AND name = 'used')
BEGIN
    ALTER TABLE password_reset_tokens ADD used bit NOT NULL DEFAULT 0
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('password_reset_tokens') AND name = 'expiry_time')
BEGIN
    ALTER TABLE password_reset_tokens ADD expiry_time datetime NOT NULL DEFAULT DATEADD(HOUR, 1, GETDATE())
END

-- Check existing tokens
SELECT * FROM password_reset_tokens WHERE token = '1elXUPESApCa0tit1TBPyr5o3geoC-DHx0YHsqwgib8'

-- Clear expired or used tokens
DELETE FROM password_reset_tokens 
WHERE expiry_time < GETDATE() OR used = 1

-- Check foreign key constraint
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE object_id = OBJECT_ID('FK_password_reset_tokens_users')
)
BEGIN
    ALTER TABLE password_reset_tokens
    ADD CONSTRAINT FK_password_reset_tokens_users
    FOREIGN KEY (user_id) REFERENCES users(id)
END
