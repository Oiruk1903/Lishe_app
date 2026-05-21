CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50),
    password_hash VARCHAR(255) NOT NULL,
    reset_token VARCHAR(255),
    role VARCHAR(20) NOT NULL,
    location VARCHAR(255),
    region_id UUID,
    created_at TIMESTAMP,
    last_login TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS uk_users_email ON users (email);

CREATE TABLE IF NOT EXISTS tz_regions (
    region_id UUID PRIMARY KEY,
    region_name VARCHAR(255) NOT NULL,
    zone VARCHAR(100),
    climate_type VARCHAR(100)
);

ALTER TABLE users
    ADD CONSTRAINT IF NOT EXISTS fk_users_region
    FOREIGN KEY (region_id) REFERENCES tz_regions (region_id);

CREATE TABLE IF NOT EXISTS user_health_profiles (
    profile_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(50),
    health_condition VARCHAR(255),
    pregnancy_status VARCHAR(50),
    nutrition_group VARCHAR(100),
    data_encrypted BOOLEAN,
    updated_at TIMESTAMP,
    CONSTRAINT fk_user_health_profiles_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE IF NOT EXISTS foods (
    food_id UUID PRIMARY KEY,
    food_name_en VARCHAR(255) NOT NULL,
    food_name_sw VARCHAR(255),
    food_group VARCHAR(100),
    calories_per_100g REAL,
    protein_g REAL,
    carbs_g REAL,
    fat_g REAL,
    fibre_g REAL,
    iron_mg REAL,
    calcium_mg REAL,
    vitamin_a_mcg REAL,
    preparation_notes VARCHAR(1000)
);

CREATE TABLE IF NOT EXISTS food_region_availability (
    availability_id UUID PRIMARY KEY,
    food_id UUID NOT NULL,
    region_id UUID NOT NULL,
    season VARCHAR(100),
    availability_level VARCHAR(100),
    is_staple BOOLEAN,
    local_name VARCHAR(255),
    CONSTRAINT fk_food_region_availability_food
        FOREIGN KEY (food_id) REFERENCES foods (food_id),
    CONSTRAINT fk_food_region_availability_region
        FOREIGN KEY (region_id) REFERENCES tz_regions (region_id)
);

CREATE TABLE IF NOT EXISTS nutrition_categories (
    category_id UUID PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    description VARCHAR(1000)
);

CREATE TABLE IF NOT EXISTS nutrition_content (
    content_id UUID PRIMARY KEY,
    category_id UUID NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT,
    region VARCHAR(100),
    created_by VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT fk_nutrition_content_category
        FOREIGN KEY (category_id) REFERENCES nutrition_categories (category_id)
);

CREATE TABLE IF NOT EXISTS meal_plans (
    plan_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    plan_title VARCHAR(255),
    meal_details TEXT,
    dietary_suggestions TEXT,
    generated_at TIMESTAMP,
    CONSTRAINT fk_meal_plans_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE IF NOT EXISTS meal_plan_foods (
    meal_plan_food_id UUID PRIMARY KEY,
    plan_id UUID NOT NULL,
    food_id UUID NOT NULL,
    meal_type VARCHAR(20) NOT NULL,
    serving_size_g REAL,
    notes VARCHAR(1000),
    CONSTRAINT fk_meal_plan_foods_plan
        FOREIGN KEY (plan_id) REFERENCES meal_plans (plan_id),
    CONSTRAINT fk_meal_plan_foods_food
        FOREIGN KEY (food_id) REFERENCES foods (food_id)
);

CREATE TABLE IF NOT EXISTS chat_logs (
    log_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    user_message TEXT,
    ai_response TEXT,
    referral_flagged BOOLEAN,
    created_at TIMESTAMP,
    CONSTRAINT fk_chat_logs_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE IF NOT EXISTS nutrition_alerts (
    alert_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    alert_type VARCHAR(100),
    message VARCHAR(1000),
    is_read BOOLEAN,
    sent_at TIMESTAMP,
    CONSTRAINT fk_nutrition_alerts_user
        FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE IF NOT EXISTS reports (
    report_id UUID PRIMARY KEY,
    generated_by UUID NOT NULL,
    report_type VARCHAR(100),
    summary TEXT,
    is_anonymised BOOLEAN,
    generated_at TIMESTAMP,
    CONSTRAINT fk_reports_generated_by
        FOREIGN KEY (generated_by) REFERENCES users (user_id)
);

CREATE TABLE IF NOT EXISTS report_exports (
    export_id UUID PRIMARY KEY,
    report_id UUID NOT NULL,
    format VARCHAR(20) NOT NULL,
    file_path VARCHAR(512),
    exported_at TIMESTAMP,
    CONSTRAINT fk_report_exports_report
        FOREIGN KEY (report_id) REFERENCES reports (report_id)
);

CREATE INDEX IF NOT EXISTS idx_user_health_profiles_user ON user_health_profiles (user_id);
CREATE INDEX IF NOT EXISTS idx_meal_plans_user ON meal_plans (user_id);
CREATE INDEX IF NOT EXISTS idx_chat_logs_user ON chat_logs (user_id);
CREATE INDEX IF NOT EXISTS idx_nutrition_alerts_user ON nutrition_alerts (user_id);
CREATE INDEX IF NOT EXISTS idx_food_region_availability_region ON food_region_availability (region_id);
