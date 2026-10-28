# KAWANTUMBUH

Assalamualaikum sahabat mamah dedeh, sebelumnya bagi siapa saja yang melihat repository ini tolong ucapkan ini didalam hati kalian "Ya Allah semoga kelompok ini project Capstone nya lancar tanpa kendala, Aamiin Aamiin Ya Rabbal Alamin"

Sistem Pemantauan Perkembangan dan Stimulasi Terpadu untuk Penanganan Dini Gejala
*Specific Learning Disorder* (SLD) pada Anak Usia Dasar — disleksia, disgrafia, diskalkulia.

Capstone gabungan 7 mata kuliah, 4 orang, 3 bulan.

## Stack

| Bagian | Teknologi |
|---|---|
| API | NestJS + TypeORM + PostgreSQL |
| Mobile | Flutter (thin client) |
| AI service | Python FastAPI + scikit-learn/OpenCV |
| Deploy | Docker Compose di VM Ubuntu (`vps-zaim`) |

## Struktur

```
apps/api          NestJS — auth, anak, sesi, instrumen, scoring, laporan
apps/mobile       Flutter — kuesioner + tugas + kamera tulisan tangan
services/ai       FastAPI — ekstraksi fitur & inference disgrafia, rekomendasi
infra             docker-compose, nginx, script deploy
docs/instrumen    definisi item & aturan skor per modul
docs/api          openapi.yaml (kontrak API)
docs/laporan      satu laporan per mata kuliah
tests             e2e (Playwright), load (k6), fixtures
scripts           seed, backup, utilitas
```

## Pemetaan mata kuliah

| Mata kuliah | Artefak |
|---|---|
| Framework Programming | `apps/api` |
| Mobile Programming | `apps/mobile` |
| Machine Learning | `services/ai/dysgraphia/model` + `docs/instrumen` |
| Pengolahan Citra Digital | `services/ai/dysgraphia/extractor.py` |
| Pemrograman Sistem Cerdas 1 | `services/ai/recommend` + rule engine di `apps/api` |
| Komputasi & Aplikasi Cloud | `infra/` |
| Pengujian Perangkat Lunak | `tests/` + unit test tiap app |

## Data

Dataset citra (249 file, 14 MB) dan PDF jurnal **tidak** di-commit.
Lokasi arsip: `..\CAPSTONE\Model Disgrafia\` dan `..\CAPSTONE\Jurnal-jurnal referensi\`.
Model terlatih (`.pkl`, < 1 MB) ikut di-commit supaya service langsung jalan.

## Branch

`main` stabil, kerja di `feat/<nama-fitur>`, merge lewat PR.
