-- Allow camera_analyses to reference UserAccount (email-based Flutter users)
-- user_id becomes nullable so email-only users without an AppUser row are supported.
ALTER TABLE camera_analyses ALTER COLUMN user_id DROP NOT NULL;

ALTER TABLE camera_analyses
    ADD COLUMN IF NOT EXISTS account_id UUID,
    ADD CONSTRAINT fk_camera_analyses_account
        FOREIGN KEY (account_id) REFERENCES users(user_id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_camera_analyses_account ON camera_analyses (account_id, created_at DESC);
