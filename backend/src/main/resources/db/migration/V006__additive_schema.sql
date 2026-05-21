-- Vector extension removed as it is not available on the system

CREATE TABLE IF NOT EXISTS serving_sizes (
    id UUID PRIMARY KEY,
    food_id UUID,
    label_en VARCHAR(255),
    label_sw VARCHAR(255),
    grams_equivalent REAL NOT NULL,
    measurement_type VARCHAR(50),
    created_at TIMESTAMP,
    CONSTRAINT fk_serving_sizes_food
        FOREIGN KEY (food_id) REFERENCES foods (food_id)
);

CREATE TABLE IF NOT EXISTS nutrition_guidelines (
    id UUID PRIMARY KEY,
    nutrient_code VARCHAR(50) NOT NULL,
    cohort VARCHAR(50) NOT NULL,
    min_daily REAL,
    max_daily REAL,
    unit VARCHAR(20),
    notes TEXT,
    created_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS meal_logs (
    id UUID PRIMARY KEY,
    user_id UUID,
    meal_type VARCHAR(20) NOT NULL,
    notes TEXT,
    logged_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP,
    CONSTRAINT fk_meal_logs_user
        FOREIGN KEY (user_id) REFERENCES app_user (id)
);

CREATE TABLE IF NOT EXISTS meal_log_items (
    id UUID PRIMARY KEY,
    meal_log_id UUID,
    food_id UUID,
    quantity_grams REAL NOT NULL,
    kcal_snapshot REAL,
    protein_snapshot REAL,
    carbs_snapshot REAL,
    fat_snapshot REAL,
    created_at TIMESTAMP,
    CONSTRAINT fk_meal_log_items_meal_log
        FOREIGN KEY (meal_log_id) REFERENCES meal_logs (id),
    CONSTRAINT fk_meal_log_items_food
        FOREIGN KEY (food_id) REFERENCES foods (food_id)
);

CREATE TABLE IF NOT EXISTS food_embeddings (
    id UUID PRIMARY KEY,
    food_id UUID UNIQUE,
    embedding TEXT,
    embedded_text TEXT,
    created_at TIMESTAMP,
    CONSTRAINT fk_food_embeddings_food
        FOREIGN KEY (food_id) REFERENCES foods (food_id)
);

CREATE TABLE IF NOT EXISTS weight_logs (
    id UUID PRIMARY KEY,
    user_id UUID,
    weight_kg REAL NOT NULL,
    height_cm REAL,
    bmi_value REAL,
    bmi_category VARCHAR(50),
    logged_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP,
    CONSTRAINT fk_weight_logs_user
        FOREIGN KEY (user_id) REFERENCES app_user (id)
);

CREATE TABLE IF NOT EXISTS daily_summaries (
    id UUID PRIMARY KEY,
    user_id UUID,
    summary_date DATE NOT NULL,
    kcal_consumed REAL,
    protein_consumed REAL,
    carbs_consumed REAL,
    fat_consumed REAL,
    iron_consumed REAL,
    calcium_consumed REAL,
    kcal_target REAL,
    adherence_score REAL,
    created_at TIMESTAMP,
    CONSTRAINT fk_daily_summaries_user
        FOREIGN KEY (user_id) REFERENCES app_user (id),
    CONSTRAINT uq_daily_summaries_user_date UNIQUE (user_id, summary_date)
);

CREATE TABLE IF NOT EXISTS user_recommendations (
    id UUID PRIMARY KEY,
    user_id UUID,
    recommendation_date DATE NOT NULL,
    recommendations JSONB,
    feedback VARCHAR(255),
    generated_at TIMESTAMP,
    created_at TIMESTAMP,
    CONSTRAINT fk_user_recommendations_user
        FOREIGN KEY (user_id) REFERENCES app_user (id)
);

CREATE TABLE IF NOT EXISTS camera_analyses (
    id UUID PRIMARY KEY,
    user_id UUID,
    image_hash VARCHAR(255),
    identified_foods JSONB,
    matched_foods JSONB,
    nutrient_summary JSONB,
    created_at TIMESTAMP,
    CONSTRAINT fk_camera_analyses_user
        FOREIGN KEY (user_id) REFERENCES app_user (id)
);