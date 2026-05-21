-- Vector extension removed
CREATE INDEX IF NOT EXISTS food_embeddings_embedding_idx
    ON food_embeddings (embedding);