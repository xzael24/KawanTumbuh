"""
Download model from HF hub and save as pickle for deployment.
Run once before deploying to VPS.
"""
from transformers import pipeline
import pickle
from pathlib import Path

MODEL_ID = "dimeneid/kawantumbuh-sentimen"
OUTPUT_DIR = Path(__file__).parent / "models"
OUTPUT_FILE = OUTPUT_DIR / "sentiment_model.pkl"

def main():
    OUTPUT_DIR.mkdir(exist_ok=True)
    
    print(f"Downloading model: {MODEL_ID}")
    pipe = pipeline("text-classification", model=MODEL_ID)
    
    print(f"Saving to: {OUTPUT_FILE}")
    with open(OUTPUT_FILE, "wb") as f:
        pickle.dump(pipe, f)
    
    print(f"Done. Model size: {OUTPUT_FILE.stat().st_size / 1024 / 1024:.1f} MB")
    
    # Test
    print("\nTesting...")
    result = pipe("aplikasi sangat membantu")[0]
    print(f"Test result: {result}")

if __name__ == "__main__":
    main()
