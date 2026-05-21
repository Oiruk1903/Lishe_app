-- Link weight_logs to UserAccount (email users) and add optional note.
-- The legacy AppUser FK (user_id → app_user) is kept nullable for backward compat.

ALTER TABLE weight_logs
    ALTER COLUMN user_id DROP NOT NULL;

ALTER TABLE weight_logs
    ADD COLUMN IF NOT EXISTS account_id UUID,
    ADD COLUMN IF NOT EXISTS note      TEXT;

ALTER TABLE weight_logs
    ADD CONSTRAINT IF NOT EXISTS fk_weight_logs_account
    FOREIGN KEY (account_id) REFERENCES users (user_id);

CREATE INDEX IF NOT EXISTS idx_weight_logs_account_logged
    ON weight_logs (account_id, logged_at DESC);
