# Sentiment Analysis Service (PSC1)

**Author:** M Zaim Jauharuddin (2141762079)

Layanan analisis sentimen ulasan menggunakan transfer learning IndoBERT.

## Model

Model `model_final_indobert.pkl` (422 MB) **tidak di-push ke Git**. 
Deploy: mount volume atau download saat container startup.

Akurasi test: **92.07%** (643 sampel), Macro F1: **0.9206**

## Setup

```bash
pip install -r requirements.txt
uvicorn app:app --reload --port 8001
```

## Endpoint

- `POST /predict` — input `{"text": "ulasan..."}` → output `{"sentiment": "positif", "confidence": 0.85}`

## Dataset

Training pakai gabungan ulasan MobileJKN + PrimaKU (skor 1 & 5).
Lihat `notebooks/Transfer_Learning_UTS.ipynb` untuk EDA + training lengkap.

---

Dokumentasi lengkap model ada di file ini (baris 41-175).
