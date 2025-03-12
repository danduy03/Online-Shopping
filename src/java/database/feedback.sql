-- Create feedback table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[feedback]') AND type in (N'U'))
BEGIN
    CREATE TABLE feedback (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        user_id BIGINT NOT NULL,
        subject NVARCHAR(255) NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        type NVARCHAR(50) NOT NULL,
        status NVARCHAR(50) NOT NULL DEFAULT 'OPEN',
        priority NVARCHAR(50) NOT NULL DEFAULT 'MEDIUM',
        attachment_path NVARCHAR(255),
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_feedback_user FOREIGN KEY (user_id) REFERENCES users(id)
    );
END
GO

-- Create feedback_responses table for admin responses
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[feedback_responses]') AND type in (N'U'))
BEGIN
    CREATE TABLE feedback_responses (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        feedback_id BIGINT NOT NULL,
        user_id BIGINT NOT NULL,
        message NVARCHAR(MAX) NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_feedback_responses_feedback FOREIGN KEY (feedback_id) REFERENCES feedback(id),
        CONSTRAINT FK_feedback_responses_user FOREIGN KEY (user_id) REFERENCES users(id)
    );
END
GO

-- Add indexes if they don't exist
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_feedback_user' AND object_id = OBJECT_ID('feedback'))
BEGIN
    CREATE INDEX idx_feedback_user ON feedback(user_id);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_feedback_status' AND object_id = OBJECT_ID('feedback'))
BEGIN
    CREATE INDEX idx_feedback_status ON feedback(status);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_feedback_created_at' AND object_id = OBJECT_ID('feedback'))
BEGIN
    CREATE INDEX idx_feedback_created_at ON feedback(created_at);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_feedback_responses_feedback' AND object_id = OBJECT_ID('feedback_responses'))
BEGIN
    CREATE INDEX idx_feedback_responses_feedback ON feedback_responses(feedback_id);
END
GO

-- Drop existing trigger if it exists
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TR_feedback_update')
    DROP TRIGGER TR_feedback_update
GO

-- Create trigger for updated_at
CREATE TRIGGER TR_feedback_update
ON feedback
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE feedback
    SET updated_at = GETDATE()
    FROM feedback f
    INNER JOIN inserted i ON f.id = i.id;
END
GO