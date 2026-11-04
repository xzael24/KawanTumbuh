from fastapi import FastAPI
from pydantic import BaseModel
from typing import List
import numpy as np

app = FastAPI(title="KAWANTUMBUH - Dyscalculia RT Screener")

# Skema data JSON yang diterima dari NestJS
class SessionData(BaseModel):
    jumlah_titik: int
    rt_ms: int
    benar: bool

class DyscalculiaRequest(BaseModel):
    sesi_tes: List[SessionData]
    kelas_sd: int

@app.post("/analyze/dyscalculia")
async def analyze_dyscalculia(req: DyscalculiaRequest):
    n = len(req.sesi_tes)
    if n == 0:
        return {"error": "Data sesi tes kosong"}

    # Ekstraksi array untuk perhitungan NumPy
    x_titik = np.array([d.jumlah_titik for d in req.sesi_tes])
    y_rt = np.array([d.rt_ms for d in req.sesi_tes])
    
    # 1. Regresi Linear untuk mendapatkan Subitizing Slope (Kemiringan kurva)
    # np.polyfit mengembalikan [slope, intercept]
    slope, _ = np.polyfit(x_titik, y_rt, 1)
    
    # 2. Hitung Rata-rata RT dan Akurasi
    avg_rt = np.mean(y_rt)
    benar_count = sum([1 for d in req.sesi_tes if d.benar])
    akurasi = (benar_count / n) * 100

    # 3. Rule-Based Cutoff berdasarkan Kelas SD
    batas_rt = {1: 2000, 2: 1800, 3: 1600, 4: 1500, 5: 1400, 6: 1300}.get(req.kelas_sd, 1600)
    batas_slope = 220 if req.kelas_sd <= 2 else 180

    indikasi = []
    if slope > batas_slope:
        indikasi.append(f"Kurva slope curam ({int(slope)} ms/titik) - Indikasi menghitung manual")
    if avg_rt > batas_rt:
        indikasi.append(f"Waktu reaksi lambat (Rata-rata {int(avg_rt)} ms)")
    if akurasi < 75:
        indikasi.append(f"Sering salah menghitung jumlah titik (Akurasi {int(akurasi)}%)")

    return {
        "subitizingSlopeMs": int(round(slope)),
        "rataRataRtMs": int(round(avg_rt)),
        "akurasiPersen": int(round(akurasi)),
        "status": "RISIKO DISKALKULIA" if len(indikasi) > 0 else "NORMAL",
        "detail": indikasi
    }

# Cara menjalankan server di terminal (Gunakan port berbeda, misal 8001):
# cd KAWANTUMBUH/services/ai/dyscalculia
# uvicorn main:app --port 8001 --reload