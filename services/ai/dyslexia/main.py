from fastapi import FastAPI, UploadFile, File, Form
from fastapi.responses import JSONResponse
import librosa
import jiwer
import tempfile
import os

app = FastAPI(title="KAWANTUMBUH - Dyslexia Audio Screener")

@app.get("/health")
def health():
    return {"status": "ok", "service": "dyslexia"}

@app.post("/analyze/audio")
async def analyze_dyslexia(
    audio: UploadFile = File(...),
    teks_target: str = Form(...),
    teks_asr: str = Form(...),
    kelas_sd: int = Form(...)
):
    # 1. Simpan file audio dari NestJS ke temporary file
    temp_file = tempfile.NamedTemporaryFile(delete=False, suffix=".wav")
    try:
        content = await audio.read()
        temp_file.write(content)
        temp_file.close()

        # 2. Proses Audio menggunakan Librosa
        y, sr = librosa.load(temp_file.name, sr=16000)
        durasi = librosa.get_duration(y=y, sr=sr)

        # 3. Hitung CER & WER
        target_clean = teks_target.lower().strip()
        asr_clean = teks_asr.lower().strip()
        wer = jiwer.wer(target_clean, asr_clean) * 100
        cer = jiwer.cer(target_clean, asr_clean) * 100

        # 4. Hitung CWPM
        kata_benar = round(len(target_clean.split()) * max(0, 1 - (wer / 100)))
        cwpm = (kata_benar / durasi) * 60 if durasi > 0 else 0

        # 5. Hitung Pause Ratio
        intervals = librosa.effects.split(y, top_db=30)
        durasi_bicara = sum([(end - start) / sr for start, end in intervals])
        pause_ratio = ((durasi - durasi_bicara) / durasi) * 100 if durasi > 0 else 0

        # 6. Rule-Based Cutoff berdasarkan Kelas
        batas_cwpm = {1: 15, 2: 25, 3: 40, 4: 55, 5: 65, 6: 75}.get(kelas_sd, 40)
        
        indikasi = []
        if cer > 10: indikasi.append("Banyak kesalahan huruf (CER Tinggi)")
        if cwpm < batas_cwpm: indikasi.append("Sangat lambat membaca (CWPM Rendah)")
        if pause_ratio > 40: indikasi.append("Sering terdiam (Pause Ratio Tinggi)")

        return JSONResponse(content={
            "cwpm": round(cwpm, 1),
            "cer": round(cer, 1),
            "wer": round(wer, 1),
            "pauseRatio": round(pause_ratio, 1),
            "status": "RISIKO DISLEKSIA" if len(indikasi) >= 2 else "NORMAL",
            "detail": indikasi
        })

    finally:
        # Bersihkan file temporary agar server tidak penuh
        if os.path.exists(temp_file.name):
            os.remove(temp_file.name)

# Cara menjalankan server di terminal:
# cd KAWANTUMBUH/services/ai/dyslexia
# uvicorn main:app --port 8000 --reload