# Sentiment Analysis Service (PSC1)

**Author:** M Zaim Jauharuddin (2141762079)

Layanan analisis sentimen untuk feedback/rating aplikasi KAWANTUMBUH.

## Model

Model hosted di Hugging Face: [`dimeneid/kawantumbuh-sentimen`](https://huggingface.co/dimeneid/kawantumbuh-sentimen)

Akurasi test: **92.07%** (643 sampel), Macro F1: **0.9206**

Inference via Hugging Face Inference API (gratis, rate limit 1000 req/day).

## Setup

```bash
pip install -r requirements.txt

# Optional: set HF token untuk rate limit lebih tinggi
export HF_TOKEN=hf_xxxxx

uvicorn app:app --reload --port 8001
```

## Endpoint

- `POST /predict` — input `{"text": "ulasan user..."}` → output `{"sentiment": "positif", "confidence": 0.92}`

## Use Case

User kasih feedback soal aplikasi → sentiment analysis klasifikasi positif/negatif → admin dashboard agregat sentimen.

## Dataset & Training

Training pakai gabungan ulasan MobileJKN + PrimaKU (skor 1 & 5).
Lihat `notebooks/Transfer_Learning_UTS.ipynb` untuk EDA + training lengkap.
