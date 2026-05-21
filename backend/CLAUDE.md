# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Build
./mvnw clean install -DskipTests

# Run (requires PostgreSQL on localhost:5432)
./mvnw spring-boot:run

# Run tests
./mvnw test

# Run a single test class
./mvnw test -Dtest=ClassName

# Start dependencies only (Postgres + pgAdmin)
docker compose up db pgadmin -d

# Full stack via Docker
docker compose up --build
```

The app starts on port `8080`. Swagger UI is available at `http://localhost:8080/swagger-ui.html`.

## Architecture

Lishe is a Tanzanian nutrition platform (aligned with TFNC guidelines) with mobile-first user flows and AI-powered recommendations. It's a Spring Boot 3.5.4 / Java 21 monolith using PostgreSQL.

### Module layout

All code lives under `com.lishe` in feature-based packages. Each module follows:
`api/{controller,request,response}` → `service` → `domain` + `repository`

| Package | Responsibility |
|---|---|
| `administration` | User registration, OTP-device auth, profile management |
| `jwt` | `SecurityConfig`, `JwtFilter`, `JwtService` |
| `nutrition` | Meal logging, nutrient calculation, weight/BMI, water intake |
| `food` | Food catalog (`Food`, `MealPlan`), Tanzania region data |
| `recommendation` | AI meal plan generation, rule engine, daily scheduler |
| `rag` | pgvector food embeddings + semantic search for RAG context |
| `chat` | TFNC nutrition chatbot with conversation history |
| `camera` | Gemini Vision food image analysis |
| `analytics` | Progress tracking, water summaries, admin platform stats |
| `alert` | `NutritionAlert` — generated when AI detects nutrition risk |
| `report` | Admin PDF/Excel report export (iTextPDF + Apache POI) |
| `localization` | EN/SW (English/Swahili) message resolution |
| `config` | ClickSend SMS bean, OpenAPI config, health indicator |

### Two user identity models

There are two separate user tables and registration flows that coexist:

- **`AppUser`** (`app_user` table, `administration` package) — mobile-number based; used by the mobile app. Auth is OTP-via-SMS (ClickSend). JWT subject is the mobile number. Device registration is tracked with a max of 2 active devices per user.
- **`UserAccount`** (`users` table) — email-based; used by the `chat`, `recommendation` (flow), and `analytics` modules. This is a distinct account type (likely for specialist/web users).

Services in `chat` and `recommendation` resolve a `principal` string by trying email lookup first, then phone number (`resolveUser()` pattern).

### Authentication flow

1. `POST /api/v1/auth/create-account` — creates `AuthUser` + `AppUser` + initial `UserRecommendation`; returns JWT.
2. `POST /api/v1/auth/authenticate` — for known devices returns JWT directly; for new devices sends OTP via ClickSend and returns 403/CONFLICT.
3. OTP verification activates the device and issues a JWT.

Routes under `/api/v1/auth/**` and `/api/admin/**` are whitelisted or role-gated in `SecurityConfig`. Everything else requires a valid JWT.

### AI service abstraction

`AIService` is an interface with two implementations selected by `ai.provider`:

- `python` (default) — `PythonAdapterAIService` proxies to a Python backend at `AI_ENGINE_BASE_URL` (default: `http://localhost:8000`).
- `spring-ai-gemini` — `SpringAIGeminiService` uses Spring AI 1.0.1 with Google Vertex AI Gemini (`gemini-1.5-flash`). Requires `GOOGLE_CLOUD_PROJECT` and `GOOGLE_CLOUD_LOCATION`.

Both the chat and recommendation modules depend on `AIService` without caring which implementation is active.

### RAG pipeline

On `ApplicationReadyEvent`, `FoodEmbeddingJob` triggers async batch embedding of all `Food` records via `EmbeddingService`. Embeddings (Vertex AI) are stored in the `food_embeddings` table using pgvector (migration `V008__pgvector.sql`). `SemanticFoodSearchService` performs cosine-similarity queries to build context for AI prompts.

### Scheduled jobs

- `DailyRecommendationJob` — cron `0 0 6 * * ?` (06:00 daily) — regenerates recommendations for users active in the last 7 days.

### Universal response envelope

All controllers return `GenericRestResponse<T>` with fields `timestamp`, `statusCode`, `message`, `locale`, `data`. The `statusCode` field is a string (e.g. `"200"`, `"403"`) set by service code — it does not always match the HTTP status.

### Database

PostgreSQL 13+. Flyway migrations are in `src/main/resources/db/migration/` (V001–V008, V100). Schema DDL is managed exclusively through Flyway; `ddl-auto` is `update` in dev (should be `validate` in production).

Dev database: `lisheapp` on `localhost:5432`, user `postgres`, password `mdsoln`.

### Configuration profiles

- `application.yml` — activates `dev` profile by default; sets `ai.provider=python`.
- `application-dev.yml` — full dev datasource, Flyway config, Gemini settings, ClickSend credentials.
- `sit.yml` — SIT environment overrides.
- Key env vars: `AI_PROVIDER`, `AI_ENGINE_BASE_URL`, `GOOGLE_CLOUD_PROJECT`, `GOOGLE_CLOUD_LOCATION`, `GEMINI_MODEL`, `REPORT_EXPORT_DIR`.
