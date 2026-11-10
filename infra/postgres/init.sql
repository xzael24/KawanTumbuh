-- ---------------------------------------------------------------------------
-- Inisialisasi database KAWANTUMBUH.
-- Dijalankan otomatis oleh image postgres HANYA saat volume pg_data masih kosong.
--
-- Catatan: tabel aplikasi dibuat oleh TypeORM (synchronize=true saat
-- NODE_ENV=development). Setelah migrasi tersedia, set NODE_ENV=production
-- dan jalankan migrasi secara eksplisit.
-- ---------------------------------------------------------------------------

-- gen_random_uuid() untuk kolom UUID.
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Fungsi UUID alternatif (opsional, beberapa tooling membutuhkannya).
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Pencarian teks untuk fitur rekomendasi/laporan di masa depan.
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
