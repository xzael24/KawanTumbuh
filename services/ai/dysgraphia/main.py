"""
FastAPI wrapper untuk layanan disgrafia.

Service ini membungkus pipeline yang sudah ada di app.py
(preprocess_image -> extract_features -> DysgraphiaClassifier)
agar bisa dipanggil oleh backend NestJS lewat HTTP.

Jalankan lokal:
    uvicorn main:app --host 0.0.0.0 --port 8002 --reload

Catatan: app.py tetap dipertahankan sebagai CLI/GUI untuk demo.
"""

import os
import tempfile
import time
from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI, File, HTTPException, UploadFile
from fastapi.responses import JSONResponse

from app import DysgraphiaClassifier

MAX_UPLOAD_BYTES = 12 * 1024 * 1024  # 12 MB
ALLOWED_CONTENT_TYPES = {
    "image/jpeg": ".jpg",
    "image/png": ".png",
    "image/webp": ".webp",
    "image/bmp": ".bmp",
}

classifier: DysgraphiaClassifier | None = None


@asynccontextmanager
async def lifespan(_: FastAPI):
    """Muat model sekali saat startup, bukan per request."""
    global classifier
    classifier = DysgraphiaClassifier()
    yield
    classifier = None


app = FastAPI(
    title="KAWANTUMBUH - Dysgraphia Service",
    version="1.0.0",
    lifespan=lifespan,
)


@app.get("/health")
def health() -> dict:
    return {
        "status": "ok",
        "service": "dysgraphia",
        "modelLoaded": classifier is not None,
    }


@app.get("/version")
def version() -> dict:
    if classifier is None:
        raise HTTPException(status_code=503, detail="Model belum siap")
    return {
        "service": "dysgraphia",
        "modelVersion": classifier.model_name,
        "featureCount": len(classifier.feature_names),
    }


@app.post("/analyze/dysgraphia")
async def analyze_dysgraphia(image: UploadFile = File(...)) -> JSONResponse:
    if classifier is None:
        raise HTTPException(status_code=503, detail="Model belum siap")

    suffix = ALLOWED_CONTENT_TYPES.get(image.content_type or "")
    if suffix is None:
        raise HTTPException(
            status_code=415,
            detail="Format gambar tidak didukung. Gunakan JPEG, PNG, WEBP, atau BMP.",
        )

    content = await image.read()
    if not content:
        raise HTTPException(status_code=400, detail="File gambar kosong")
    if len(content) > MAX_UPLOAD_BYTES:
        raise HTTPException(status_code=413, detail="Ukuran gambar melebihi 12 MB")

    tmp_path: str | None = None
    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
            tmp.write(content)
            tmp_path = tmp.name

        started = time.perf_counter()
        result = classifier.predict(tmp_path)
        latency_ms = round((time.perf_counter() - started) * 1000, 1)

        return JSONResponse(
            content={
                "service": "dysgraphia",
                "modelVersion": result["model_name"],
                "label": result["predicted_label"],
                "predictedClass": result["predicted_class"],
                "confidence": result["confidence_score"],
                "probabilities": {
                    "low": result["prob_low_potential"],
                    "potential": result["prob_potential"],
                },
                "features": result["features"],
                "preprocessingMode": result["mode_desc"],
                "latencyMs": latency_ms,
            }
        )
    except HTTPException:
        raise
    except Exception as exc:  # noqa: BLE001 - boundary service, kembalikan 422
        raise HTTPException(
            status_code=422,
            detail=f"Gagal menganalisis gambar: {exc}",
        ) from exc
    finally:
        if tmp_path and os.path.exists(tmp_path):
            os.remove(tmp_path)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=8002, reload=True)
