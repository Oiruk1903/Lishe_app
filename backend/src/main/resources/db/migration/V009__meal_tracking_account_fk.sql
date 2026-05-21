-- Connect meal tracking tables to the mobile (email-based) user account.
-- Keeps the legacy app_user FK intact for backward compat; new code uses account_id.

ALTER TABLE meal_logs
    ADD COLUMN IF NOT EXISTS account_id UUID,
    ADD COLUMN IF NOT EXISTS notes_text TEXT;

ALTER TABLE meal_logs
    ADD CONSTRAINT IF NOT EXISTS fk_meal_logs_account
    FOREIGN KEY (account_id) REFERENCES users (user_id);

-- water_intake_logs.user_id is NOT NULL referencing app_user; relax + add account link
ALTER TABLE water_intake_logs
    ALTER COLUMN user_id DROP NOT NULL;

ALTER TABLE water_intake_logs
    ADD COLUMN IF NOT EXISTS account_id UUID;

ALTER TABLE water_intake_logs
    ADD CONSTRAINT IF NOT EXISTS fk_water_logs_account
    FOREIGN KEY (account_id) REFERENCES users (user_id);
