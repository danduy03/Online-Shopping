USE [ec]
GO

-- Update existing roles to be capitalized
UPDATE users 
SET role = UPPER(LEFT(role, 1)) + LOWER(SUBSTRING(role, 2, LEN(role)))
WHERE role IS NOT NULL;

-- Update specific values to ensure consistency
UPDATE users SET role = 'User' WHERE role = 'user';
UPDATE users SET role = 'Admin' WHERE role = 'admin';
GO
