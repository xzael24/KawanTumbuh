# Infra - Docker Compose KAWANTUMBUH

Konfigurasi deployment untuk VPS Ubuntu. Semua komponen jalan di Docker,
hanya NGINX yang membuka port ke internet.

```
internet
   │  80/443
   ▼
nginx (edge network)
   │  /api/v1/*  ──────────────► api :3000 (NestJS)
   │                                  │
   │                                  ├─ backend network ─► db :5432 (PostgreSQL)
   │                                  ├─ backend network ─► ai-dysgraphia :8002
   │                                  ├─ backend network ─► ai-dyslexia :8003
   │                                  └─ backend network ─► ai-dyscalculia :8004
   └─ /healthz ─────────────────────► api :3000 /health
```

## Isi folder

| File | Fungsi |
|---|---|
| `docker-compose.yml` | Definisi service, network, volume, healthcheck |
| `.env.example` | Template environment, copy jadi `.env` |
| `nginx/conf.d/default.conf` | Route `/api/v1/*`, rate limit, upload limit |
| `nginx/proxy_params.conf` | Header proxy standar |
| `nginx/certs/` | Tempat `fullchain.pem` + `privkey.pem` untuk HTTPS |
| `postgres/init.sql` | Extension PostgreSQL saat volume pertama kali dibuat |

## Prasyarat

- Docker Engine 24+ dan Docker Compose v2 (`docker compose version`)
- RAM minimal 2 GB (disarankan 4 GB karena image Python + scikit-learn)
- Port 80 dan 443 bebas

## Menjalankan

```bash
cd infra
cp .env.example .env
# edit .env: ganti POSTGRES_PASSWORD, DATABASE_URL, dan JWT_SECRET
docker compose up -d --build
```

Cek status dan log:

```bash
docker compose ps
docker compose logs -f api
docker compose logs -f nginx
```

Uji dari host:

```bash
curl http://localhost/nginx-health
curl http://localhost/healthz
curl http://localhost/api/v1/
```

Contoh request auth (setelah route auth tersedia di mobile):

```bash
curl -X POST http://localhost/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"identifier":"user@example.com","password":"rahasia"}'
```

## Peta port

| Service | Port internal | Port host |
|---|---|---|
| nginx | 80, 443 | 80, 443 |
| api | 3000 | - (lewat nginx) |
| db | 5432 | - |
| ai-dysgraphia | 8002 | - |
| ai-dyslexia | 8003 | - |
| ai-dyscalculia | 8004 | - |
| ai-sentiment (opsional) | 8005 | - |
| minio (opsional) | 9000, 9001 | 127.0.0.1:9000, 127.0.0.1:9001 |
| redis (opsional) | 6379 | - |

## Profile opsional

Service opsional tidak ikut `docker compose up` biasa.

```bash
# Sentiment analysis (butuh model hasil save_model.py)
docker compose --profile ai-sentiment up -d --build

# Object storage MinIO
docker compose --profile storage up -d

# Redis / BullMQ untuk inference async
docker compose --profile queue up -d

# Gabungkan beberapa profile
docker compose --profile ai-sentiment --profile queue up -d
```

Aktifkan juga variabelnya di `.env`:

```env
AI_SENTIMENT_URL=http://ai-sentiment:8005
STORAGE_DRIVER=minio
MINIO_ENDPOINT=http://minio:9000
REDIS_URL=redis://redis:6379
```

## Perintah harian

```bash
# rebuild setelah kode berubah
docker compose up -d --build

# restart satu service
docker compose restart api

# masuk shell container
docker compose exec api sh
docker compose exec db psql -U kawantumbuh -d kawantumbuh

# lihat pemakaian resource
docker compose stats

# hentikan tanpa menghapus data
docker compose down

# HAPUS SEMUA DATA (database + media) - hati-hati
docker compose down -v
```

## Backup dan restore

```bash
# backup database
docker compose exec -T db pg_dump -U kawantumbuh kawantumbuh > backup.sql

# restore
cat backup.sql | docker compose exec -T db psql -U kawantumbuh -d kawantumbuh

# backup media (volume)
docker run --rm -v kawantumbuh_media_data:/data -v "$PWD":/backup alpine \
  tar czf /backup/media.tar.gz -C /data .
```

## Catatan penting

1. **`NODE_ENV=development`** membuat TypeORM `synchronize` aktif sehingga tabel
   dibuat otomatis. Setelah migrasi TypeORM tersedia, ubah ke `production` agar
   skema tidak berubah otomatis.
2. **Ganti `JWT_SECRET`** sebelum deploy. Nilai default hanya untuk lokal.
3. **HTTPS**: blok TLS di `nginx/conf.d/default.conf` masih dikomentari.
   Letakkan sertifikat di `nginx/certs/`, aktifkan blok tersebut, lalu
   `docker compose exec nginx nginx -t && docker compose restart nginx`.
4. **Upload maksimal 12 MB** dibatasi di NGINX (`client_max_body_size`) dan di
   service disgrafia. Samakan dengan `STORAGE_MAX_UPLOAD_MB`.
5. **Service AI disgrafia** memuat model saat startup, jadi butuh 30-60 detik.
   `start_period` healthcheck sudah disesuaikan.
6. **Service sentiment** membutuhkan `services/ai/sentiment/models/sentiment_model.pkl`.
   Jalankan `python save_model.py` di folder tersebut sebelum mengaktifkan profile.
7. **Service disleksia** saat ini membutuhkan `teks_asr` dari klien; pipeline ASR
   belum tersedia di repo.
8. **Port database tidak dibuka ke host** demi keamanan. Gunakan
   `docker compose exec db psql ...` atau SSH tunnel bila perlu akses eksternal.

## Troubleshooting

| Gejala | Penyebab umum | Solusi |
|---|---|---|
| `api` restart terus | DB belum siap / `DATABASE_URL` salah | `docker compose logs db`, cek password di `.env` |
| 502 dari nginx | `api` belum healthy | `docker compose ps`, `docker compose logs api` |
| 413 saat upload | file > 12 MB | naikkan `client_max_body_size` dan `STORAGE_MAX_UPLOAD_MB` |
| 429 saat login | rate limit auth 10 req/menit | tunggu, atau sesuaikan `auth_limit` |
| AI disgrafia unhealthy | model gagal dimuat / butuh waktu | `docker compose logs ai-dysgraphia` |
| perubahan `.env` tidak terbaca | container belum dibuat ulang | `docker compose up -d --force-recreate` |
