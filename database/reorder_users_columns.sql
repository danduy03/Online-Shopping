-- First, create a backup of the existing data
SELECT * INTO users_backup FROM users;

-- Drop the existing table
DROP TABLE users;

-- Create the table with the same structure but reordered columns
CREATE TABLE users (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50),
    email NVARCHAR(100),
    password NVARCHAR(255),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    full_name NVARCHAR(100),
    address NVARCHAR(255),
    phone NVARCHAR(20),
    is_admin BIT,
    created_at DATETIME,
    updated_at DATETIME,
    oauth_provider NVARCHAR(20),
    profile_picture NVARCHAR(MAX),
    oauth_id NVARCHAR(255),
    last_login DATETIME,
    role NVARCHAR(20)
);

-- Restore the data with the same column order
INSERT INTO users (
    id,
    username,
    email,
    password,
    first_name,
    last_name,
    full_name,
    address,
    phone,
    is_admin,
    created_at,
    updated_at,
    oauth_provider,
    profile_picture,
    oauth_id,
    last_login,
    role
)
SELECT 
    id,
    username,
    email,
    password,
    first_name,
    last_name,
    full_name,
    address,
    phone,
    is_admin,
    created_at,
    updated_at,
    oauth_provider,
    profile_picture,
    oauth_id,
    last_login,
    role
FROM users_backup;

-- Drop the backup table
DROP TABLE users_backup;

-- Set the identity seed to continue from the last used id
DBCC CHECKIDENT ('users', RESEED, (SELECT MAX(id) FROM users));
