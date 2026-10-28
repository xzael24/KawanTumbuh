# KAWANTUMBUH API

Backend service untuk sistem skrining dini SLD (Specific Learning Disorder).

## Setup

```bash
# Install dependencies
npm install

# Copy env
cp .env.example .env

# Edit .env sesuaikan DATABASE_URL & JWT_SECRET

# Run dev
npm run start:dev
```

## Endpoints (tersedia)

- `GET /` — API info
- `GET /health` — Health check

## Stack

- NestJS 12
- TypeORM + PostgreSQL
- JWT auth (passport-jwt)
- Class validation

## Database

Butuh PostgreSQL running di `localhost:5432`. Atau pakai docker-compose (lihat `/infra`).

Migrasi & seed belum ada — synchronize auto-run di development.
