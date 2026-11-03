from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pickle
import os
from pathlib import Path

app = FastAPI(title="Sentiment Analysis Service")

MODEL_PATH = Path(__file__).parent / "models" / "sentiment_model.pkl"

class TextInput(BaseModel):
    text: str

class PredictionOutput(BaseModel):
    sentiment: str
    confidence: float

# Lazy load
model = None

def get_model():
    global model
    if model is None:
        if not MODEL_PATH.exists():
            raise FileNotFoundError(f"Model not found: {MODEL_PATH}")
        with open(MODEL_PATH, "rb") as f:
            model = pickle.load(f)
    return model

@app.get("/")
def root():
    return {
        "service": "Sentiment Analysis",
        "version": "1.0.0",
        "model": "Local pickle",
        "model_path": str(MODEL_PATH)
    }

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/predict", response_model=PredictionOutput)
def predict(input: TextInput):
    """Local inference from pickle"""
    try:
        pipe = get_model()
        result = pipe(input.text)[0]
        
        return PredictionOutput(
            sentiment=result["label"].lower(),
            confidence=round(result["score"], 4)
        )
    except Exception as e:
        raise HTTPException(500, f"Prediction failed: {str(e)}")
