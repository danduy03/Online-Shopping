SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

USE ec;
GO

-- Drop existing constraints and indexes
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_oauth_provider_id' AND object_id = OBJECT_ID('users'))
    DROP INDEX idx_oauth_provider_id ON users;
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_email' AND object_id = OBJECT_ID('users'))
    DROP INDEX idx_email ON users;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'UQ_users_username' AND type = 'UQ')
    ALTER TABLE users DROP CONSTRAINT UQ_users_username;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'UQ_users_email' AND type = 'UQ')
    ALTER TABLE users DROP CONSTRAINT UQ_users_email;
GO

-- Drop computed column if it exists
IF EXISTS (SELECT * FROM sys.computed_columns WHERE object_id = OBJECT_ID('users') AND name = 'full_name')
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'ALTER TABLE users DROP COLUMN full_name';
    EXEC sp_executesql @sql;
END
GO

-- Drop foreign key constraints referencing users table
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql = @sql + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('users');
EXEC sp_executesql @sql;
GO

-- Alter existing columns to use NVARCHAR
ALTER TABLE users ALTER COLUMN username NVARCHAR(255) NOT NULL;
ALTER TABLE users ALTER COLUMN email NVARCHAR(255) NOT NULL;
ALTER TABLE users ALTER COLUMN password NVARCHAR(255) NULL;
ALTER TABLE users ALTER COLUMN first_name NVARCHAR(255) NULL;
ALTER TABLE users ALTER COLUMN last_name NVARCHAR(255) NULL;
ALTER TABLE users ALTER COLUMN address NVARCHAR(500) NULL;
ALTER TABLE users ALTER COLUMN phone NVARCHAR(20) NULL;
ALTER TABLE users ALTER COLUMN oauth_provider NVARCHAR(20) NULL;
ALTER TABLE users ALTER COLUMN oauth_id NVARCHAR(255) NULL;
ALTER TABLE users ALTER COLUMN profile_picture NVARCHAR(255) NULL;
ALTER TABLE users ALTER COLUMN role NVARCHAR(20) NULL;
GO

-- Recreate the computed column
ALTER TABLE users ADD full_name AS 
    CASE 
        WHEN first_name IS NULL AND last_name IS NULL THEN NULL
        WHEN first_name IS NULL THEN last_name
        WHEN last_name IS NULL THEN first_name
        ELSE first_name + ' ' + last_name 
    END PERSISTED;
GO

-- Recreate constraints and indexes
ALTER TABLE users ADD CONSTRAINT UQ_users_username UNIQUE (username);
ALTER TABLE users ADD CONSTRAINT UQ_users_email UNIQUE (email);
CREATE INDEX idx_oauth_provider_id ON users(oauth_provider, oauth_id);
CREATE INDEX idx_email ON users(email);
GO

-- Recreate foreign key constraints
-- Note: You'll need to add back any foreign key constraints that were dropped
-- Example:
-- ALTER TABLE orders ADD CONSTRAINT FK_orders_users FOREIGN KEY (user_id) REFERENCES users(id);
GO

-- Update roles based on is_admin flag
UPDATE users SET role = 'admin' WHERE is_admin = 1;
UPDATE users SET role = 'user' WHERE is_admin = 0 OR is_admin IS NULL;
GO
