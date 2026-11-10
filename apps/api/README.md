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

## Endpoints

Semua endpoint mengembalikan JSON. Endpoint bertanda 🔒 butuh header
`Authorization: Bearer <accessToken>`.

### System
| Method | Path | Keterangan |
|---|---|---|
| GET | `/` | API info |
| GET | `/health` | Health check |

### Auth
| Method | Path | Body | Keterangan |
|---|---|---|---|
| POST | `/auth/register` | `username`, `email`, `password`, `termsAccepted: true` | Daftar user + langsung dapat token |
| POST | `/auth/login` | `email`, `password` | Login |
| POST | `/auth/refresh` | `refreshToken` | Rotasi access + refresh token |
| POST | `/auth/logout` | `refreshToken` | Cabut satu sesi |
| POST 🔒 | `/auth/logout-all` | — | Cabut semua sesi |
| GET 🔒 | `/auth/me` | — | Profil user dari token |
| GET 🔒 | `/auth/sessions` | — | Daftar refresh token aktif/riwayat |
| DELETE 🔒 | `/auth/sessions/:id` | — | Cabut sesi tertentu |
| POST | `/auth/social` | `provider`, `providerUserId`, `email?`, `username?`, `idToken?` | Login/tautkan akun Google/Facebook |
| GET 🔒 | `/auth/social` | — | Daftar akun sosial tertaut |
| DELETE 🔒 | `/auth/social/:id` | — | Lepas akun sosial |
| POST | `/auth/forgot-password` | `email` | Buat kode reset 6 digit (respons menyertakan `resetCode` saat non-production) |
| POST | `/auth/verify-reset-code` | `email`, `code` | Cek validitas kode |
| POST | `/auth/reset-password` | `email`, `code`, `newPassword` | Reset password + cabut semua sesi |

### Users
| Method | Path | Body | Keterangan |
|---|---|---|---|
| GET 🔒 | `/users` | — | Daftar user (TODO: batasi ke admin) |
| GET 🔒 | `/users/me` | — | Profil sendiri |
| PATCH 🔒 | `/users/me` | `username?`, `email?`, `password?`, `termsAccepted?` | Update profil |
| DELETE 🔒 | `/users/me` | — | Hapus akun sendiri |
| GET 🔒 | `/users/:id` | — | Detail user |

### Children
| Method | Path | Body | Keterangan |
|---|---|---|---|
| POST 🔒 | `/children` | `name`, `gender` (`male`/`female`), `dateOfBirth` (`YYYY-MM-DD`), `photo?` | Tambah profil anak |
| GET 🔒 | `/children` | — | Daftar anak milik user |
| GET 🔒 | `/children/:id` | — | Detail anak |
| PATCH 🔒 | `/children/:id` | `name?`, `gender?`, `dateOfBirth?`, `photo?` | Update anak |
| DELETE 🔒 | `/children/:id` | — | Hapus anak |

## Postman

Import dua file berikut ke Postman:

- `docs/api/kawantumbuh.postman_collection.json`
- `docs/api/kawantumbuh.postman_environment.json`

Pilih environment **KAWANTUMBUH Local**, lalu jalankan folder **Auth → Register**
lebih dulu. Token dan ID otomatis disimpan ke environment variable.

## Stack

- NestJS 12
- TypeORM + PostgreSQL
- JWT HS256 (implementasi `node:crypto`, tanpa passport)
- Password hashing scrypt (`node:crypto`)
- Class validation

## Database

Butuh PostgreSQL running di `localhost:5432`. Atau pakai docker-compose (lihat `/infra`).

Migrasi & seed belum ada — synchronize auto-run di development.
