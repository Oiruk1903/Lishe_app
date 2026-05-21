CREATE TABLE IF NOT EXISTS meal_logs (
    log_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    food_id UUID NOT NULL,
    meal_type VARCHAR(20) NOT NULL,
    quantity_g REAL,
    logged_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP,
    CONSTRAINT fk_meal_logs_user
        FOREIGN KEY (user_id) REFERENCES app_user (id),
    CONSTRAINT fk_meal_logs_food
        FOREIGN KEY (food_id) REFERENCES foods (food_id)
);

CREATE TABLE IF NOT EXISTS water_intake_logs (
    intake_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    amount_ml INTEGER NOT NULL,
    logged_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP,
    CONSTRAINT fk_water_intake_logs_user
        FOREIGN KEY (user_id) REFERENCES app_user (id)
);

CREATE TABLE IF NOT EXISTS bmi_records (
    record_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    height_cm REAL NOT NULL,
    weight_kg REAL NOT NULL,
    bmi_value REAL NOT NULL,
    bmi_category VARCHAR(100),
    recorded_at TIMESTAMP,
    CONSTRAINT fk_bmi_records_user
        FOREIGN KEY (user_id) REFERENCES app_user (id)
);

ALTER TABLE user_health_profiles
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP,
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;

ALTER TABLE meal_plans
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;

ALTER TABLE chat_logs
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;

ALTER TABLE nutrition_alerts
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;

ALTER TABLE progress
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP,
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;