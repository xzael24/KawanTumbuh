from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd
import re

app = FastAPI(title="Sentiment Analysis Service")

# Load slang dictionary
try:
    slang_df = pd.read_csv("kamus_slang.csv")
    slang_dict = dict(zip(slang_df.iloc[:, 0], slang_df.iloc[:, 1]))
except Exception as e:
    print(f"Warning: kamus_slang.csv not found - {e}")
    slang_dict = {}


class TextInput(BaseModel):
    text: str


class PredictionOutput(BaseModel):
    sentiment: str
    confidence: float
    cleaned_text: str


def preprocess_text(text: str) -> str:
    """Basic preprocessing"""
    text = text.lower()
    text = re.sub(r'[^a-z\s]', '', text)
    words = [slang_dict.get(w, w) for w in text.split()]
    return ' '.join(words)


@app.get("/")
def root():
    return {
        "service": "Sentiment Analysis",
        "version": "1.0.0",
        "model": "IndoBERT (not loaded - placeholder)"
    }


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/predict", response_model=PredictionOutput)
def predict(input: TextInput):
    """
    Predict sentiment from text.
    Model .pkl (422MB) loaded via volume mount on production.
    """
    cleaned = preprocess_text(input.text)
    
    # ponytail: model inference skipped - load model_final_indobert.pkl when deployed
    # Dummy response for now
    return PredictionOutput(
        sentiment="positif" if len(cleaned) > 20 else "negatif",
        confidence=0.85,
        cleaned_text=cleaned
    )
