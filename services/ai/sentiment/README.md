# Sentiment Analysis Service

FastAPI service for sentiment analysis (positif/negatif/netral).

## Setup

### 1. Save Model Locally

Run in notebook after training:

```python
from transformers import pipeline

# Load trained model from HF hub
pipe = pipeline("text-classification", model="dimeneid/kawantumbuh-sentimen")

# Save as pickle
import pickle
with open("models/sentiment_model.pkl", "wb") as f:
    pickle.dump(pipe, f)
```

Or download from HF hub manually:
```bash
mkdir -p models
python -c "
from transformers import pipeline
import pickle
pipe = pipeline('text-classification', model='dimeneid/kawantumbuh-sentimen')
with open('models/sentiment_model.pkl', 'wb') as f:
    pickle.dump(pipe, f)
"
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Run Server

```bash
uvicorn app:app --host 0.0.0.0 --port 8001
```

## Endpoints

- `GET /` - service info
- `GET /health` - health check
- `POST /predict` - inference
  ```json
  {
    "text": "aplikasi sangat membantu"
  }
  ```
  Response:
  ```json
  {
    "sentiment": "positif",
    "confidence": 0.9876
  }
  ```

## Deploy to VPS

1. Copy `models/sentiment_model.pkl` to VPS
2. Build Docker image or run uvicorn directly
3. Model file ~500MB, include in `.dockerignore` if too large (mount as volume instead)

## Notes

- Model trained on Indonesian text (92% accuracy)
- Labels: positif, negatif, netral
- First inference may be slow (model loading)
