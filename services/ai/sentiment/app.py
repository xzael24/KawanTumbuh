from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import httpx
import os

app = FastAPI(title="Sentiment Analysis Service")

HF_MODEL = "dimeneid/kawantumbuh-sentimen"
HF_API_URL = f"https://api-inference.huggingface.co/models/{HF_MODEL}"
HF_TOKEN = os.getenv("HF_TOKEN", "")  # optional, rate limit tanpa token


class TextInput(BaseModel):
    text: str


class PredictionOutput(BaseModel):
    sentiment: str
    confidence: float


@app.get("/")
def root():
    return {
        "service": "Sentiment Analysis",
        "version": "1.0.0",
        "model": HF_MODEL,
        "inference": "Hugging Face API"
    }


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/predict", response_model=PredictionOutput)
async def predict(input: TextInput):
    """Hit Hugging Face Inference API"""
    headers = {}
    if HF_TOKEN:
        headers["Authorization"] = f"Bearer {HF_TOKEN}"
    
    async with httpx.AsyncClient(timeout=30.0) as client:
        try:
            response = await client.post(
                HF_API_URL,
                headers=headers,
                json={"inputs": input.text}
            )
            response.raise_for_status()
            result = response.json()
            
            # HF returns [{"label": "Positif", "score": 0.99}]
            if isinstance(result, list) and len(result) > 0:
                top = result[0]
                return PredictionOutput(
                    sentiment=top["label"].lower(),
                    confidence=round(top["score"], 4)
                )
            
            raise HTTPException(500, "Unexpected HF response format")
            
        except httpx.HTTPStatusError as e:
            raise HTTPException(e.response.status_code, f"HF API error: {e}")
        except Exception as e:
            raise HTTPException(500, f"Inference failed: {str(e)}")
