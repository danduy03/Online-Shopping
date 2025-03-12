USE [ec]
GO

-- Update full_names to have proper spacing
UPDATE users 
SET full_name = CASE 
    WHEN first_name IS NOT NULL AND last_name IS NOT NULL 
    THEN RTRIM(first_name) + N' ' + LTRIM(last_name)
    WHEN first_name IS NOT NULL THEN first_name
    WHEN last_name IS NOT NULL THEN last_name
    ELSE full_name
END
WHERE first_name IS NOT NULL OR last_name IS NOT NULL;

GO
