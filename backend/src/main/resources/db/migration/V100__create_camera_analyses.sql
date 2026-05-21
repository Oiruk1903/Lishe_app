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
