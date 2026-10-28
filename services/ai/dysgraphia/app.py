"""
=============================================================================
Aplikasi Deteksi Disgrafia Tulisan Tangan (Dysgraphia Handwriting AI)
=============================================================================
Aplikasi GUI & CLI modern untuk menguji dan memprediksi potensi disgrafia
dari citra tulisan tangan anak.

Pembaruan Tampilan:
- Adaptive Dynamic Scaling: Gambar strip memanjang otomatis di-zoom agar tulisan terbaca jelas.
- Tombol Zoom / Pop-up: Bisa melihat gambar dalam ukuran besar/asli.
- Smart Auto-Polarity: Mendukung foto kertas putih maupun latar hitam.
=============================================================================
"""

import sys
import os
import json
import math
import warnings
from pathlib import Path

# Suppress sklearn unpickle version warnings
warnings.filterwarnings("ignore", category=UserWarning)

import cv2
import joblib
import numpy as np
from PIL import Image, ImageTk

# Library Feature Extraction
from scipy.ndimage import distance_transform_edt
from skimage.feature import graycomatrix, graycoprops

# =============================================================================
# 1. Smart Pipeline Preprocessing & Feature Extraction
# =============================================================================

def preprocess_image(img_path):
    """
    Melakukan Smart Preprocessing pada resolusi asli citra.
    """
    img = Image.open(img_path).convert('L')
    gray_raw = np.array(img)
    
    mean_val = np.mean(gray_raw)
    is_white_paper = (mean_val > 120)
    
    if is_white_paper:
        # FOTO ASLI (Kertas Putih, Tinta Gelap):
        gray_normalized = 255 - gray_raw
        blurred = cv2.GaussianBlur(gray_normalized, (3, 3), 0)
        _, binary = cv2.threshold(blurred, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        
        kernel_clean = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
        binary = cv2.morphologyEx(binary, cv2.MORPH_OPEN, kernel_clean)
        
        kernel_dilate = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (2, 2))
        binary = cv2.dilate(binary, kernel_dilate, iterations=1)
        mode_desc = "Foto Kertas Putih (Auto-Inverted & Dilated)"
    else:
        # FORMAT DATASET (Latar Hitam, Tulisan Putih Tebal):
        gray_normalized = gray_raw
        _, binary = cv2.threshold(gray_raw, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        kernel_clean = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
        binary = cv2.morphologyEx(binary, cv2.MORPH_OPEN, kernel_clean)
        mode_desc = "Format Latar Hitam (Dataset Native)"
        
    # Crop dengan margin proporsional 25px
    coords = cv2.findNonZero(binary)
    if coords is not None:
        x, y, w, h = cv2.boundingRect(coords)
        pad_x = 25
        pad_y = 20
        x1 = max(0, x - pad_x)
        y1 = max(0, y - pad_y)
        x2 = min(gray_raw.shape[1], x + w + pad_x)
        y2 = min(gray_raw.shape[0], y + h + pad_y)
        cropped_gray = gray_normalized[y1:y2, x1:x2]
        cropped_binary = binary[y1:y2, x1:x2]
    else:
        cropped_gray = gray_normalized
        cropped_binary = binary
        
    return gray_raw, cropped_gray, cropped_binary, mode_desc


def extract_features(cropped_gray, cropped_binary):
    """
    Mengekstrak 25 fitur grafologi & computer vision dari citra tulisan tangan.
    """
    h_img, w_img = cropped_binary.shape
    
    # Connected Components
    num_labels, labels, stats_cc, centroids = cv2.connectedComponentsWithStats(cropped_binary, connectivity=8)
    min_area = 15
    valid_indices = [i for i in range(1, num_labels) if stats_cc[i, cv2.CC_STAT_AREA] >= min_area]
    if len(valid_indices) < 2:
        valid_indices = list(range(1, max(2, num_labels)))
        
    comp_widths = [stats_cc[i, cv2.CC_STAT_WIDTH] for i in valid_indices]
    comp_heights = [stats_cc[i, cv2.CC_STAT_HEIGHT] for i in valid_indices]
    comp_centroids = [centroids[i] for i in valid_indices]
    
    sorted_by_x = sorted(zip(comp_centroids, comp_widths, comp_heights), key=lambda item: item[0][0])
    sorted_centroids = [item[0] for item in sorted_by_x]
    
    # A. Baseline
    y_coords = [c[1] for c in sorted_centroids]
    baseline_dev_std = float(np.std(y_coords)) if len(y_coords) > 1 else 0.0
    y_diffs = np.abs(np.diff(y_coords)) if len(y_coords) > 1 else [0.0]
    baseline_waviness = float(np.mean(y_diffs))
    
    # B. Dimensions
    h_mean = float(np.mean(comp_heights)) if comp_heights else 0.0
    h_std = float(np.std(comp_heights)) if len(comp_heights) > 1 else 0.0
    height_cov = (h_std / h_mean) if h_mean > 0 else 0.0
    
    w_mean = float(np.mean(comp_widths)) if comp_widths else 0.0
    w_std = float(np.std(comp_widths)) if len(comp_widths) > 1 else 0.0
    width_cov = (w_std / w_mean) if w_mean > 0 else 0.0
    
    char_aspect_ratios = [w / h if h > 0 else 0 for w, h in zip(comp_widths, comp_heights)]
    aspect_ratio_char_mean = float(np.mean(char_aspect_ratios)) if char_aspect_ratios else 0.0
    aspect_ratio_char_std = float(np.std(char_aspect_ratios)) if len(char_aspect_ratios) > 1 else 0.0
    
    # C. Slant
    sobelx = cv2.Sobel(cropped_gray, cv2.CV_64F, 1, 0, ksize=3)
    sobely = cv2.Sobel(cropped_gray, cv2.CV_64F, 0, 1, ksize=3)
    magnitude = np.sqrt(sobelx**2 + sobely**2)
    edge_mask = (magnitude > np.percentile(magnitude, 75)) & (cropped_binary > 0)
    if np.sum(edge_mask) > 10:
        angles_rad = np.arctan2(sobely[edge_mask], sobelx[edge_mask])
        angles_deg = np.rad2deg(angles_rad)
        angles_deg = ((angles_deg + 90) % 180) - 90
        slant_angle_mean = float(np.mean(np.abs(angles_deg)))
        slant_angle_std = float(np.std(angles_deg))
    else:
        slant_angle_mean = 0.0
        slant_angle_std = 0.0
        
    # D. Spacing & Density
    total_pixels = h_img * w_img
    ink_pixels = int(np.sum(cropped_binary == 255))
    ink_density = float(ink_pixels / total_pixels) if total_pixels > 0 else 0.0
    
    spacings = []
    for k in range(len(sorted_by_x) - 1):
        x_curr = sorted_by_x[k][0][0] + (sorted_by_x[k][1] / 2.0)
        x_next = sorted_by_x[k+1][0][0] - (sorted_by_x[k+1][1] / 2.0)
        spacings.append(max(0, x_next - x_curr))
    inter_comp_spacing_mean = float(np.mean(spacings)) if spacings else 0.0
    inter_comp_spacing_std = float(np.std(spacings)) if len(spacings) > 1 else 0.0
    num_components_density = float(len(valid_indices) / (w_img / 1000.0)) if w_img > 0 else 0.0
    
    # E. Roughness & Thickness
    contours, _ = cv2.findContours(cropped_binary, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    roughness_vals = []
    for cnt in contours:
        area = cv2.contourArea(cnt)
        if area >= min_area:
            perimeter = cv2.arcLength(cnt, True)
            r = (perimeter ** 2) / (4 * math.pi * area) if area > 0 else 0.0
            roughness_vals.append(r)
    stroke_roughness_mean = float(np.mean(roughness_vals)) if roughness_vals else 1.0
    stroke_roughness_std = float(np.std(roughness_vals)) if len(roughness_vals) > 1 else 0.0
    
    dist_map = distance_transform_edt(cropped_binary == 255)
    ink_distances = dist_map[cropped_binary == 255]
    if len(ink_distances) > 0:
        stroke_thickness_mean = float(np.mean(ink_distances) * 2.0)
        stroke_thickness_std = float(np.std(ink_distances) * 2.0)
    else:
        stroke_thickness_mean = 0.0
        stroke_thickness_std = 0.0
        
    # F. GLCM
    gray_resized = cv2.resize(cropped_gray, (256, 64), interpolation=cv2.INTER_AREA)
    gray_quantized = (gray_resized // 16).astype(np.uint8)
    glcm = graycomatrix(gray_quantized, distances=[1, 3], angles=[0, np.pi/4, np.pi/2], levels=16, symmetric=True, normed=True)
    glcm_contrast = float(np.mean(graycoprops(glcm, 'contrast')))
    glcm_dissimilarity = float(np.mean(graycoprops(glcm, 'dissimilarity')))
    glcm_homogeneity = float(np.mean(graycoprops(glcm, 'homogeneity')))
    glcm_energy = float(np.mean(graycoprops(glcm, 'energy')))
    glcm_correlation = float(np.mean(graycoprops(glcm, 'correlation')))
    
    return {
        'baseline_dev_std': baseline_dev_std,
        'baseline_waviness': baseline_waviness,
        'height_mean': h_mean,
        'height_std': h_std,
        'height_cov': height_cov,
        'width_mean': w_mean,
        'width_std': w_std,
        'width_cov': width_cov,
        'aspect_ratio_char_mean': aspect_ratio_char_mean,
        'aspect_ratio_char_std': aspect_ratio_char_std,
        'slant_angle_mean': slant_angle_mean,
        'slant_angle_std': slant_angle_std,
        'ink_density': ink_density,
        'inter_comp_spacing_mean': inter_comp_spacing_mean,
        'inter_comp_spacing_std': inter_comp_spacing_std,
        'num_components_density': num_components_density,
        'stroke_roughness_mean': stroke_roughness_mean,
        'stroke_roughness_std': stroke_roughness_std,
        'stroke_thickness_mean': stroke_thickness_mean,
        'stroke_thickness_std': stroke_thickness_std,
        'glcm_contrast': glcm_contrast,
        'glcm_dissimilarity': glcm_dissimilarity,
        'glcm_homogeneity': glcm_homogeneity,
        'glcm_energy': glcm_energy,
        'glcm_correlation': glcm_correlation
    }


class DysgraphiaClassifier:
    """
    Wrapper untuk memuat model dan melakukan inferensi.
    """
    def __init__(self, base_dir=None):
        if base_dir is None:
            base_dir = Path(__file__).parent.resolve()
        else:
            base_dir = Path(base_dir).resolve()
            
        opt_model_path = base_dir / "best_optimized_random_forest.pkl"
        default_model_path = base_dir / "best_dysgraphia_model.pkl"
        
        if opt_model_path.exists():
            self.model_path = opt_model_path
            self.model_name = "Optimized Random Forest"
        elif default_model_path.exists():
            self.model_path = default_model_path
            self.model_name = "Random Forest (Default)"
        else:
            raise FileNotFoundError(
                f"File model tidak ditemukan di: {base_dir}\n"
                "Pastikan 'best_optimized_random_forest.pkl' atau 'best_dysgraphia_model.pkl' tersedia."
            )
            
        self.scaler_path = base_dir / "dysgraphia_scaler.pkl"
        self.features_path = base_dir / "feature_names.json"
        
        if not self.scaler_path.exists():
            raise FileNotFoundError(f"File scaler '{self.scaler_path}' tidak ditemukan.")
            
        self.model = joblib.load(self.model_path)
        self.scaler = joblib.load(self.scaler_path)
        
        if self.features_path.exists():
            with open(self.features_path, 'r', encoding='utf-8') as f:
                self.feature_names = json.load(f)
        else:
            self.feature_names = [
                'baseline_dev_std', 'baseline_waviness', 'height_mean', 'height_std', 'height_cov',
                'width_mean', 'width_std', 'width_cov', 'aspect_ratio_char_mean', 'aspect_ratio_char_std',
                'slant_angle_mean', 'slant_angle_std', 'ink_density', 'inter_comp_spacing_mean',
                'inter_comp_spacing_std', 'num_components_density', 'stroke_roughness_mean',
                'stroke_roughness_std', 'stroke_thickness_mean', 'stroke_thickness_std',
                'glcm_contrast', 'glcm_dissimilarity', 'glcm_homogeneity', 'glcm_energy', 'glcm_correlation'
            ]

    def predict(self, image_path):
        image_path = Path(image_path).resolve()
        if not image_path.exists():
            raise FileNotFoundError(f"File gambar tidak ditemukan: {image_path}")
            
        gray_raw, cropped_gray, cropped_binary, mode_desc = preprocess_image(image_path)
        features_dict = extract_features(cropped_gray, cropped_binary)
        
        vector = np.array([features_dict[name] for name in self.feature_names]).reshape(1, -1)
        vector_scaled = self.scaler.transform(vector)
        
        pred_class = int(self.model.predict(vector_scaled)[0])
        prob_scores = self.model.predict_proba(vector_scaled)[0]
        
        prob_low = round(prob_scores[0] * 100, 2)
        prob_pot = round(prob_scores[1] * 100, 2)
        conf_score = round(prob_scores[pred_class] * 100, 2)
        pred_label = "Potential Dysgraphia" if pred_class == 1 else "Low Potential Dysgraphia"
        
        return {
            'image_path': str(image_path),
            'filename': image_path.name,
            'model_name': self.model_name,
            'mode_desc': mode_desc,
            'predicted_class': pred_class,
            'predicted_label': pred_label,
            'confidence_score': conf_score,
            'prob_low_potential': prob_low,
            'prob_potential': prob_pot,
            'features': features_dict,
            'orig_gray': gray_raw,
            'cropped_binary': cropped_binary
        }


# =============================================================================
# 2. CLI Execution Mode
# =============================================================================

def run_cli(image_path):
    print("=" * 65)
    print("      HASIL DETEKSI DISGRAFIA TULISAN TANGAN (AI DIAGNOSIS)")
    print("=" * 65)
    try:
        clf = DysgraphiaClassifier()
        res = clf.predict(image_path)
        badge = "[+] POTENSI DISGRAFIA" if res['predicted_class'] == 1 else "[-] POTENSI RENDAH DISGRAFIA"
        
        print(f"File Citra         : {res['filename']}")
        print(f"Model Digunakan    : {res['model_name']}")
        print(f"Mode Preprocessing : {res['mode_desc']}")
        print(f"Status Diagnosis   : {badge}")
        print(f"Prediksi Label     : {res['predicted_label']}")
        print(f"Tingkat Keyakinan  : {res['confidence_score']}%")
        print("-" * 65)
        print("Rincian Probabilitas:")
        print(f" - Low Potential Dysgraphia : {res['prob_low_potential']}%")
        print(f" - Potential Dysgraphia     : {res['prob_potential']}%")
        print("-" * 65)
        print("Indikator Grafologi Utama:")
        f = res['features']
        print(f" * Baseline Waviness (Gelombang Baris)  : {f['baseline_waviness']:.2f}")
        print(f" * Height Variation (Inkonsistensi CoV) : {f['height_cov']:.2f}")
        print(f" * Slant Variation (Ketidakteraturan)   : {f['slant_angle_std']:.2f} deg")
        print(f" * Stroke Roughness (Kerutan Goresan)   : {f['stroke_roughness_mean']:.2f}")
        print(f" * Ink Density (Kerapatan Tinta)        : {f['ink_density']:.3f}")
        print("=" * 65)
    except Exception as e:
        print(f"[ERROR] Gagal menganalisis gambar: {e}")


# =============================================================================
# 3. Modern Tkinter GUI Desktop Application (Enhanced Display)
# =============================================================================

def run_gui():
    import tkinter as tk
    from tkinter import ttk, filedialog, messagebox
    
    root = tk.Tk()
    root.title("Dysgraphia Handwriting Analyzer")
    root.geometry("1060x760")
    root.minsize(960, 680)
    root.configure(bg="#f3f4f6")
    
    try:
        classifier = DysgraphiaClassifier()
    except Exception as e:
        messagebox.showerror("Error Inisialisasi Model", str(e))
        return

    # Style ttk
    style = ttk.Style()
    style.theme_use('clam')
    style.configure('TFrame', background='#f3f4f6')
    style.configure('Header.TLabel', font=('Helvetica', 16, 'bold'), background='#f3f4f6', foreground='#1f2937')
    style.configure('SubHeader.TLabel', font=('Helvetica', 10), background='#f3f4f6', foreground='#6b7280')

    # Header Frame
    header_frame = ttk.Frame(root, padding="15 15 15 8")
    header_frame.pack(fill='x')
    
    title_lbl = ttk.Label(header_frame, text="✍️ Dysgraphia Handwriting Analyzer", style='Header.TLabel')
    title_lbl.pack(anchor='w')
    subtitle_lbl = ttk.Label(
        header_frame,
        text="Aplikasi deteksi otomatis potensi disgrafia tulisan tangan anak (Dengan Dynamic Zoom Preview)",
        style='SubHeader.TLabel'
    )
    subtitle_lbl.pack(anchor='w', pady=(2, 0))

    ttk.Separator(root, orient='horizontal').pack(fill='x', padx=15, pady=4)

    # Main Content Split
    content_frame = ttk.Frame(root, padding="15 5 15 10")
    content_frame.pack(fill='both', expand=True)
    content_frame.columnconfigure(0, weight=6) # 60% width for image preview
    content_frame.columnconfigure(1, weight=4) # 40% width for results
    content_frame.rowconfigure(0, weight=1)

    # ================= LEFT PANEL: Image Selection & Big Dynamic Preview =================
    left_panel = tk.Frame(content_frame, bg="white", highlightbackground="#e5e7eb", highlightthickness=1)
    left_panel.grid(row=0, column=0, sticky="nsew", padx=(0, 10), pady=5)

    btn_frame = tk.Frame(left_panel, bg="white", pady=10)
    btn_frame.pack(fill='x', padx=15)
    
    selected_file_var = tk.StringVar(value="Belum ada gambar yang dipilih")
    current_image_path = [None]

    def open_image_dialog():
        file_types = [
            ("File Gambar", "*.jpg *.jpeg *.png *.bmp *.webp"),
            ("JPEG Image", "*.jpg *.jpeg"),
            ("PNG Image", "*.png"),
            ("All Files", "*.*")
        ]
        chosen = filedialog.askopenfilename(title="Pilih Citra Tulisan Tangan", filetypes=file_types)
        if chosen:
            current_image_path[0] = chosen
            process_and_display(chosen)

    select_btn = tk.Button(
        btn_frame, text="📂 Pilih Gambar Tulisan Tangan...", font=('Helvetica', 10, 'bold'),
        bg="#2563eb", fg="white", activebackground="#1d4ed8", activeforeground="white",
        padx=15, pady=6, relief="flat", cursor="hand2", command=open_image_dialog
    )
    select_btn.pack(side='left')

    path_lbl = tk.Label(btn_frame, textvariable=selected_file_var, font=('Helvetica', 9), bg="white", fg="#6b7280", anchor='w')
    path_lbl.pack(side='left', padx=10, fill='x', expand=True)

    # Preview Container
    preview_container = tk.Frame(left_panel, bg="#f9fafb", padx=12, pady=8)
    preview_container.pack(fill='both', expand=True, padx=15, pady=(0, 12))

    # 1. Original Image Section
    top_bar_orig = tk.Frame(preview_container, bg="#f9fafb")
    top_bar_orig.pack(fill='x', pady=(4, 2))
    
    lbl_orig_title = tk.Label(top_bar_orig, text="1. Citra Asli Input:", font=('Helvetica', 9, 'bold'), bg="#f9fafb", fg="#374151")
    lbl_orig_title.pack(side='left')
    
    dim_orig_lbl = tk.Label(top_bar_orig, text="", font=('Helvetica', 8), bg="#f9fafb", fg="#6b7280")
    dim_orig_lbl.pack(side='right')

    frame_orig_box = tk.Frame(preview_container, bg="#1e293b", bd=1, relief="solid", height=130)
    frame_orig_box.pack(fill='x', expand=False, pady=(0, 10))
    frame_orig_box.pack_propagate(False)

    img_orig_canvas = tk.Label(frame_orig_box, text="Silakan pilih gambar tulisan tangan untuk memulai", font=('Helvetica', 10), bg="#1e293b", fg="#94a3b8")
    img_orig_canvas.pack(fill='both', expand=True)

    # 2. Binary Preprocessed Section
    top_bar_bin = tk.Frame(preview_container, bg="#f9fafb")
    top_bar_bin.pack(fill='x', pady=(4, 2))

    lbl_bin_title = tk.Label(top_bar_bin, text="2. Hasil Binarisasi & Penebalan Adaptif:", font=('Helvetica', 9, 'bold'), bg="#f9fafb", fg="#374151")
    lbl_bin_title.pack(side='left')
    
    dim_bin_lbl = tk.Label(top_bar_bin, text="", font=('Helvetica', 8), bg="#f9fafb", fg="#6b7280")
    dim_bin_lbl.pack(side='right')

    frame_bin_box = tk.Frame(preview_container, bg="#0f172a", bd=1, relief="solid", height=130)
    frame_bin_box.pack(fill='x', expand=False, pady=(0, 6))
    frame_bin_box.pack_propagate(False)

    img_bin_canvas = tk.Label(frame_bin_box, text="Hasil binarisasi akan ditampilkan di sini", font=('Helvetica', 10), bg="#0f172a", fg="#64748b")
    img_bin_canvas.pack(fill='both', expand=True)

    mode_info_lbl = tk.Label(preview_container, text="Status Preprocessing: Menunggu berkas gambar...", font=('Helvetica', 8, 'italic'), bg="#f9fafb", fg="#4b5563")
    mode_info_lbl.pack(anchor='w', pady=(4, 2))

    # ================= RIGHT PANEL: Results =================
    right_panel = tk.Frame(content_frame, bg="white", highlightbackground="#e5e7eb", highlightthickness=1)
    right_panel.grid(row=0, column=1, sticky="nsew", padx=(5, 0), pady=5)

    res_header = tk.Label(right_panel, text="Hasil Diagnosis AI", font=('Helvetica', 12, 'bold'), bg="white", fg="#1f2937")
    res_header.pack(anchor='w', padx=15, pady=(15, 10))

    # Badge Box
    badge_frame = tk.Frame(right_panel, bg="#f3f4f6", padx=15, pady=12, highlightthickness=1, highlightbackground="#e5e7eb")
    badge_frame.pack(fill='x', padx=15, pady=5)

    badge_status = tk.Label(badge_frame, text="MENUNGGU INPUT", font=('Helvetica', 13, 'bold'), bg="#f3f4f6", fg="#6b7280")
    badge_status.pack(anchor='w')

    badge_conf = tk.Label(badge_frame, text="Tingkat Keyakinan: -", font=('Helvetica', 10), bg="#f3f4f6", fg="#4b5563")
    badge_conf.pack(anchor='w', pady=(3, 0))

    # Probability Bar
    prob_frame = tk.Frame(right_panel, bg="white", padx=15, pady=10)
    prob_frame.pack(fill='x')
    
    prob_low_lbl = tk.Label(prob_frame, text="Low Potential: -", font=('Helvetica', 9, 'bold'), bg="white", fg="#2563eb")
    prob_low_lbl.pack(anchor='w')
    prob_pot_lbl = tk.Label(prob_frame, text="Potential Dysgraphia: -", font=('Helvetica', 9, 'bold'), bg="white", fg="#dc2626")
    prob_pot_lbl.pack(anchor='w', pady=(2, 6))

    progress_bar = ttk.Progressbar(prob_frame, orient='horizontal', mode='determinate')
    progress_bar.pack(fill='x')

    # Key Metrics Table
    metrics_title = tk.Label(right_panel, text="Indikator Fitur Grafologi Utama:", font=('Helvetica', 10, 'bold'), bg="white", fg="#374151")
    metrics_title.pack(anchor='w', padx=15, pady=(12, 4))

    metrics_box = tk.Frame(right_panel, bg="#f9fafb", padx=12, pady=10, highlightthickness=1, highlightbackground="#e5e7eb")
    metrics_box.pack(fill='both', expand=True, padx=15, pady=(0, 12))

    metric_vars = {
        'waviness': tk.StringVar(value="• Baseline Waviness (Gelombang Baris) : -"),
        'height_cov': tk.StringVar(value="• Height Variation (Inkonsistensi Huruf): -"),
        'slant_std': tk.StringVar(value="• Slant Variation (Ketidakteraturan)   : -"),
        'roughness': tk.StringVar(value="• Stroke Roughness (Kerutan Goresan)   : -"),
        'ink_dens': tk.StringVar(value="• Ink Density (Kerapatan Tinta)        : -")
    }

    for key, var in metric_vars.items():
        lbl = tk.Label(metrics_box, textvariable=var, font=('Consolas', 9), bg="#f9fafb", fg="#1f2937", anchor='w')
        lbl.pack(fill='x', pady=2)

    # Status Bar
    status_bar = tk.Label(root, text=f"Siap. Model aktif: {classifier.model_name}", bd=1, relief="sunken", anchor="w", font=('Helvetica', 8), bg="#e5e7eb", fg="#4b5563", padx=10, pady=4)
    status_bar.pack(side="bottom", fill="x")

    def smart_scale_for_display(pil_img, target_w=520, target_h=120):
        """
        Menskalakan gambar strip secara cerdas agar tulisan tangan terlihat besar & jelas.
        """
        orig_w, orig_h = pil_img.size
        aspect = orig_w / max(1, orig_h)
        
        if aspect > 4.0:
            # Strip horizontal sangat panjang: Maksimalkan tinggi agar tulisan jelas
            scale_h = target_h / orig_h
            scale_w = target_w / orig_w
            scale = min(scale_h * 1.5, scale_w) # Berikan boost vertikal
            new_w = min(target_w, max(50, int(orig_w * scale)))
            new_h = min(target_h, max(45, int(orig_h * scale)))
        else:
            scale = min(target_w / orig_w, target_h / orig_h, 1.0)
            new_w = max(50, int(orig_w * scale))
            new_h = max(30, int(orig_h * scale))
            
        return pil_img.resize((new_w, new_h), Image.Resampling.LANCZOS)

    def process_and_display(file_path):
        try:
            status_bar.config(text=f"Menganalisis gambar: {Path(file_path).name}...")
            root.update_idletasks()
            
            res = classifier.predict(file_path)
            selected_file_var.set(Path(file_path).name)

            # 1. Update Citra Asli
            pil_orig = Image.open(file_path)
            dim_orig_lbl.config(text=f"Resolusi Asli: {pil_orig.size[0]} x {pil_orig.size[1]} px")
            scaled_orig = smart_scale_for_display(pil_orig, target_w=540, target_h=120)
            tk_orig = ImageTk.PhotoImage(scaled_orig)
            img_orig_canvas.config(image=tk_orig, text="")
            img_orig_canvas.image = tk_orig
            
            # 2. Update Citra Binarisasi
            pil_bin = Image.fromarray(res['cropped_binary'])
            dim_bin_lbl.config(text=f"Ukuran Terproses: {pil_bin.size[0]} x {pil_bin.size[1]} px")
            scaled_bin = smart_scale_for_display(pil_bin, target_w=540, target_h=120)
            tk_bin = ImageTk.PhotoImage(scaled_bin)
            img_bin_canvas.config(image=tk_bin, text="")
            img_bin_canvas.image = tk_bin

            mode_info_lbl.config(text=f"Mode Preprocessing: {res['mode_desc']}")

            # Update Badge
            is_pot = (res['predicted_class'] == 1)
            bg_color = "#fef2f2" if is_pot else "#eff6ff"
            fg_color = "#dc2626" if is_pot else "#2563eb"
            border_color = "#fca5a5" if is_pot else "#bfdbfe"
            status_text = "🔴 POTENSI DISGRAFIA" if is_pot else "🟢 POTENSI RENDAH DISGRAFIA"
            
            badge_frame.config(bg=bg_color, highlightbackground=border_color)
            badge_status.config(text=status_text, bg=bg_color, fg=fg_color)
            badge_conf.config(text=f"Tingkat Keyakinan Model: {res['confidence_score']}%", bg=bg_color)
            
            prob_low_lbl.config(text=f"• Low Potential Dysgraphia : {res['prob_low_potential']}%")
            prob_pot_lbl.config(text=f"• Potential Dysgraphia     : {res['prob_potential']}%")
            progress_bar['value'] = res['prob_potential']
            
            f = res['features']
            metric_vars['waviness'].set(f"• Baseline Waviness (Gelombang Baris) : {f['baseline_waviness']:.2f}")
            metric_vars['height_cov'].set(f"• Height Variation (Inkonsistensi CoV): {f['height_cov']:.2f}")
            metric_vars['slant_std'].set(f"• Slant Variation (Ketidakteraturan)  : {f['slant_angle_std']:.2f}°")
            metric_vars['roughness'].set(f"• Stroke Roughness (Kerutan Goresan)  : {f['stroke_roughness_mean']:.2f}")
            metric_vars['ink_dens'].set(f"• Ink Density (Kerapatan Tinta)       : {f['ink_density']:.3f}")
            
            status_bar.config(text=f"Selesai: {Path(file_path).name} -> {res['predicted_label']} ({res['confidence_score']}%) [{res['mode_desc']}]")
        except Exception as err:
            messagebox.showerror("Gagal Menganalisis Gambar", f"Terjadi kesalahan: {str(err)}")
            status_bar.config(text="Gagal menganalisis gambar.")

    root.mainloop()


# =============================================================================
# Main Entry Point
# =============================================================================
if __name__ == "__main__":
    if len(sys.argv) > 1:
        target_img = sys.argv[1]
        run_cli(target_img)
    else:
        run_gui()
